module Scenarios
  module Devices
    class TestDevice
      def initialize(options)
        @ops = options
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

      def create_test_support_files
        raise NotImplementedError
      end

      def run_tests
        raise NotImplementedError
      end
    end
  end
end
