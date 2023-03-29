FROM fedora:33

RUN \
    dnf install -y \
    which findutils file wget \
    qt5-qtbase-devel qt5-qttools qt5-linguist

RUN ln -s /usr/bin/qmake-qt5 /usr/bin/qmake

ENV NO_QT_BUILD x

# Run build scripts
COPY build*.sh *.AppImage /var/tmp/
ENTRYPOINT ["/var/tmp/build_src.sh"]
