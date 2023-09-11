#!/bin/bash

for pkg in $(ls */PKGBUILD | sed s'|/PKGBUILD||g') ; do
   if [ -e ${pkg}/.git ]; then
      cd ${pkg}
      echo "Update ${pkg}"
#      git stash
      git pull
      cd ..
   fi
done
