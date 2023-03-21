FROM fedora:33

RUN \
    dnf install -y \
    which \
    qt5-qtbase-devel qt5-qttools

RUN ln -s /usr/bin/qmake-qt5 /usr/bin/qmake

# Run build scripts
COPY build*.sh *.AppImage /var/tmp/
ENTRYPOINT ["/var/tmp/build_src.sh"]
