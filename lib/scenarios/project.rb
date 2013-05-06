module Scenarios
  class Project

    def initialize(options, test_device)
      @ops = options
      @test_device = test_device
    end

    def clean_build_directory
      Logger.log('Deleting any existing builds from the project path')

      FileUtils.rm_rf(Dir.glob("#{@ops.ios_app_path}/build/*"))
    end

    def build_app
      Logger.log('Building the app')

      Dir.chdir("#{@ops.ios_app_path}") do
        system "xcodebuild -sdk #{@test_device.sdk} -configuration Debug clean build > /dev/null"
      end
    end

    def create_test_support_files
      Logger.log('Creating test support files')

      support_dir = "#{@ops.tests_path}/support"
      FileUtils.mkdir_p(support_dir) unless File.directory?(support_dir)

      support_automation_dir = support_dir + '/automation_library'
      FileUtils.mkdir_p(support_automation_dir) unless File.directory?(support_automation_dir)

      # Copy all automation library .js files to the tests support folder
      FileUtils.cp(SCENARIOS_SCRIPT_PATH, support_dir)
      FileUtils.cp(HELPERS_SCRIPT_PATH,   support_dir)
      FileUtils.cp_r(AUTOMATION_LIBRARY_PATH, support_automation_dir)
    end

  end
end
