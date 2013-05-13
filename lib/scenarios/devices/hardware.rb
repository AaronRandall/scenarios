module Scenarios
  module Devices
    require 'fileutils'

    class Hardware
      def initialize(options, tests_to_run)
        @options = options
        @tests_to_run = tests_to_run
      end

      def sdk
        @ios_sdk ||= find_ios_sdk
      end

      def clean_target
        # Nothing to do here as the ability to delete apps
        # from hardware devices is currently not supported
      end

      def install_app
        Scenarios::Logger.info('Installing on device')
        system "#{APP_DEPLOYER} #{@options.hardware_id.nil? ? '' : "--device " + @options.hardware_id} #{@options.ios_app_path}/build/Debug-iphoneos/#{@options.ios_app_name}.app"
      end

      def run_tests
        @tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          Scenarios.kill_simulator

          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} #{@options.ios_app_name} #{test} #{@options.tests_output_path} -d #{@options.hardware_id.nil? ? 'dynamic' : @options.hardware_id} #{"-p -j" + @options.test_variables if @options.test_variables}"
          Scenarios::Logger.info( "Running test '#{test}'")
          system command_to_run

          if $? != 0
            raise "[ERROR: Test '#{test}' failed"
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
