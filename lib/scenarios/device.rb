module Scenarios
  class Device
    require ROOT + 'devices/simulator'
    require ROOT + 'devices/hardware'

    def self.new(options, tests_to_run)
      @options = options

      if @options.run_on_hardware or @options.hardware_id
        test_device = Devices::Hardware.new(@options, tests_to_run)
      else
        test_device = Devices::Simulator.new(@options, tests_to_run)
      end

      return test_device
    end

  end
end
