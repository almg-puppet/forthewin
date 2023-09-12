# Executa apenas se o arquivo não existir ou a data for anterior à atual
def is_running?(process_name)
  cmd = %Q[tasklist /FI "IMAGENAME eq #{process_name}" 2>NUL | find /I "#{process_name}"]
  #puts cmd    
  result = %x[#{cmd}]
  #puts ">>>#{result}<<<"
  result.empty? ? false : true
end

Facter.add("is_firefox_running") do
  confine :operatingsystem => 'windows'
  setcode do
    is_running?('firefox.exe')
  end
end

Facter.add("is_libreoffice_running") do
  confine :operatingsystem => 'windows'
  setcode do
    is_running?('soffice.bin')
  end
end

Facter.add("is_thunderbird_running") do
  confine :operatingsystem => 'windows'
  setcode do
    is_running?('thunderbird.exe')
  end
end

Facter.add("is_gimp_running") do
  confine :operatingsystem => 'windows'
  setcode do
    #https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals
    process_name_regex = %q[gimp-[0-9][0-9]*\.[0-9][0-9]*\.exe]
    cmd = %Q[tasklist 2>NUL | findstr /I /R #{process_name_regex}]
    #puts cmd    
    result = %x[#{cmd}]
    #puts ">>>#{result}<<<"
    result.empty? ? false : true
  end
end