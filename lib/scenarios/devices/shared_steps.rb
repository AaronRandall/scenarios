module Scenarios
  module Devices
    module SharedSteps

      def self.clean_project_build_directory(ios_app_path)
        Logger.log('Deleting any existing builds from the project path')
        FileUtils.rm_rf(Dir.glob("#{ios_app_path}/build/*"))
      end

      def self.build_app(ios_app_path, sdk)
        Logger.log('Building the App')

        Dir.chdir("#{ios_app_path}") do
          system "xcodebuild -sdk #{sdk} -configuration Debug clean build > /dev/null"
        end
      end

      def self.create_test_support_files(tests_path)
        Logger.log('Creating test support files')
        support_dir = "#{tests_path}/support"
        FileUtils.mkdir_p(support_dir) unless File.directory?(support_dir)

        support_automation_dir = support_dir + '/automation_library'
        FileUtils.mkdir_p(support_automation_dir) unless File.directory?(support_automation_dir)

        # Copy all automation library .js files to the tests support folder
        FileUtils.cp(SCENARIOS_SCRIPT_PATH, support_dir)
        FileUtils.cp_r(AUTOMATION_LIBRARY_PATH, support_automation_dir)
      end

    end
  end
end
