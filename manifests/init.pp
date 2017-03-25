#
# mailman module
#
# Copyright 2009, admin(at)immerda.ch
#
# This program is free software; you can redistribute
# it and/or modify it under the terms of the GNU
# General Public License version 3 as published by
# the Free Software Foundation.
#

class mailman(
  $password,
  $admin              = "root@${domain}",
  $default_email_host = "lists.${domain}",
  $default_url_host   = "lists.${domain}",
  $manage_munin       = false,
  $config             = {},
) {
  include ::apache
  case $::osfamily {
    'RedHat': { include ::mailman::centos }
    default: { include ::mailman::base }
  }
  if $manage_munin {
    include ::mailman::munin
  }
}
