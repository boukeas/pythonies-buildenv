FROM debian:jessie
MAINTAINER George Boukeas <boukeas@gmail.com>

# install required packages
RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
        wget \
        unzip \
        fontconfig \
        perl \
        python-pygments && \
        apt-get autoclean && apt-get --purge --yes autoremove && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# download and install fonts
WORKDIR /tmp/
RUN wget http://font.ubuntu.com/download/ubuntu-font-family-0.83.zip && \
    unzip ubuntu-font-family-0.83.zip && \
    mv ubuntu-font-family-0.83/*.ttf /usr/share/fonts/truetype/ && \
    wget http://downloads.sourceforge.net/project/linuxlibertine/linuxlibertine/5.3.0/LinLibertineOTF_5.3.0_2012_07_02.tgz && \
    tar -xvf LinLibertineOTF_5.3.0_2012_07_02.tgz && \
    mkdir /usr/share/fonts/opentype/ && \
    wget http://pythonies.mysch.gr/LinLibertineOC_5.0.0.otf && \
    mv *.otf /usr/share/fonts/opentype/ && \
    fc-cache -f && \
    rm -rf /tmp/*

# install a minimal texlive 2014 and required packages
WORKDIR /tmp/
RUN wget ftp://ftp.tug.org/historic/systems/texlive/2014/tlnet-final/install-tl-unx.tar.gz && \
    mkdir install-tl-unx/ && \
    tar -xvf install-tl-unx.tar.gz -C install-tl-unx/ --strip-components=1 && \
    cd install-tl-unx/ && \
    touch profile && \
    ./install-tl -repository ftp://tug.org/historic/systems/texlive/2014/tlnet-final -profile profile -scheme minimal && \
    /usr/local/texlive/2014/bin/x86_64-linux/tlmgr install \
        amsmath \
        babel \
        babel-greek \
        booktabs \
        caption \
        changepage \
        datetime \
        euenc \
        fancyvrb \
        float \
        fmtcount \
        fontspec \
        framed \
        geometry \
        graphics \
        hyperref \ 
        hyphen-greek \
        ifplatform \
        latex \
        lineno \
        minted \
        ntheorem \
        oberdiek \
        polyglossia \
        titlesec \
        tools \
        url \
        xstring \
        xcolor \
        xunicode \
        xetex \
        xetex-def \
        zapfding && \
    rm -rf /tmp/*

# add to path (for running xelatex)
ENV PATH /usr/local/texlive/2014/bin/x86_64-linux/:$PATH

# mounting and working on the main pythonies dir
VOLUME /pythonies/
WORKDIR /pythonies/
