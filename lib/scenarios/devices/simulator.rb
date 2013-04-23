module Scenarios
  module Devices
    require ROOT + 'devices/shared_steps'
    require 'fileutils'

    class Simulator < BaseDevice
      def clean_target
        Logger.log('Deleting any existing simulator apps') 
        FileUtils.rm_rf(Dir.glob("#{@ops.simulator_path}/*"))
      end

      def clean_project_build_directory
        SharedSteps.clean_project_build_directory(@ops.ios_app_path)
      end

      def build_app
        SharedSteps.build_app(@ops.ios_app_path, "iphonesimulator")
      end

      def install_app
        Logger.log('Installing and launching in simulator')
        system "ios-sim launch '#{@ops.ios_app_path}/build/Debug-iphonesimulator/#{@ops.ios_app_name}.app' &"

        Logger.log('Waiting for App to launch')
        sleep 15
      end

      def create_test_support_files
        SharedSteps.create_test_support_files(@ops.tests_path)
      end

      def run_tests
        Logger.log('Running tests')
        @ops.tests_to_run.each do |test|
          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} '#{@ops.ios_app_name}' #{test} '#{@ops.tests_output_path}' #{'-d dynamic' if @ops.run_on_device} -p -j '#{@ops.test_variables}'"
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
