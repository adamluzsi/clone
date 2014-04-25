### set app name
begin
  folder_path_array= File.expand_path(File.dirname(__FILE__)).split(File::SEPARATOR)
  2.times do
    folder_path_array.pop
  end
  $0= folder_path_array.last
end