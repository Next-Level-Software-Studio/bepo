# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

HOMEPAGE="https://github.com/Next-Level-Software-Studio/Guard-for-Bit-OS"
SRC_URI="https://github.com/Next-Level-Software-Studio/Guard-for-Bit-OS/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="audit bzip2 clamav doc nftables openrc pam rar selinux split-usr sudo systemd xml chkrootkit rkhunter tor pip portage"

# Garante que exatamente um dos dois deve estar ativo
REQUIRED_USE="^^ ( openrc systemd )"

RDEPEND="dev-lang/python
	dev-python/python-magic
	!net-firewall/ufw
	sys-libs/pam[-berkdb,audit?,selinux?,openrc?,systemd?]
	audit? (
		pam? ( sys-process/audit[split-usr?] )
		sudo? ( sys-process/audit[split-usr?] )
		selinux? ( sys-process/audit[split-usr?] )
		sys-process/audit[python]
	)
	clamav? (
		app-antivirus/clamav[clamapp,clamsubmit,iconv,metadata-analysis-api,system-mspack,bzip2?,rar?,xml?]
	)
	nftables? ( net-firewall/nftables[python] )
	selinux? (
		sys-libs/libselinux[python]
		sys-apps/policycoreutils[pam,audit?,split-usr?]
		clamav? ( sec-policy/selinux-clamav )
		chkrootkit? (
			sec-policy/selinux-chkrootkit
			app-forensics/chkrootkit[selinux]
		)
		rkhunter? (
			sec-policy/selinux-rkhunter
			app-forensics/rkhunter[selinux]
		)
	)
	chkrootkit? ( app-forensics/chkrootkit[cron] )"
DEPEND="${RDEPEND}"

src_prepare() {
	default # Aplica patches padrão do Gentoo ou correções do usuário se houverem

	# Remove explicitamente os arquivos solicitados para não irem para a instalação
	rm -f .gitattributes || die
	rm -f .gitignore || die
	rm -f *.ebuild || die
	rm -f metadata.xml || die

	if ! use portage; then
		rm -f "${S}/overlay/usr/share/guard/extensions/scan_packages/portage.py" || die
	fi

	if ! use pip; then
		rm -f "${S}/overlay/usr/share/guard/extensions/scan_packages/pip.py" || die
	fi

	if ! use audit; then
		rm -f "${S}/overlay/usr/share/guard/extensions/scan_logs/audit.py" || die
	fi
}