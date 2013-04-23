module Scenarios
  module Devices
    require ROOT + 'devices/shared_steps'
    require 'fileutils'

    class Hardware < BaseDevice
      def clean_target
        # Nothing to do here as the ability to delete 
        # apps from devices is not currently supported
      end

      def clean_project_build_directory
        SharedSteps.clean_project_build_directory(@ops.ios_app_path)
      end

      def build_app
        SharedSteps.build_app(@ops.ios_app_path, "iphoneos6.0")
      end

      def install_app
        Logger.log('Installing on hardware')
        system "#{SCRIPT_PATH}/transporter_chief.rb #{@ops.hardware_id.nil? ? '' : "--device " + @ops.hardware_id} #{@ops.ios_app_path}/build/Debug-iphoneos/#{@ops.ios_app_name}.app"
      end

      def create_test_support_files
        SharedSteps.create_test_support_files(@ops.tests_path)
      end

      def run_tests
        @ops.tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          Scenarios.kill_simulator

          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} #{@ops.ios_app_name} #{test} #{@ops.tests_output_path} -d #{@ops.hardware_id.nil? ? 'dynamic' : @ops.hardware_id} -p -j #{@ops.test_variables}"
          Logger.log( "Running test #{test} (#{command_to_run})")
          system command_to_run

          if $? != 0
            Scenarios.kill_simulator
            raise "[ERROR: Test '#{test}' failed" and return
          end
          
          Scenarios.kill_simulator
        end
      end
    end
  end
end
