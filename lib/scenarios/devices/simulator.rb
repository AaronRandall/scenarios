module Scenarios
  module Devices
    require 'fileutils'

    class Simulator
      def initialize(options, tests_to_run)
        @options = options
        @tests_to_run = tests_to_run
      end

      def sdk
        'iphonesimulator'
      end

      def clean_target
        Scenarios::Logger.info('Deleting any existing simulator apps') 
        FileUtils.rm_rf(Dir.glob("#{simulator_path}/*"))
      end

      def install_app
        Scenarios::Logger.info('Installing and launching in simulator')
        system "ios-sim launch '#{@options.ios_app_path}/build/Debug-iphonesimulator/#{@options.ios_app_name}.app' &"

        Scenarios::Logger.info('Waiting for app to launch')
        sleep 20
      end

      def run_tests
        @tests_to_run.each do |test|
          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} '#{@options.ios_app_name}' #{test} '#{@options.tests_output_path}' #{'-d dynamic' if @options.run_on_device} -p -j '#{@options.test_variables}'"
          Scenarios::Logger.info( "Running test '#{test}'")
          system command_to_run

          if $? != 0
            raise "[ERROR: Test '#{test}' failed"
          end
        end
      end

      private

      def simulator_path
        @simulator_path ||= find_simulator_path
      end

      def find_simulator_path
        iphone_simulator_path = File.expand_path(IPHONE_SIMULATOR_PATH)

        iphone_simulators = Dir.glob("#{iphone_simulator_path}/[0-9]*")
        if iphone_simulators.size == 0
          raise RuntimeError, "No iPhone simulators found in #{iphone_simulator_path}"
        end
    
        iphone_simulators.last
      end

    end
  end
end
