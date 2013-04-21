module Scenarios
  module Devices
    require 'fileutils'

    class Hardware < TestDevice
      def initialize(tests_to_run, test_username, test_password, hardware_id)
        super(tests_to_run, test_username, test_password)
        @hardware_id = hardware_id
      end

      def clean_target
        # Nothing to do here.  In future, could try and delete app from hardware.
      end

      def clean_project_build_directory
        log('Deleting any existing builds from the project path')
        FileUtils.rm_rf(Dir.glob("#{OPTS[:ios_app_path]}/build/*"))
      end

      def build_app
        log('Building the App')
        sdk = "iphoneos6.0"

        Dir.chdir("#{OPTS[:ios_app_path]}") do
          system "xcodebuild -sdk #{sdk} -configuration Debug clean build > /dev/null"
        end
      end

      def install_app
        log('Installing on hardware')
        system "#{SCRIPT_PATH}/transporter_chief.rb #{@hardware_id.nil? ? '' : "--device " + @hardware_id} #{OPTS[:ios_app_path]}/build/Debug-iphoneos/#{OPTS[:ios_app_name]}.app"
      end

      def run_tests
        @tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          kill_simulator_and_instruments

          command_to_run = "#{TUNEUP_BIN} #{OPTS[:ios_app_name]} #{test} #{OUTPUT_PATH} -d #{@hardware_id.nil? ? 'dynamic' : @hardware_id} -p -j #{username_password_parameter}"
          log( "Running test #{test} (#{command_to_run})")
          system command_to_run

          if $? != 0
            kill_simulator_and_instruments
            raise "[ERROR]: Test '#{test}' failed" and return
          end
          
          kill_simulator_and_instruments
        end
      end
    end
  end
end
