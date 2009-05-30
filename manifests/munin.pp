class mailman::munin {
  mailman::plugin{'mailman':
    config => 'group mailman';
  }
}
