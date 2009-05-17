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
                "puppet://$server/mailman/config/${operatingsystem}/mm_cfg.py",
                "puppet://$server/mailman/config/mm_cfg.py" ],
    require => Package['mailman'],
    notify => Service['mailman'],
    owner => root, group => mailman, mode => 0644;
  }
}
