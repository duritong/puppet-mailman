class mailman::base {
  package{'mailman':
    ensure => installed,
  }

  service{'mailman':
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
    require => Package['mailman'],
  }

  file{'/usr/local/mailman/Mailman/mm_cfg.py':
    source => [ "puppet:///modules/site_mailman/config/${::fqdn}/mm_cfg.py",
                "puppet:///modules/site_mailman/config/mm_cfg.py",
                "puppet:///modules/mailman/config/${::operatingsystem}/mm_cfg.py",
                "puppet:///modules/mailman/config/mm_cfg.py" ],
    require => Package['mailman'],
    notify => Service['mailman'],
    owner => root, group => mailman, mode => 0644;
  }

  mailman::list {'mailman':
    ensure => 'present',
    admin => $mailman::admin,
    password => $mailman::password,
    require => Package['mailman'],
    notify => Service['mailman']
  }

  exec{'set_mailman_adminpw':
    command => "/usr/local/mailman/bin/mmsitepass ${mailman::password}",
    creates => "/usr/local/mailman/data/adm.pw",
    require => Package['mailman'],
  }
}
