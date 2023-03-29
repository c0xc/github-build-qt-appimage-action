FROM debian/eol:jessie

RUN \
    printf "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main contrib non-free" >/etc/apt/sources.list.d/backports.list && \
    printf "deb http://deb.debian.org/debian/ stretch main contrib non-free" >/etc/apt/sources.list.d/stretch.list && \
    echo "" >/etc/apt/preferences.d/backports && \
    printf "Package: *\nPin: release a=jessie-backports\nPin-Priority: 650\n\n" >>/etc/apt/preferences.d/backports && \
    printf "Package: *\nPin: release a=stretch\nPin-Priority: 100\n\n" >>/etc/apt/preferences.d/backports && \
    printf "Package: *\nPin: origin deb.debian.org\nPin-Priority: 100\n\n" >>/etc/apt/preferences.d/backports

RUN \
    sed -i 's/main$/main contrib non-free/g' /etc/apt/sources.list && \
    sed -i '/^deb.*jessie.updates/d' /etc/apt/sources.list && \
    sed -i 's!^# \(deb http://snapshot\)!\1!' /etc/apt/sources.list

RUN \
    apt-get update && \
    apt-get install -y \
    flex bison gperf libicu-dev libxslt-dev ruby \
    libxcursor-dev libxcomposite-dev libxdamage-dev libxrandr-dev libxtst-dev libxss-dev libdbus-1-dev libevent-dev libfontconfig1-dev libcap-dev libpulse-dev libudev-dev libpci-dev libnss3-dev libasound2-dev libegl1-mesa-dev gperf bison nodejs \
    wget libclang-dev vim
# llvm-dev

RUN \
    apt-get install -y default-libmysqlclient-dev \
    libssl-dev libjasper-dev unixodbc-dev libmng-dev libpqxx-dev

# OpenGL (optional)
# ERROR: The OpenGL functionality tests failed!
RUN \
    apt install -y -t stretch libgl1-mesa-dev libglu1-mesa-dev \
    '^libxcb.*-dev' libx11-xcb-dev libglu1-mesa-dev libxrender-dev libxi-dev libxkbcommon-dev libxkbcommon-x11-dev \
    libasound2-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev
# E: Unable to locate package libgstreamer-plugins-good1.0-dev

# gcc in jessie-backports is too old (version 4)
RUN \
    apt-get update && \
    apt-get install -y -t stretch build-essential perl python3 git g++

# Run build scripts
COPY build*.sh qt-everywhere-src-*.tar.* *.AppImage /var/tmp/
ENTRYPOINT ["/var/tmp/build_src.sh"]
