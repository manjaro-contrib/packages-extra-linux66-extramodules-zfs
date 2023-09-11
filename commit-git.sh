#!/bin/bash

for pkg in $(ls */PKGBUILD | sed s'|/PKGBUILD||g') ; do
   if [ -e ${pkg}/.git ]; then
      cd ${pkg}
      pkgver=$(grep pkgver= PKGBUILD -m1 | cut -d= -f2)
      pkgrel=$(grep pkgrel= PKGBUILD -m1 | cut -d= -f2)
      echo "Update ${pkg}"
      ! $(. ./PKGBUILD >/dev/null 2>&1) && sanity=fail
      if [[ $sanity == "fail" ]]; then
          printf "ERROR: Sanity-check for ${pkg}/PKGBUILD failed.\n"
          exit 1
      fi
#      git commit -am "$pkgver-$pkgrel"
      git commit -am "corrections"
      git push
      cd ..
   fi
done
