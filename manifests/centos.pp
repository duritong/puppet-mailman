class mailman::centos inherits mailman::base {
    file{'/etc/httpd/conf.d/mailman.conf':
        source => [ "puppet://$server/modules/site-mailman/httpd/${fqdn}/mailman.conf",
                    "puppet://$server/modules/site-mailman/httpd/mailman.conf",
                    "puppet://$server/modules/mailman/httpd/mailman.conf" ],
        require => Package[apache],
        notify => Service[apache],
        owner => root, group => 0, mode => 0644;
    }
    File['/usr/local/mailman/Mailman/mm_cfg.py']{
      path => '/usr/lib/mailman/Mailman/mm_cfg.py',
    }
    Exec['set_mailman_adminpw']{
      command => "/usr/lib/mailman/bin/mmsitepass ${mailman_password}",
      creates => "/etc/mailman/adm.pw",
    }
}
