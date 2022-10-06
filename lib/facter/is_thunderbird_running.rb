Facter.add("is_thunderbird_running") do
  confine :operatingsystem => 'windows'
  setcode do

    process_name = 'thunderbird.exe'
    #https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals
    cmd = %Q[tasklist /FI "IMAGENAME eq #{process_name}" 2>NUL | find /I "#{process_name}"]
    #puts cmd    
    result = %x[#{cmd}]
    #puts ">>>#{result}<<<"

    # Return string because old facter versions, like the 2.x used by Windows XP, don't know boolean
    result.empty? ? 'false' : 'true'

  end
end