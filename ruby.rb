dep 'ruby trunk.src' do
  requires 'build tools', 'bison.managed', 'readline headers.managed'
  source 'git://github.com/ruby/ruby.git'
  provides 'ruby == 1.9.3.dev', 'gem', 'irb'
  configure_args '--disable-install-doc', '--with-readline-dir=/usr'
end

dep 'ruby.src', :version, :patchlevel do
  def version_group
    version.to_s.scan(/^\d\.\d/).first
  end
  version.default!('1.9.3')
  patchlevel.default!('p194')
  requires [
    'curl.lib',
    'libssl headers.managed',
    'readline headers.managed',
    'yaml headers.managed',
    'zlib headers.managed'
  ]
  source "ftp://ftp.ruby-lang.org/pub/ruby/#{version_group}/ruby-#{version}-#{patchlevel}.tar.gz"
  provides "ruby == #{version}#{patchlevel}", 'gem', 'irb'
  configure_args '--disable-install-doc',
    "--with-readline-dir=#{Babushka.host.pkg_helper.prefix}",
    "--with-libyaml-dir=#{Babushka.host.pkg_helper.prefix}"
  postinstall {
    # The ruby <1.9.3 installer skips bin/* when the build path contains a dot-dir.
    shell "cp bin/* #{prefix / 'bin'}", :sudo => Babushka::SrcHelper.should_sudo?
  }
end
