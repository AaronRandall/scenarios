module Scenarios
  require ROOT + 'devices'

  TUNEUP_BIN   = ROOT + 'tuneup/test_runner/run'
  TESTS_PATH   = ROOT + 'tests'
  OUTPUT_PATH  = ROOT + 'output'
  SCRIPT_PATH  = ROOT + 'bin/scripts'

  class Runner
    def initialize(params)
      @ios_app_path      = params[:ios_app_path]
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
      if OPTS[:test_name]
        # Run a single test supplied by the user
        tests_to_run.push("#{TESTS_PATH}/#{OPTS[:test_name]}")
      else
        # Run all tests
        Dir["#{TESTS_PATH}/*_test.js"].each {|test| tests_to_run.push(test) }
      end

      # Determine the target to run the tests on
      if OPTS[:run_on_hardware] or OPTS[:hardware_id]
        test_device = Hardware.new(tests_to_run, OPTS[:test_variables], OPTS[:hardware_id])
      else
        test_device = Simulator.new(tests_to_run, OPTS[:test_variables])
      end

      # kill any stale sim/instrument processes
      kill_simulator_and_instruments

      test_device.clean_target                  if OPTS[:clean_target]
      test_device.clean_project_build_directory if OPTS[:clean_project_build_directory]
      test_device.build_app                     if OPTS[:build_app]
      test_device.install_app                   if OPTS[:install_app]
      test_device.run_tests                     if OPTS[:run_tests]
    end

    def kill_simulator_and_instruments
      log('Killing simulator (if running)')
      system "killall 'iPhone Simulator'"
      log('Killing instruments (if running)')
      system "killall 'instruments'"
    end
  end
end
