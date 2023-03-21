FROM fedora:33

RUN \
    dnf install -y \
    qt-devel
    #qt5-qtbase-devel

# Run build scripts
COPY build*.sh *.AppImage /var/tmp/
ENTRYPOINT ["/var/tmp/build_src.sh"]
