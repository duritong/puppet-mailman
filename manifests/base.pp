# setup mailman
class mailman::base {

  package{'mailman':
    ensure => installed,
  } -> file{'/usr/local/mailman/Mailman/mm_cfg.py':
    content => template('mailman/config/mm_cfg.py.erb'),
    owner   => root,
    group   => mailman,
    mode    => '0644';
  } ~> service{'mailman':
    ensure => running,
    enable => true,
  }

  # setup the general list
  mailman::list {'mailman':
    ensure   => 'present',
    admin    => $mailman::admin,
    password => $mailman::password,
    require  => Package['mailman'],
    notify   => Service['mailman'],
  }

  exec{'set_mailman_adminpw':
    command => "/usr/local/mailman/bin/mmsitepass ${mailman::password}",
    creates => '/usr/local/mailman/data/adm.pw',
    require => Package['mailman'],
  }

  file{'/usr/local/sbin/mailman_admin_member_chunksize':
    source  => 'puppet:///modules/mailman/scripts/mailman_admin_member_chunksize.sh',
    require => Package['mailman'],
    owner   => 'root',
    group   => 0,
    mode    => '0700';
  }
}
