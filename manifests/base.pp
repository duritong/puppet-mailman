# setup mailman
class mailman::base {

  package{'mailman':
    ensure => installed,
  } -> file{'/usr/lib/mailman/Mailman/mm_cfg.py':
    content => template('mailman/config/mm_cfg.py.erb'),
    owner   => 'root',
    group   => 'mailman',
    mode    => '0644';
  } ~> service{'mailman':
    ensure => running,
    enable => true,
  }

  # setup the general list
  mailman::list{$mailman::site_list:
    ensure   => 'present',
    admin    => $mailman::admin,
    password => $mailman::password,
    require  => File['/usr/lib/mailman/Mailman/mm_cfg.py'],
    notify   => Service['mailman'],
  }

  exec{'set_mailman_adminpw':
    command => "/usr/lib/mailman/bin/mmsitepass '${mailman::password}'",
    creates => '/etc/mailman/adm.pw',
    require => File['/usr/lib/mailman/Mailman/mm_cfg.py'],
  }

  file{'/usr/local/sbin/mailman_admin_member_chunksize':
    source  => 'puppet:///modules/mailman/scripts/mailman_admin_member_chunksize.sh',
    require => Package['mailman'],
    owner   => 'root',
    group   => 0,
    mode    => '0700';
  }

  if str2bool($selinux) {
    # workaround a bug
    file{'/usr/lib/mailman/mail/mailman':
      seltype => 'mailman_mail_exec_t',
      require => Package['mailman'],
    }
  }
}
