["bassoon", "clarinet", "flute", "oboe", "trombone", "trumpet"].each do |instrument|
  `cp saxophone/Saxophone.plist #{instrument}/#{instrument.capitalize}.plist`
  `cp saxophone/InstrumentList.plist #{instrument}/InstrumentList.plist`
end