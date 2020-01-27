Facter.add("is_adobereader_installed") do
  confine :operatingsystem => 'windows'
  setcode do
    if File.file?('C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe')
        true
    else
        false
    end
  end
end
