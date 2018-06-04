FROM rocker/rstudio

MAINTAINER Federico Agostini <agostini.federico@gmail.com>

LABEL \
    description="Image for tools used in RNA-seq course"

RUN apt-get update -y && DEBIAN_FRONTEND=noninteractive  apt-get install -y \
    build-essential \
    bzip2 \
    ca-certificates \
    cmake \
    curl \
    default-jdk \
    fonts-texgyre \
    git \
    libbz2-dev \
    libcurl3 \
    libcurl4-openssl-dev \
    liblzma-dev \
    libnss-sss \
    libssl-dev \
    libtbb2 \
    libtbb-dev \
    ncurses-dev \
    nodejs \
    python-dev \
    python-pip \
    python-numpy \
    python-matplotlib \
    python-pysam \
    python-htseq \
    python-setuptools \
    sudo \
    tzdata \
    unzip \
    wget \
    zlib1g \
    zlib1g-dev

### HTSlib v1.8 ###
ENV HTSLIB_INSTALL_DIR=/opt/htslib

WORKDIR /tmp
RUN wget -nv https://github.com/samtools/htslib/releases/download/1.8/htslib-1.8.tar.bz2 && \
    tar -j -xvf htslib-1.8.tar.bz2 && \
    cd /tmp/htslib-1.8 && \
    ./configure  --enable-plugins --prefix=$HTSLIB_INSTALL_DIR && \
    make && \
    make install && \
    cp $HTSLIB_INSTALL_DIR/lib/libhts.so* /usr/lib/

### Samtools v1.8 ###
ENV SAMTOOLS_INSTALL_DIR=/opt/samtools

WORKDIR /tmp
RUN wget -nv https://github.com/samtools/samtools/releases/download/1.8/samtools-1.8.tar.bz2 && \
    tar -j -xf samtools-1.8.tar.bz2 && \
    cd /tmp/samtools-1.8 && \
    ./configure --with-htslib=$HTSLIB_INSTALL_DIR --prefix=$SAMTOOLS_INSTALL_DIR && \
    make && \
    make install && \
    cd / && \
    ln -s /opt/samtools/bin/samtools /usr/bin/samtools && \
    rm -rf /tmp/samtools-1.8

### Sambamba v0.6.7 ###
RUN mkdir /opt/sambamba/ \
    && wget -nv https://github.com/biod/sambamba/releases/download/v0.6.7/sambamba_v0.6.7_linux.tar.bz2 \
    && tar --extract -j --directory=/opt/sambamba --file=sambamba_v0.6.7_linux.tar.bz2 \
    && ln -s /opt/sambamba/sambamba /usr/bin/sambamba

### FastQC v0.11.7 ###
RUN mkdir /opt/fastqc/ \
    && wget -nv http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.7.zip \
    && unzip fastqc_v0.11.7.zip -d /opt/fastqc \
    && chmod 755 /opt/fastqc/FastQC/fastqc \
    && ln -s /opt/fastqc/FastQC/fastqc /usr/bin/fastqc \
    && rm fastqc_v0.11.7.zip

### Cutadapt v1.16 ###
RUN pip install --upgrade pip && \
    python -m pip install cutadapt==1.16

### TrimGalore v0.4.5 ###
RUN mkdir /opt/trimgalore/ \
    && curl -fsSL https://github.com/FelixKrueger/TrimGalore/archive/0.4.5.tar.gz -o trim_galore.tar.gz \
    && tar --extract -z --directory=/opt/trimgalore --file=trim_galore.tar.gz \
    && mv /opt/trimgalore/TrimGalore-0.4.5/trim_galore /usr/bin/trim_galore \
    && rm trim_galore.tar.gz

### Kallisto v0.44.0 ###
RUN mkdir /opt/kallisto && cd /opt/kallisto && \
    wget -nv https://github.com/pachterlab/kallisto/releases/download/v0.44.0/kallisto_linux-v0.44.0.tar.gz && \
    tar -xzvf kallisto_linux-v0.44.0.tar.gz && \
    ln -s /opt/kallisto/kallisto_linux-v0.44.0/kallisto /usr/bin/kallisto

### Picard v2.18.5 ###
RUN mkdir /opt/picard/ \
    && wget -nv https://github.com/broadinstitute/picard/releases/download/2.18.5/picard.jar \
    && mv picard.jar /opt/picard/

# Define a timezone so Java works properly
RUN ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime \
    && echo "Europe/London" > /etc/timezone \
    && dpkg-reconfigure --frontend noninteractive tzdata

ARG R_VERSION
ARG BUILD_DATE
ENV BUILD_DATE 2017-06-20
ENV R_VERSION=${R_VERSION:-3.4.0}
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends locales && \
    echo "en_GB.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_GB.UTF-8 && \
    LC_ALL=en_GB.UTF-8 && \
    LANG=en_GB.UTF-8 && \
    /usr/sbin/update-locale LANG=en_GB.UTF-8 && \
    TERM=xterm && \
    DEBIAN_FRONTEND=noninteractive  apt-get install -y --no-install-recommends \
    libssh2-1-dev \
    libxml2-dev \
    bash-completion \
    ca-certificates \
    curl \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libapparmor1 \
    libbz2-1.0 \
    libedit2 \
    # libicu55 \
    # libjpeg-turbo8 \
    libopenblas-dev \
    libpangocairo-1.0-0 \
    libpcre3 \
    # libpng12-0 \
    libtiff5 \
    liblzma5 \
    locales \
    lsb-release \
    psmisc \
    zlib1g \
    libbz2-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    # libicu-dev \
    libpcre3-dev \
    # libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    tcl8.5-dev \
    tk8.5-dev \
    texinfo \
    texlive-extra-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-recommended \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    zlib1g-dev

   ## install r packages, bioconductor, etc
   ADD rpackages.R /tmp/
   RUN R -f /tmp/rpackages.R

   ## Clean up
   RUN cd / && \
   rm -rf /tmp/* && \
   apt-get autoremove -y && \
   apt-get autoclean -y && \
   rm -rf /var/lib/apt/lists/* && \
   apt-get clean

EXPOSE 8787

# ## automatically link a shared volume for kitematic users
# VOLUME /home/rstudio/kitematic

CMD ["/init"]