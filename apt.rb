dep 'apt packages removed', :match, :for => :apt do
  def packages
    shell("dpkg --get-selections").split("\n").select {|l|
      l[/\binstall$/]
    }.map {|l|
      l.split(/\s+/, 2).first
    }
  end
  def to_remove match
    packages.select {|pkg| pkg[match.current_value] }
  end
  met? {
    to_remove(match).empty?
  }
  meet {
    to_remove(match).each {|pkg|
      log_shell "Removing #{pkg}", "apt-get -y remove --purge '#{pkg}'", :sudo => true
    }
  }
  after {
    log_shell "Autoremoving packages", "apt-get -y autoremove", :sudo => true
  }
end

# These are for use in dollhouse, since at the moment only strings can be passed.

dep 'lamp stack removed' do
  requires 'apt packages removed'.with(/apache|mysql|php/)
end

dep 'postfix removed' do
  requires 'apt packages removed'.with(/postfix/)
end
