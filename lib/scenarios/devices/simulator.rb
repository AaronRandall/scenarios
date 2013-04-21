module Scenarios
  module Devices
    class Simulator < TestDevice
      def clean_target
        log('Deleting any existing simulator apps') 
        FileUtils.rm_rf(Dir.glob("#{OPTS[:simulator_path]}/*"))
      end

      def clean_project_build_directory
        log('Deleting any existing builds from the project path')
        FileUtils.rm_rf(Dir.glob("#{OPTS[:ios_app_path]}/build/*"))
      end

      def build_app
        log('Building the App')
        sdk = "iphonesimulator"

        Dir.chdir("#{OPTS[:ios_app_path]}") do
          system "xcodebuild -sdk #{sdk} -configuration Debug clean build > /dev/null"
        end
      end

      def install_app
        log('Installing and launching in simulator')
        system "ios-sim launch #{OPTS[:ios_app_path]}/build/Debug-iphonesimulator/#{OPTS[:ios_app_name]}.app &"

        log('Waiting for App to launch')
        sleep 15

        log('Accepting location services')
        system "osascript #{SCRIPT_PATH}/accept_location_services.scpt"
        sleep 3
      end

      def run_tests
        @tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          kill_simulator_and_instruments

          command_to_run = "#{TUNEUP_BIN} #{OPTS[:ios_app_name]} #{test} #{OUTPUT_PATH} #{'-d dynamic' if OPTS[:run_on_device]} -p -j #{username_password_parameter}"
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
