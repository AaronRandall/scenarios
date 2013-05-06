module Scenarios
  module Devices
    require 'fileutils'

    class Simulator
      def initialize(options, tests_to_run)
        @ops = options
        @tests_to_run = tests_to_run
      end

      def sdk
        'iphonesimulator'
      end

      def clean_target
        Logger.log('Deleting any existing simulator apps') 
        FileUtils.rm_rf(Dir.glob("#{simulator_path}/*"))
      end

      def install_app
        Logger.log('Installing and launching in simulator')
        system "ios-sim launch '#{@ops.ios_app_path}/build/Debug-iphonesimulator/#{@ops.ios_app_name}.app' &"

        Logger.log('Waiting for app to launch')
        sleep 20
      end

      def run_tests
        Logger.log('Running tests')
        @tests_to_run.each do |test|
          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} '#{@ops.ios_app_name}' #{test} '#{@ops.tests_output_path}' #{'-d dynamic' if @ops.run_on_device} -p -j '#{@ops.test_variables}'"
          Logger.log( "Running test #{test} (#{command_to_run})")
          system command_to_run

          if $? != 0
            raise "[ERROR: Test '#{test}' failed" and return
          end
        end
      end

      private

      def simulator_path
        @simulator_path ||= find_simulator_path
      end

      def find_simulator_path
        iphone_simulator_path = File.expand_path("~/Library/Application\ Support/iPhone\ Simulator/")

        iphone_simulators = Dir.glob("#{iphone_simulator_path}/[0-9]*")
        if iphone_simulators.size == 0
          raise RuntimeError, "No iPhone simulators found in #{iphone_simulator_path}"
        end
    
        iphone_simulators.last
      end

    end
  end
end
