Facter.add("is_gimp_running") do
  confine :operatingsystem => 'windows'
  setcode do

    #https://en.wikibooks.org/wiki/Ruby_Programming/Syntax/Literals
    process_name_regex = %q[gimp-[0-9][0-9]*\.[0-9][0-9]*\.exe]
    cmd = %Q[tasklist 2>NUL | findstr /I /R #{process_name_regex}]
    #puts cmd    
    result = %x[#{cmd}]
    #puts ">>>#{result}<<<"

    # Return string because old facter versions, like the 2.x used by Windows XP, don't know boolean
    result.empty? ? 'false' : 'true'

  end
end