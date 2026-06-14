# Copyright 2026 Next Level Software Studio
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Define a compatibilidade com o slot do Python 3.14
PYTHON_COMPAT=( python3_14 )

inherit python-r1

DESCRIPTION="A Next Level Software Studio — Non-official API Wrapper."
HOMEPAGE="https://github.com/Next-Level-Software-Studio/api-get"

# Baixa o código fonte direto do seu repositório no GitHub
SRC_URI="https://github.com/Next-Level-Software-Studio/api-get/archive/refs/heads/main.tar.gz -> ${P}.tar.gz"

# Licença alterada para MIT
LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"

# Definição das USE flags personalizadas do projeto
IUSE="github discord gentoo-packages"

# Força o Portage a exigir exatamente a versão 3.14.6 do repositório oficial do Gentoo
RDEPEND="
	=dev-lang/python-3.14.6
	${PYTHON_DEPS}
"
DEPEND="${RDEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

# Fase de preparação: deleta os arquivos de desenvolvimento e metadados locais
src_prepare() {
	default # Aplica patches padrão do Gentoo ou correções do usuário se houverem

	# Remove explicitamente os arquivos solicitados para não irem para a instalação
	rm -f .gitattributes || die
	rm -f .gitignore || die
	rm -f *.ebuild || die
	rm -f metadata.xml || die
}

src_install() {
	install_packages() {
		local destdir="$(python_get_sitedir)"
		
		# Criamos uma cópia temporária da pasta dentro do ambiente de build de cada implementação do Python
		mkdir -p "${T}/src" || die
		cp -R "${S}/src/api-get" "${T}/src/" || die

		# Se a flag "gentoo-packages" NÃO estiver ativa, apaga o arquivo Gentoo_Packages.py
		if ! use gentoo-packages; then
			rm -f "${T}/src/api-get/Gentoo_Packages.py" || die
		fi

		# Se a flag "discord" NÃO estiver ativa, apaga o arquivo Discord.py
		if ! use discord; then
			rm -f "${T}/src/api-get/Discord.py" || die
		fi

		# Se a flag "github" NÃO estiver ativa, apaga o arquivo GitHub.py
		if ! use github; then
			rm -f "${T}/src/api-get/GitHub.py" || die
		fi

		insinto "${destdir}"
		# Instala a pasta final modificada pelas USE flags no site-packages do sistema
		doins -r "${T}/src/api-get"
	}
	
	python_foreach_impl install_packages
}