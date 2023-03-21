FROM fedora:33

RUN \
    dnf install -y \
    qt5-qtbase-devel qt5-qttools

# Run build scripts
COPY build*.sh *.AppImage /var/tmp/
ENTRYPOINT ["/var/tmp/build_src.sh"]
