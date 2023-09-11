#printf "basekernel old (example: 6.3): "
#read oldver
#oldname=${oldver/./}
#printf "basekernel new (example: 6.4): "
#read newver
#newname=${newver/./}

#sed -i -e "s/linux$oldname/linux$newname/g" */PKGBUILD
#sed -i -e "s/$oldver/$newver/g" */PKGBUILD
#sed -i -e '/pkgrel=/c\pkgrel=1' */PKGBUILD
#sed -i -e "s/$oldver/$newver/g" */*.install

printf "gitlab-user: "
read user
printf "password: "
read -s passwd
printf "\n"
modules=$(pwd | rev | cut -d / -f1 | rev)
_git=https://$user:"$passwd"@gitlab.manjaro.org/packages/extra/$modules

for m in $(cat modules.list); do
  cd $m
  rm -rf .git | true
  git init
  git add .
  git commit -m"initial commit"
  git remote add origin $_git/$m.git
  git push --set-upstream origin master
  cd ..
done
