Facter.add("is_libreoffice_installed") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    if File.file?('C:\Program Files\LibreOffice\program\soffice.exe')
        true
    else
        false
    end
  end
end

Facter.add("libreoffice_version") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    version = '0.0.0'
    if Facter.value(:is_libreoffice_installed)
      reg = Facter::Core::Execution.execute('powershell -command "(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like \'*LibreOffice*\' -and $_.DisplayName -notlike \'*Help*\'}).DisplayVersion"')
      if !reg.empty?
        version = reg.split()[0]
      end
    end
    version
  end
end

Facter.add("libreoffice_help_version") do
  confine :os do |os|
    os['name'] == 'windows'
  end
  setcode do
    version = '0.0.0'
    reg = Facter::Core::Execution.execute('powershell -command "(Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Where-Object { $_.DisplayName -like \'*LibreOffice*\' -and $_.DisplayName -like \'*Help*\'}).DisplayVersion"')
    if !reg.empty?
      version = reg.split()[0]
    end
    version
  end
end