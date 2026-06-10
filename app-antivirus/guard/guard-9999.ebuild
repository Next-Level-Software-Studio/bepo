# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HOMEPAGE="https://github.com/Next-Level-Software-Studio/Guard-for-Bit-OS"
SRC_URI="https://github.com/Next-Level-Software-Studio/Guard-for-Bit-OS/archive/refs/tags/v\${PV}.tar.gz -> \${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc ufw"

RDEPEND="dev-lang/python
	dev-python/python-magic
	ufw? ( net-firewall/ufw )"
DEPEND="${RDEPEND}"