module Scenarios
  module Devices
    require 'fileutils'

    class Simulator < TestDevice
      def clean_target
        Logger.log('Deleting any existing simulator apps') 
        puts "* simpath=#{@ops.simulator_path}"
        puts "* @ops=#{@ops.inspect}"
        #FileUtils.rm_rf(Dir.glob("#{@ops.simulator_path}/*"))
      end

      def clean_project_build_directory
        Logger.log('Deleting any existing builds from the project path')
        puts "* apppath=#{@ops.ios_app_path}"
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

      def run_tests
        @tests_to_run.each do |test|
          # Quit any stale instances of the simulator and instruments
          kill_simulator_and_instruments

          command_to_run = "#{TUNEUP_BIN} #{@ops.ios_app_name} #{test} #{OUTPUT_PATH} #{'-d dynamic' if @ops.run_on_device} -p -j #{username_password_parameter}"
          Logger.log( "Running test #{test} (#{command_to_run})")
          system command_to_run

          if $? != 0
            kill_simulator_and_instruments
            raise "[ERROR: Test '#{test}' failed" and return
          end

          kill_simulator_and_instruments
        end
      end
    end
  end
end
