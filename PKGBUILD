# Maintainer: Bernhard Landauer <bernhard@manjaro.org>
# Maintainer: Philip Müller <philm[at]manjaro[dot]org>

_linuxprefix=linux66
_extramodules=extramodules-6.6-MANJARO

pkgname="$_linuxprefix-zfs"
pkgver=2.2.2
pkgrel=18
pkgdesc='Kernel modules for the Zettabyte File System.'
arch=('x86_64')
url="http://zfsonlinux.org/"
license=('CDDL')
groups=("$_linuxprefix-extramodules")
depends=("$_linuxprefix" "zfs-utils=${pkgver}")
makedepends=("$_linuxprefix-headers" "zfs-dkms=${pkgver}")
provides=("zfs=${pkgver}" "ZFS-MODULE=${pkgver}")
options=('!strip')

build() {
    _kernver="$(cat /usr/lib/modules/$_extramodules/version)"
    fakeroot dkms build --dkmstree "${srcdir}" -m zfs/${pkgver} -k ${_kernver}
}

package() {
    _kernver="$(cat /usr/lib/modules/$_extramodules/version)"
    install -Dt "${pkgdir}/usr/lib/modules/${_extramodules}" -m644 zfs/${pkgver}/${_kernver}/${CARCH}/module/*

    # compress each module individually
    find "$pkgdir" -name '*.ko' -exec xz -T1 {} +

    # systemd module loading
    printf '%s\n' spl zfs |
    install -Dm 644 /dev/stdin "${pkgdir}/usr/lib/modules-load.d/${pkgname}.conf"
}
