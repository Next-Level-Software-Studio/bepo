# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bit-OS Package Manager - O gestor de pacotes oficial do Bit-OS"
HOMEPAGE="https://github.com/Next-Level-Software-Studio/Bit-OS-Package-Manager"

# Como estás a desenvolver localmente no teu próprio repositório Git, 
# podes deixar o SRC_URI vazio se fores instalar direto da pasta de trabalho
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pip"

# Dependências de Execução
RDEPEND="
	dev-lang/python
	pip? (
		dev-lang/python[-ensurepip]
		dev-python/pip
	)
"

# Dependências de Compilação
DEPEND="
	${RDEPEND}
"

# O teu projeto é interpretado (Python) e não precisa de compilação.
# Podemos saltar estas fases para acelerar o processo.
src_configure() { :; }
src_compile() { :; }

src_install() {
	# Garante que estamos dentro da pasta correta do código-fonte
	cd "${S}" || die

	# 1. Instalar os ficheiros de configuração e bibliotecas (Não-executáveis)
	# Copia 'etc', 'lib' e 'var' mantendo a estrutura para a raiz temporária
	insinto /
	if [[ -d "files/overlay/etc" ]]; then doins -r "files/overlay/etc"; fi
	if [[ -d "files/overlay/lib" ]]; then doins -r "files/overlay/lib"; fi
	if [[ -d "files/overlay/var" ]]; then doins -r "files/overlay/var"; fi

	# 2. Instalar os binários/scripts do sistema (Executáveis)
	# Isto garante que o 'bpm' vai para /sbin com permissão de execução (0755)
	if [[ -d "files/overlay/sbin" ]]; then
		exeinto /sbin
		doexe files/overlay/sbin/*
	fi

	# 3. Instalar a documentação padrão (Opcional, mas boa prática)
	dodoc README.md LICENSE
}