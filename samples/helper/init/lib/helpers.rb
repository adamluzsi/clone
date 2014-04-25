Dir.glob(
    File.join(
      Dir.pwd,
      File.dirname(__FILE__).split(File::SEPARATOR).last,
      __FILE__.split(File::SEPARATOR).last.split('.')[0],'**',"*.{rb,rb}")
).uniq.each do |one_helper|
  require one_helper
end