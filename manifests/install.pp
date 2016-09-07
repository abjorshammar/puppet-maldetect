class maldetect::install inherits maldetect {

  # Setup variables
  $url = 'http://www.rfxn.com/downloads/maldetect-current.tar.gz'

  if $maldetect::proxy {
    $command = "/usr/bin/wget -e http_proxy=${maldetect::proxy}:${maldetect::proxy_port} http://www.rfxn.com/downloads/maldetect-current.tar.gz"
  } else {
    $command = '/usr/bin/wget http://www.rfxn.com/downloads/maldetect-current.tar.gz'
  }

  # Install
  exec { 'install_maldet':
    cwd     => '/tmp',
    command => "${command} && tar -xzf maldetect-current.tar.gz && cd maldetect* && /bin/bash install.sh",
    creates => '/usr/local/maldetect',
    before  => File['configure_maldet'],
  }

  # Configure
  file { 'configure_maldet':
    path    => '/usr/local/maldetect/conf.maldet',
    content => template('maldetect/conf.maldet.erb'),
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    before  => Exec['install_maldet_cleanup'],
  }

  # Cleanup
  exec { 'install_maldet_cleanup':
    path    => '/bin:/sbin:/usr/bin:/usr/sbin',
    command => 'rm -rf /tmp/maldetect*',
    onlyif  => 'test -d /tmp/maldetect*',
  }

}
