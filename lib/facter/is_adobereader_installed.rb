Facter.add("is_adobereaderxi_installed") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    if File.file?('C:\Program Files (x86)\Adobe\Reader 11.0\Reader\AcroRd32.exe')
        true
    else
        false
    end
  end
end

Facter.add("adobereaderxi_version") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    version = '0.0.0'
    if Facter.value(:is_adobereaderxi_installed)
      reg = `reg query "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\68AB67CA7DA76401B744BA0000000010\\InstallProperties" /v DisplayVersion | find /i "displayversion"`
      if !reg.empty?
        version = reg.split()[2]
      end
    end
    version
  end
end

Facter.add("is_adobereaderdc_installed") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    if File.file?('C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe')
        true
    else
        false
    end
  end
end

Facter.add("adobereaderdc_version") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    version = '0.0.0'
    if Facter.value(:is_adobereaderdc_installed)
      reg = `reg query "HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Installer\\UserData\\S-1-5-18\\Products\\68AB67CA7DA76401B744CAF070E41400\\InstallProperties" /v DisplayVersion | find /i "displayversion"`
      if !reg.empty?
        version = reg.split()[2]
      end
    end
    version
  end
end