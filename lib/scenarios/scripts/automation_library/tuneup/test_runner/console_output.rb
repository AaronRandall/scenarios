class ConsoleOutput
  def add(line)
    puts line
  end
  
  def add_status(status, date, time, time_zone, msg)
    puts "\n" if status == :start     # add a blank line before each test to visually group the output
    puts format(status, date, time, time_zone, msg)
  end

  def add_minimal_status(status, date, time, time_zone, msg)
    print '.' if status == :pass 
    print 'F' if status == :fail 
  end
  
  def format(status, date, time, time_zone, msg)
    "#{date} #{time} #{time_zone} #{status.to_s.capitalize}: #{msg}"
  end
  
  def close
  end
end
