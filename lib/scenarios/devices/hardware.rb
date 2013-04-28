module Scenarios
  module Devices
    require 'fileutils'

    class Hardware
      def initialize(options, tests_to_run)
        @ops = options
        @tests_to_run = tests_to_run
      end

      def sdk
        @ios_sdk ||= find_ios_sdk
      end

      def clean_target
        # Nothing to do here as the ability to delete app
        # from hardware devices is currently not supported
      end

      def install_app
        Logger.log('Installing on device')
        system "#{APP_DEPLOYER} #{@ops.hardware_id.nil? ? '' : "--device " + @ops.hardware_id} #{@ops.ios_app_path}/build/Debug-iphoneos/#{@ops.ios_app_name}.app"
      end

      def run_tests
        @tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          Scenarios.kill_simulator

          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} #{@ops.ios_app_name} #{test} #{@ops.tests_output_path} -d #{@ops.hardware_id.nil? ? 'dynamic' : @ops.hardware_id} #{"-p -j" + @ops.test_variables if @ops.test_variables}"
          Logger.log( "Running test #{test} (#{command_to_run})")
          system command_to_run

          if $? != 0
            raise "[ERROR: Test '#{test}' failed" and return
          end
        end
      end

      private

      def find_ios_sdk
        ios_sdks = []

        all_sdks = `xcodebuild -showsdks`
        all_sdks.each_line do |current_sdk| 
          if current_sdk =~ /-sdk iphoneos/
            ios_sdks.push(current_sdk.split('-sdk').last.strip)
          end
        end

        if ios_sdks.size == 0
          raise RuntimeError, "No iOS SDK found"
        end

        ios_sdks.last
      end

    end
  end
end
