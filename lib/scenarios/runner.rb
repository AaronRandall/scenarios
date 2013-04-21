module Scenarios
  require ROOT + 'devices'
  require 'ostruct'

  AUTOMATION_LIBRARY = ROOT + 'automation_library/tuneup/test_runner/run'

  class Runner
    def initialize(options)
      options[:simulator_path] = find_simulator_path
      options[:tests_to_run]   = []
      @ops = OpenStruct.new(options)
    end

    def run
      if @ops.test_name
        @ops.tests_to_run.push("#{@ops.tests_path}/#{@ops.test_name}")
      else
        Dir["#{@ops.tests_path}/*_test.js"].each {|test| @ops.tests_to_run.push(test) }
      end

      if @ops.tests_to_run.nil? || @ops.tests_to_run.size == 0
        raise RuntimeError, "No tests found in #{@ops.tests_path}"
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
      Scenarios.kill_simulator_and_instruments

      test_device.clean_target                  if @ops.clean_target
      test_device.clean_project_build_directory if @ops.clean_project_build_directory
      test_device.build_app                     if @ops.build_app
      test_device.install_app                   if @ops.install_app
      test_device.run_tests                     if @ops.run_tests
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

  def self.kill_simulator_and_instruments
    Logger.log('Killing simulator (if running)')
    system "killall 'iPhone Simulator'"
    Logger.log('Killing instruments (if running)')
    system "killall 'instruments'"
  end

end
