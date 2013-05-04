module Scenarios
  require 'ostruct'
  require ROOT + 'device'
  require ROOT + 'project'

  SCRIPTS_PATH              = ROOT + 'scripts/'
  SCENARIOS_SCRIPT_PATH     = SCRIPTS_PATH + 'scenarios.js'
  HELPERS_SCRIPT_PATH       = SCRIPTS_PATH + 'helpers.js'
  AUTOMATION_LIBRARY_PATH   = SCRIPTS_PATH + 'automation_library/tuneup/'
  AUTOMATION_LIBRARY_RUNNER = AUTOMATION_LIBRARY_PATH + 'test_runner/run'
  APP_DEPLOYER              = ROOT + 'app_deployer/transporter_chief.rb'

  class Runner
    def initialize(options)
      @ops = OpenStruct.new(options)
    end

    def run
      Scenarios.kill_simulator
      test_device = Device.new(@ops, tests_to_run)
      project     = Project.new(@ops, test_device)
      run_test_steps(test_device, project) 
    end

    private

    def run_test_steps(test_device, project)
      project.create_test_support_files
      project.clean_build_directory     if @ops.clean_project_build_directory
      project.build_app                 if @ops.build_app
      test_device.clean_target          if @ops.clean_target
      test_device.install_app           if @ops.install_app
      test_device.run_tests
    end

    def tests_to_run
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
  end

  def self.kill_simulator
    # kill any stale simulator and Instrument processes
    Logger.log('Killing simulator and Instruments')
    system "killall 'iPhone Simulator' &> /dev/null"

    instrument_pids = `/usr/bin/pgrep -i '^instruments$'`
    if $? == 0 then
      instrument_pids.gsub(/\s+/, " ").each do |stale_instrument_pid|
        `kill -9 #{stale_instrument_pid}`
      end
    end
  end
end
