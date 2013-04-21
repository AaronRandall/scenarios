module Scenarios
  require ROOT + 'devices'

  AUTOMATION_LIBRARY = ROOT + 'automation_library/tuneup/test_runner/run'
  SCRIPT_PATH        = ROOT + 'bin/scripts'

  class Runner
    def initialize(params)
      @ios_app_path      = params[:ios_app_path]
      @tests_path        = params[:tests_path]
      @test_name         = params[:test_name]
      @run_on_hardware   = params[:run_on_hardware]
      @hardware_id       = params[:hardware_id]
      @test_variables    = params[:test_variables]
      @clean_target      = params[:clean_target]
      @clean_project_dir = params[:clean_project_dir]
      @build_app         = params[:build_app]
      @install_app       = params[:install_app]
      @run_tests         = params[:run_tests]
    end

    def run
      puts "In run for app path=#{@ios_app_path}"

      tests_to_run = []
      if @test_name
        tests_to_run.push("#{@tests_path}/#{@test_name}")
      else
        Dir["#{@tests_path}/*_test.js"].each {|test| tests_to_run.push(test) }
      end

      if @run_on_hardware or @hardware_id
        test_device = Devices::Hardware.new(tests_to_run, @test_variables, @hardware_id)
      else
        test_device = Devices::Simulator.new(tests_to_run, @test_variables)
      end

      run_test_steps(test_device) 
    end

    private
    
    def run_test_steps(test_device)
      # kill any stale sim/instrument processes
      kill_simulator_and_instruments

      test_device.clean_target                  if @clean_target
      test_device.clean_project_build_directory if @clean_project_build_directory
      test_device.build_app                     if @build_app
      test_device.install_app                   if @install_app
      test_device.run_tests                     if @run_tests
    end

    def kill_simulator_and_instruments
      log('Killing simulator (if running)')
      system "killall 'iPhone Simulator'"
      log('Killing instruments (if running)')
      system "killall 'instruments'"
    end

    def log(message)
      puts "[INFO]: #{message}"
    end

  end
end
