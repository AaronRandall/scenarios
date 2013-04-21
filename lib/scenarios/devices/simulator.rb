module Scenarios
  module Devices
    require 'fileutils'

    class Simulator < TestDevice
      def clean_target
        Logger.log('Deleting any existing simulator apps') 
        #FileUtils.rm_rf(Dir.glob("#{@ops.simulator_path}/*"))
      end

      def clean_project_build_directory
        Logger.log('Deleting any existing builds from the project path')
        #FileUtils.rm_rf(Dir.glob("#{@ops.ios_app_path}/build/*"))
      end

      def build_app
        Logger.log('Building the App')
        sdk = "iphonesimulator"

        Dir.chdir("#{@ops.ios_app_path}") do
          system "xcodebuild -sdk #{sdk} -configuration Debug clean build > /dev/null"
        end
      end

      def install_app
        Logger.log('Installing and launching in simulator')
        system "ios-sim launch '#{@ops.ios_app_path}/build/Debug-iphonesimulator/#{@ops.ios_app_name}.app' &"

        Logger.log('Waiting for App to launch')
        sleep 15

        #system "osascript #{SCRIPT_PATH}/accept_location_services.scpt"
      end

      def create_test_support_files
        support_dir = File.dirname("#{@ops.tests_path}/support")

        unless File.directory?(support_dir)
          FileUtils.mkdir_p(support_dir)
        end

        # this file should prob already exist in a single folder with
        # tuneup files, then just copy the entire thing into test support folder
        File.open("#{support_dir}/support/scenarios.js", "w") do |f|     
          f.write("#import \"automation_library/tuneup.js\"")
        end
      end

      def run_tests
        @ops.tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          Scenarios.kill_simulator_and_instruments

          command_to_run = "#{AUTOMATION_LIBRARY_RUNNER} '#{@ops.ios_app_name}' #{test} '#{@ops.tests_output_path}' #{'-d dynamic' if @ops.run_on_device} -p -j '#{@ops.test_variables}'"
          Logger.log( "Running test #{test} (#{command_to_run})")
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
