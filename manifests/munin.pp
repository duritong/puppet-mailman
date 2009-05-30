class mailman::munin {
  munin::plugin{'mailman':
    config => 'group mailman';
  }
}
