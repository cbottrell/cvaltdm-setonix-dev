FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH
RUN apt-get update && apt-get install -y openssh-server python3-pip && rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/X11Forwarding no/X11Forwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's/#Port 22/Port 9300/' /etc/ssh/sshd_config && \
    sed -i 's/#StrictModes yes/StrictModes no/' /etc/ssh/sshd_config && \
    sed -i 's/UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

# Create SSH privilege separation directory
RUN mkdir -p /run/sshd

# Generate SSH host keys
RUN ssh-keygen -A && \
    chmod 644 /etc/ssh/ssh_host_*_key && \
    chmod 644 /etc/ssh/ssh_host_*_key.pub

# Create user with matching host UID/GID
RUN groupadd -g 25420 bottrell && \
    useradd -m -u 25420 -g 25420 -s /bin/bash bottrell

# Install Python packages
# RUN pip3 install --no-cache-dir requests numpy pandas

# Start SSH
CMD ["/usr/sbin/sshd", "-D"]

