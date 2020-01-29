Facter.add("is_adobereaderxi_installed") do
  confine :operatingsystem => 'windows'
  setcode do
    if File.file?('C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe')
        true
    else
        false
    end
  end
end


Facter.add("is_adobereaderdc_installed") do
  confine :operatingsystem => 'windows'
  setcode do
    if File.file?('C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe')
        true
    else
        false
    end
  end
end