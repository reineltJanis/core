FROM phusion/passenger-customizable:1.0.9

# Configuring passenger
ENV HOME /root

CMD ["/sbin/my_init"]

RUN /pd_build/python.sh

# Installing Core

WORKDIR /home/app

RUN apt update && \
    apt-get update && apt install -y \
    autoconf \
    gawk \
    libreadline-dev \
    libtool \
    python3.6 \
    python3-pip

RUN curl \
    -O -L "https://github.com/coreemu/core/releases/download/release-5.5.2/requirements.txt" \
    -O -L "https://github.com/coreemu/core/releases/download/release-5.5.2/core_python3_5.5.2_amd64.deb"

RUN pip3 install -r requirements.txt  

RUN git clone https://github.com/USNavalResearchLaboratory/ospf-mdr

WORKDIR /home/app/ospf-mdr

RUN ./bootstrap.sh && \
    ./configure --disable-doc --enable-user=root --enable-group=root --with-cflags=-ggdb \
    --sysconfdir=/usr/local/etc/quagga --enable-vtysh \
    --localstatedir=/var/run/quagga && \
    make && \
    make install

WORKDIR /home/app

RUN apt update && \
    apt install -y ./core_python3_5.5.2_amd64.deb

# When done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Starting Core Daemon and Gui
# Note: Use VcXsrv X Server or similar Tools to connect to the GUI
# Commands (powershell):
# ipconfig (to get the IP of the NAT Adapter)
# Set-Variable -name DISPLAY -value YOUR_IP:0.0
# docker run -ti --rm -e DISPLAY=$DISPLAY --name core IMG_NAME

# ENTRYPOINT service core-daemon start \& && \
#     sleep 5 && \
#     core-gui --address 127.0.0.1 --port 4038
