define mailman::list(
  $ensure = present,
  $password = 'absent',
  $admin = 'absent',
  $description = 'absent',
  $mailserver = 'absent',
  $webserver = 'absent'
){
  maillist{$name:
    ensure => $ensure,
    password => $password ? {
      'absent' => $mailman::password,
      default => $password
    },
    admin => $admin ? {
      'absent' => $mailman::admin,
      default => $admin
    },
    mailserver => $mailserver ? {
      'absent' => $mailman::mailserver,
      default => $mailserver
    },
    webserver => $webserver ? {
      'absent' => $mailman::webserver,
      default => $webserver
    },
    require => Package['mailman'],
  }


  if $description != 'absent' {
    Maillist[$name]{
      description => $description,
    }
  }
}
