FROM phusion/passenger-full:1.0.9

ENV HOME /root

CMD ["/sbin/my_init"]

COPY --chown=app:app src/core /home/app/core

RUN apt update && apt install -y \
    python3.6 \
    python3-pip
RUN    cd /home/app && \
    pip3 install -r core/daemon/requirements.txt

RUN apt install -y \
    libtool \
    libreadline-dev \
    autoconf gawk

# COPY --chown=app:app src/ospf-mdr /home/app/ospf-mdr

RUN cd /home/app && \
    git clone https://github.com/USNavalResearchLaboratory/ospf-mdr

RUN cd /home/app/ospf-mdr && \
    ./bootstrap.sh && \
    ./configure --disable-doc --enable-user=root --enable-group=root --with-cflags=-ggdb \
    --sysconfdir=/usr/local/etc/quagga --enable-vtysh \
    --localstatedir=/var/run/quagga && \
    make && \
    make install

COPY --chown=app:app src/core_6.0.0_amd64.deb /home/app/core_6.0.0_amd64.deb

RUN apt install -y ./home/app/core_6.0.0_amd64.deb

# When done
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Starting Core Daemon and Gui
# Note: Use VcXsrv X Server or similar Tools to connect to the GUI
# Commands (powershell):
# ipconfig (to get the IP of the NAT Adapter)
# Set-Variable -name DISPLAY -value YOUR_IP:0.0
# docker run -ti --rm -e DISPLAY=$DISPLAY --name core IMG_NAME

ENTRYPOINT /etc/init.d/core-daemon start && \
    sleep 5 && \
    core-gui --address 127.0.0.1 --port 4038
