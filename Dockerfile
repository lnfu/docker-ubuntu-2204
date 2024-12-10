FROM ubuntu:22.04

# locale
ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

# install packages
RUN apt-get update && apt-get install -y tini locales \
	sudo vim grep tmux diffutils file less tcpdump \
	man manpages manpages-dev \
	gcc gdb make yasm nasm \
	python3 python3-pip python3-virtualenv \
	libc6-dbg dpkg-dev \
	wget curl git zsh htop 

# locale
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN /usr/sbin/locale-gen

## allow empty password
#RUN sed -i 's/nullok_secure/nullok/' /etc/pam.d/common-auth

# add user/group, empty password, allow sudo
RUN groupadd -g 1000 efliao
# password = 12345678
RUN useradd --uid 1000 --gid 1000 --groups root,sudo,adm,users --create-home --password "`openssl passwd -6 -salt XX 12345678`" --shell /bin/bash efliao
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# run the service
ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["tail", "-f", "/dev/null"]

WORKDIR /home/efliao
