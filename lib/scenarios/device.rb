module Scenarios
  class Device
    require ROOT + 'devices/simulator'
    require ROOT + 'devices/hardware'

    def self.new(options, tests_to_run)
      @ops = options

      if @ops.run_on_hardware or @ops.hardware_id
        test_device = Devices::Hardware.new(@ops, tests_to_run)
      else
        test_device = Devices::Simulator.new(@ops, tests_to_run)
      end

      return test_device
    end

  end
end
