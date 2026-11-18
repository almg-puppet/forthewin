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
      reg = Facter::Core::Execution.execute('powershell -NoProfile -Command "Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue | ForEach-Object { try { $n = $_.GetValue(\'DisplayName\'); if ($n -like \'*LibreOffice*\' -and $n -notmatch \'Help Pack|SDK|Language Pack\') { $_.GetValue(\'DisplayVersion\') } } catch {} } | Select-Object -First 1"')
      
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
    reg = Facter::Core::Execution.execute('powershell -NoProfile -Command "Get-ChildItem HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall,HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall -ErrorAction SilentlyContinue | ForEach-Object { try { $n = $_.GetValue(\'DisplayName\'); if ($n -like \'*LibreOffice*\' -and $n -like \'*Help*\') { $_.GetValue(\'DisplayVersion\') } } catch {} } | Select-Object -First 1"')
    if !reg.empty?
      version = reg.split()[0]
    end
    version
  end
end