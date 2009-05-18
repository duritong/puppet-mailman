define mailman::list(
  $ensure = present,
  $password = 'absent',
  $admin = 'absent',
  $description = 'absent',
  $mailserver = 'absent',
  $webserver = 'absent'
){
  include mailman

  if $admin == 'absent' {
    if $mailman_admin {
      $real_admin = $mailman_admin
    } else {
      fail("you either have to specify an admin for ${name} or set \$mailman_admin globally")
    }
  } else { $real_admin = $admin }

  if $mailserver == 'absent' {
    if $mailman_mailserver {
      $real_mailserver = $mailman_mailserver
    } else {
      fail("you either have to specify a mailserver for ${name} or set \$mailman_mailserver globally")
    }
  } else { $real_mailserver = $mailserver }

  if $webserver == 'absent' {
    if $mailman_webserver {
      $real_webserver = $mailman_webserver
    } else {
      fail("you either have to specify a webserver for ${name} or set \$mailman_webserver globally")
    }
  } else { $real_webserver = $werbserver }

  if $password == 'absent' {
    if $mailman_password {
      $real_password = $mailman_password
    } else {
      fail("you either have to specify a password for ${name} or set \$mailman_password globally")
    }
  } else { $real_password = $password }

  maillist{$name:
    ensure => $ensure,
    password => $real_password,
    admin => $real_admin,
    mailserver => $real_mailserver,
    webserver => $real_webserver,
    require => Package['mailman'],
  }


  if $description != 'absent' {
    Maillist[$name]{
      description => $description,
    }
  }
}
