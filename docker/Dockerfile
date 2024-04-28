# Run with a volume mounted as /Blin/output, e.g:
# docker run -ti -v /var/tmp/blin:/Blin/output ...
#
# The image takes the same parameters as blin.p6, e.g.:
# docker run -ti -v /var/tmp/blin:/Blin/output nxadm:blin SomeModuleHere AnotherModuleHere
FROM debian:bookworm-slim
LABEL maintainer="Claudio Ramirez <pub.claudio@gmail.com>"

ENV LANG='C.UTF-8'
ENV DEBIAN_FRONTEND='noninteractive'
ENV TZ='Europe/Brussels'
ENV pkgs_first="gpg ca-certificates debian-keyring debian-archive-keyring apt-transport-https curl vim"
ENV PATH="/opt/rakudo-pkg/var/zef/bin:/opt/rakudo-pkg/install/bin:/opt/rakudo-pkg/share/perl6/bin:/mnt/bin:${PATH}"
ENV RAKULIB="inst#/opt/rakudo-pkg/install/lib"

RUN apt-get update && apt-get install -y $pkgs_first && \
    curl -1sLf 'https://dl.cloudsmith.io/public/nxadm-pkgs/rakudo-pkg/gpg.0DD4CA7EB1C6CC6B.key' |  gpg --dearmor > /usr/share/keyrings/nxadm-pkgs-rakudo-pkg-archive-keyring.gpg && \
    curl -1sLf 'https://dl.cloudsmith.io/public/nxadm-pkgs/rakudo-pkg/config.deb.txt?distro=debian&codename=bookworm' > /etc/apt/sources.list.d/nxadm-pkgs-rakudo-pkg.list && \
    apt-get update

COPY . /Blin/
RUN ls /Blin
RUN mkdir -p /usr/share/man/man1 && apt-get update && set -xv ;\
apt-get install -y $(cat /Blin/docker/pkg-dependencies)
RUN echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config
#RUN cd /opt && git clone https://github.com/rakudo/rakudo.git rakudo-pkg && cd /opt/rakudo-pkg && perl ./Configure.pl --gen-moar --gen-nqp --backends=moar && make && mkdir bin && ln -s rakudo-m ./bin/raku
RUN cd /opt && git clone https://github.com/rakudo/rakudo.git rakudo-pkg && cd /opt/rakudo-pkg && perl ./Configure.pl --gen-moar --gen-nqp --backends=moar && make && make install
RUN cd /tmp && git clone https://github.com/ugexe/zef.git && cd zef && raku -I. bin/zef install . -to=inst#/opt/rakudo-pkg/var/zef

RUN ls -l /opt/rakudo-pkg/var/zef/bin

# for zef look
RUN echo export SHELL=/bin/bash >> /etc/bash.bashrc
RUN export SHELL=/bin/bash
# To ignore ake weirdness
RUN export RAKUDO_NO_DEPRECATIONS=1

RUN echo "alias zzef='raku -Iinst#/opt/rakudo-pkg/var/zef /opt/rakudo-pkg/var/zef/bin/zef'" >> /root/.bashrc
RUN alias zzef='raku -Iinst#/opt/rakudo-pkg/var/zef /opt/rakudo-pkg/var/zef/bin/zef'

# force-install because ake causes deprecation errors that RAKUDO_NO_DEPRECATIONS=1 doesn't seem to help
RUN cd /Blin && zzef install --verbose --deps-only --force-install .

ENTRYPOINT [ "/Blin/docker/entrypoint.sh" ]
