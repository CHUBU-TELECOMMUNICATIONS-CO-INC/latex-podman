FROM ubuntu:20.04

ARG TEXLIVE_VERSION=2022

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NOWARNINGS=yes
ENV PATH="/usr/local/texlive/bin:$PATH"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        make \
        wget \
        python3 \
        libfontconfig1-dev \
        libfreetype6-dev \
        ghostscript \
        perl \
        git \
        poppler-utils \
        ttf-mscorefonts-installer \
        software-properties-common  && \
    add-apt-repository -y ppa:inkscape.dev/stable && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        inkscape && \
    apt-get remove -y --purge \
        software-properties-common && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        python3-pip \
        python3-dev && \
    echo 'y' | cpan YAML/Tiny.pm Log::Dispatch::File File::HomeDir Unicode::GCString && \
    pip3 install --no-cache-dir pygments && \
    mkdir /tmp/install-tl-unx && \
    wget -O - https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz \
        | tar -xzv -C /tmp/install-tl-unx --strip-components=1 && \
    /bin/echo -e 'selected_scheme scheme-basic\ntlpdbopt_install_docfiles 0\ntlpdbopt_install_srcfiles 0' \
        > /tmp/install-tl-unx/texlive.profile && \
    /tmp/install-tl-unx/install-tl \
        --profile /tmp/install-tl-unx/texlive.profile && \
    rm -r /tmp/install-tl-unx && \
    ln -sf /usr/local/texlive/${TEXLIVE_VERSION}/bin/$(uname -m)-linux /usr/local/texlive/bin && \
    apt-get remove -y --purge \
        build-essential && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN tlmgr option repository ctan && \
    tlmgr update --self && \
    tlmgr install \
        collection-bibtexextra \
        collection-fontsrecommended \
        collection-langenglish \
        collection-langjapanese \
        collection-latexextra \
        collection-latexrecommended \
        collection-luatex \
        collection-mathscience \
        collection-plaingeneric \
        collection-xetex \
        latexmk \
        latexdiff \
        siunitx \
        svg \
        latexindent && \
    mktexlsr

WORKDIR /workdir

COPY .latexmkrc /
COPY .latexmkrc /root/
