#! /bin/bash

set -x

[ -r "$HOME/.makepkg.conf" ] && . "$HOME/.makepkg.conf"

cd "$(dirname "$0")" &&
. ./PKGBUILD &&
pkgver="$(git log -1 --format="%cd.g%h" --date=short | sed 's/-/./g')" &&
src="src/$pkgname-$pkgver" &&
rm -rf src pkg &&
mkdir -p "$src" &&
sed "s/^pkgver=.*\$/pkgver=$pkgver/" PKGBUILD >PKGBUILD.tmp &&
(cd "$OLDPWD" && git ls-files -z | xargs -0 cp -a --no-dereference --parents --target-directory="$OLDPWD/$src") &&
echo -n "`git describe`" > "$src/.version_stamp" &&
export PACKAGER="${PACKAGER:-`git config user.name` <`git config user.email`>}" &&
makepkg --noextract --force -p PKGBUILD.tmp &&
rm -rf src pkg PKGBUILD.tmp &&
sudo pacman -U --noconfirm "$pkgname-$pkgver-$pkgrel-`uname -m`${PKGEXT:-.pkg.tar.xz}"

