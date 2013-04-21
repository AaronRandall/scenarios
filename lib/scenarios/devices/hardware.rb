module Scenarios
  module Devices
    require 'fileutils'

    class Hardware < TestDevice
      def clean_target
        # Nothing to do here.  In future, could try and delete app from hardware.
      end

      def clean_project_build_directory
        log('Deleting any existing builds from the project path')
        FileUtils.rm_rf(Dir.glob("#{@ops.ios_app_path}/build/*"))
      end

      def build_app
        log('Building the App')
        sdk = "iphoneos6.0"

        Dir.chdir("#{@ops.ios_app_path}") do
          system "xcodebuild -sdk #{sdk} -configuration Debug clean build > /dev/null"
        end
      end

      def install_app
        log('Installing on hardware')
        system "#{SCRIPT_PATH}/transporter_chief.rb #{@ops.hardware_id.nil? ? '' : "--device " + @ops.hardware_id} #{@ops.ios_app_path}/build/Debug-iphoneos/#{@ops.ios_app_name}.app"
      end

      def create_test_support_files
        support_dir = File.dirname("#{@ops.tests_path}/support")

        unless File.directory?(support_dir)
          FileUtils.mkdir_p(support_dir)
        end

        File.open("#{support_dir}/support/scenarios.js", "w") do |f|     
          f.write("#import '#{AUTOMATION_LIBRARY_SCRIPT}'")
        end
      end

      def run_tests
        @ops.tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          Scenarios.kill_simulator_and_instruments

          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} #{@ops.ios_app_name} #{test} #{@ops.tests_output_path} -d #{@ops.hardware_id.nil? ? 'dynamic' : @ops.hardware_id} -p -j #{@ops.test_variables}"
          log( "Running test #{test} (#{command_to_run})")
          system command_to_run

          if $? != 0
            Scenarios.kill_simulator_and_instruments
            raise "[ERROR: Test '#{test}' failed" and return
          end
          
          Scenarios.kill_simulator_and_instruments
        end
      end
    end
  end
end
