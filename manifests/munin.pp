class mailman::munin {
  file{'/var/lib/munin/plugin-state/munin-mailman-log.state':
    ensure => file,
    replace => false,
    owner => nobody, group => mailman, mode => 0640;
  }
  munin::plugin{'mailman':
    config => "timeout 40
group mailman",
    require => File['/var/lib/munin/plugin-state/munin-mailman-log.state'];
  }
}
