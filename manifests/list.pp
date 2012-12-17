# manage a mailman list
define mailman::list(
  $ensure       = present,
  $password     = 'absent',
  $admin        = 'absent',
  $description  = 'absent',
  $mailserver   = 'absent',
  $webserver    = 'absent',
  $amcsize      = undef
){
  $list_password = $password ? {
    'absent'  => $mailman::password,
    default   => $password
  }
  $list_admin = $admin ? {
    'absent'  => $mailman::admin,
    default   => $admin
  }
  $list_mailserver = $mailserver ? {
    'absent'  => $mailman::mailserver,
    default   => $webserver
  }
  $list_webserver = $webserver ? {
    'absent'  => $mailman::webserver,
    default   => $webserver
  }
  maillist{$name:
    ensure      => $ensure,
    password    => $list_password,
    admin       => $list_admin,
    mailserver  => $list_mailserver,
    webserver   => $list_webserver,
    require     => Package['mailman'],
  }

  if $description != 'absent' {
    Maillist[$name]{
      description => $description,
    }
  }

  if $amcsize {
    exec{"adjust_admin_chunk_member_size_${name}":
      command => "mailman_admin_member_chunksize ${amcsize} ${name}",
      unless  => "echo 'm.admin_member_chunksize' | /usr/lib/mailman/bin/withlist -l ${name} 2>/dev/null | grep -qE '^>>> ${amcsize}$'",
      require => [ Maillist[$name], File['/usr/local/sbin/mailman_admin_member_chunksize'] ],
    }
  }
}
