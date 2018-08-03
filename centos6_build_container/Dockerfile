FROM centos:centos6

ENV LANG=C LC_ALL=C
ENV PATH /opt/conda/bin:$PATH

RUN \
    yum -y update && yum install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion patch && \
    yum -y groupinstall 'Development Tools'

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda2-4.5.4-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN \
    yum install -y curl grep sed && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.rpm" > tini.rpm && \
    yum install -y tini.rpm && \
    rm tini.rpm && \
    yum -y clean all && \
    rm -rf /var/cache/yum/* /tmp/* /var/tmp/*

RUN \
    . /etc/profile.d/conda.sh \
    conda activate \
    conda install -y conda-build

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD [ "/bin/bash" ]
