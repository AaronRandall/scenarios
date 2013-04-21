module Scenarios
  module Devices
    class TestDevice
      def initialize(tests_to_run, test_variables = nil)
        @tests_to_run   = tests_to_run
        @test_variables = test_variables
      end

      def clean_target
        raise NotImplementedError
      end

      def clean_project_build_directory
        raise NotImplementedError
      end

      def build_app
        raise NotImplementedError
      end

      def install_app
        raise NotImplementedError
      end

      def run_tests
        raise NotImplementedError
      end
    end
  end
end
