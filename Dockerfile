FROM greyltc/archlinux-aur:yay

# Update and install dependencies
RUN pacman --quiet -Syyu --noconfirm \
    && pacman --quiet -S --noconfirm nano openssh wget cmake mtools dtc uboot-tools qemu-headless qemu-headless-arch-extra libpulse sdl2 libpng12 dosfstools openssh bridge-utils net-tools dnsmasq

# Install ARM compiler
RUN sudo -u ab -D~ bash -c "yay --quiet -S --noconfirm arm-linux-gnueabihf-gcc75-linaro-bin"

# Enable and setup ssh
RUN systemctl enable sshd \
    && /usr/bin/ssh-keygen -A

# Setup users, passwords and privileges
RUN echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers \ 
    && useradd -m reds && usermod -a -G wheel reds \ 
    && echo 'root:toor' | chpasswd \
    && echo "reds:reds" | chpasswd

# Configure ssh
RUN sed -i \
        -e 's/^#*\(PermitRootLogin\) .*/\1 yes/' \
        -e 's/^#*\(PasswordAuthentication\) .*/\1 yes/' \
        -e 's/^#*\(PermitEmptyPasswords\) .*/\1 yes/' \
        -e 's/^#*\(UsePAM\) .*/\1 no/' \
        /etc/ssh/sshd_config

# Expose tcp port
EXPOSE 22

# Copy lab retrieval utility
COPY scripts/retrieve_lab.sh /usr/bin

# Run openssh daemon
CMD ["/usr/sbin/sshd", "-D"]
