# manage munin plugin
class mailman::munin {
  file{'/var/lib/munin-node/plugin-state/munin-mailman-log.state':
    ensure  => file,
    replace => false,
    require => Package['mailman'],
    owner   => nobody,
    group   => mailman,
    mode    => '0640';
  } -> munin::plugin{'mailman':
    config => "timeout 40
group mailman",
  }
}
