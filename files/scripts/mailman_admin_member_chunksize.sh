#!/bin/bash

if [ -z $1 ] || [ -z $2 ]; then
  echo "USAGE: ${0} chunksize listname"
  exit 1
fi

echo "
m.admin_member_chunksize = ${1}
m.Save()
" | /usr/lib/mailman/bin/withlist -l $2

