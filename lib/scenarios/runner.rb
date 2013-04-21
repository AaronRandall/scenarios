module Scenarios
  require ROOT + 'devices'
  require 'ostruct'

  AUTOMATION_LIBRARY = ROOT + 'automation_library/tuneup/test_runner/run'
  SCRIPT_PATH        = ROOT + 'bin/scripts'

  class Runner
    def initialize(options)
      @ops = OpenStruct.new(options)
    end

    def run
      puts "In run for app path=#{@ops.ios_app_path}"

      tests_to_run = []
      if @ops.test_name
        tests_to_run.push("#{@ops.tests_path}/#{@ops.test_name}")
      else
        Dir["#{@ops.tests_path}/*_test.js"].each {|test| tests_to_run.push(test) }
      end

      if @ops.run_on_hardware or @ops.hardware_id
        test_device = Devices::Hardware.new(@ops)
      else
        test_device = Devices::Simulator.new(@ops)
      end

      run_test_steps(test_device) 
    end

    private
    
    def run_test_steps(test_device)
      # kill any stale sim/instrument processes
      kill_simulator_and_instruments

      test_device.clean_target                  if @ops.clean_target
      test_device.clean_project_build_directory if @ops.clean_project_build_directory
      test_device.build_app                     if @ops.build_app
      test_device.install_app                   if @ops.install_app
      test_device.run_tests                     if @ops.run_tests
    end

    def kill_simulator_and_instruments
      Logger.log('Killing simulator (if running)')
      system "killall 'iPhone Simulator'"
      Logger.log('Killing instruments (if running)')
      system "killall 'instruments'"
    end
  end
end
