# Class: maldetect
# ===========================
#
# Full description of class maldetect here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'maldetect':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class maldetect (
  $install              = true,
  $proxy                = undef,
  $proxy_port           = '8080',
  $alert_email          = undef,
  $alert_email_address  = 'root@localhost',
  $scan_dir             = '/home',
  $cron                 = undef,
){

  if $alert_email {
    $send_mail = 1
  } else {
    $send_mail = 0
  }

  # Setup cron
  if $cron {
    $cron_status = file
  } else {
    $cron_status = absent
  }

  if $install {
    include maldetect::install
    Class[maldetect::install] -> Class[maldetect]
  }

  # Manage configuration
  file { 'configure_maldet':
    path    => '/usr/local/maldetect/conf.maldet',
    mode    => '0600',
    owner   => 'root',
    group   => 'root',
    content => template('maldetect/conf.maldet.erb'),
  }

  # Manage cron
  file {'maldetect-cron':
    ensure  => $cron_status,
    path    => '/etc/cron.daily/maldet',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('maldetect/maldet.erb'),
  }

}
