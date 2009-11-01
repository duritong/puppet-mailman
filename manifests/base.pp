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
    source => [ "puppet://$server/files/mailman/config/${fqdn}/mm_cfg.py",
                "puppet://$server/files/mailman/config/mm_cfg.py",
                "puppet://$server/modules/mailman/config/${operatingsystem}/mm_cfg.py",
                "puppet://$server/modules/mailman/config/mm_cfg.py" ],
    require => Package['mailman'],
    notify => Service['mailman'],
    owner => root, group => mailman, mode => 0644;
  }

  if $mailman_admin == '' { fail("you have to set \$mailman_admin on $fqdn") }
  if $mailman_password == '' { fail("you have to set \$mailman_password on $fqdn") }

  mailman::list {'mailman':
    ensure => 'present',
    admin => $mailman_admin,
    password => $mailman_password,
    require => Package['mailman'],
    notify => Service['mailman']
  }

  exec{'set_mailman_adminpw':
    command => "/usr/local/mailman/bin/mmsitepass ${mailman_password}",
    creates => "/usr/local/mailman/data/adm.pw",
    require => Package['mailman'],
  }
}
