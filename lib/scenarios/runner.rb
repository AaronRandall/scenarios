module Scenarios
  require ROOT + 'devices'
  require ROOT + 'project'
  require 'ostruct'

  SCRIPTS_PATH              = ROOT + 'scripts/'
  SCENARIOS_SCRIPT_PATH     = SCRIPTS_PATH + 'scenarios.js'
  AUTOMATION_LIBRARY_PATH   = SCRIPTS_PATH + 'automation_library/tuneup/'
  AUTOMATION_LIBRARY_RUNNER = AUTOMATION_LIBRARY_PATH + 'test_runner/run'
  APP_DEPLOYER              = ROOT + 'app_deployer/transporter_chief.rb'

  class Runner
    def initialize(options)
      options[:simulator_path] = find_simulator_path
      options[:tests_to_run]   = []
      @ops = OpenStruct.new(options)
    end

    def run
      @ops.tests_to_run = find_tests_to_run
      test_device = get_test_device
      project     = Project.new(@ops, test_device)

      run_test_steps(test_device, project) 
    end

    private

    def run_test_steps(test_device, project)
      Scenarios.kill_simulator

      project.create_test_support_files
      project.clean_build_directory     if @ops.clean_project_build_directory
      project.build_app                 if @ops.build_app
      test_device.clean_target          if @ops.clean_target
      test_device.install_app           if @ops.install_app
      test_device.run_tests
    end

    def find_simulator_path
      iphone_simulator_path = File.expand_path("~/Library/Application\ Support/iPhone\ Simulator/")

      iphone_simulators = Dir.glob("#{iphone_simulator_path}/[0-9]*")
      if iphone_simulators.size == 0
        raise RuntimeError, "No iPhone simulators found in #{iphone_simulator_path}"
      end
  
      iphone_simulators.last
    end

    def find_tests_to_run
      tests_to_run = []
      if @ops.test_name
        tests_to_run.push("#{@ops.tests_path}/#{@ops.test_name}")
      else
        Dir["#{@ops.tests_path}/*_test.js"].each {|test| tests_to_run.push(test) }
      end

      if tests_to_run.nil? || tests_to_run.size == 0
        raise RuntimeError, "No tests found in #{@ops.tests_path}"
      end

      tests_to_run
    end

    def get_test_device
      if @ops.run_on_hardware or @ops.hardware_id
        test_device = Devices::Hardware.new(@ops)
      else
        test_device = Devices::Simulator.new(@ops)
      end
    end
  end

  def self.kill_simulator
    # kill any stale simulator processes
    Logger.log('Killing simulator (if running)')
    system "killall 'iPhone Simulator' &> /dev/null"
  end

end
