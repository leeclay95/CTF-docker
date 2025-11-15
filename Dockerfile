FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install packages
RUN apt-get update -y && \
    apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    openssh-server \
    sudo \
    iputils-ping \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# SSH setup
RUN mkdir -p /var/run/sshd

# Copy the vulnerable PHP app (we'll create it separately)
COPY ping.php /var/www/html/ping.php
RUN chown -R www-data:www-data /var/www/html/

# User setup
RUN useradd -m -s /bin/bash pa && \
    echo "pa:password123" | chpasswd

# Flags
RUN echo "ZmxhZ3t1c2VyLWNhcHR1cmVkMjAyNX0=" > /home/pa/user.txt && \
    echo "ZmxhZ3tyb290LWJlZm9yZWNocmlzdG1hczIwMjV9" > /root/root.txt && \
    chown pa:pa /home/pa/user.txt && \
    chmod 600 /home/pa/user.txt && \
    chmod 600 /root/root.txt

# Privilege escalation misconfigurations
RUN chmod u+s /usr/bin/find && \
    echo "pa ALL=(ALL) NOPASSWD: /usr/bin/nano" >> /etc/sudoers

# Cleanup
RUN rm -f /home/pa/.bash_history /root/.bash_history

# Copy and setup startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 22

CMD ["/start.sh"]
