class mailman::munin {
  munin::plugin{'mailman':
    config => "timeout 40
group mailman";
  }
}
