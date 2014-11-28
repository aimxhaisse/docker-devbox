FROM debian:testing
MAINTAINER s. rannou <mxs@sbrk.org>

# Distro
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Common packages
RUN apt-get install -q -y									\
    	    sudo										\
    	    wget										\
	    python										\
	    python-dev										\
	    python-pip										\
	    python-virtualenv									\
	    openssh-server									\
   	    emacs24-nox										\
	    git-core										\
    	    zsh											\
	    tmux										\
	    htop										\
	    pep8										\
	    golang										\
	    python-sphinx									\
	    php5-cgi										\
	    aptitude										\
	    locales										\
	    rubygems										\
	    ruby-dev										\
	    linkchecker										\
	    links										\
	    unzip										\
	    curl										\
	    imagemagick										\
	    nodejs										\
	    npm											\
	    docker.io										\
	    yaml-mode										\
    && apt-get clean -q -y

# Locales
RUN sed -i 's/# \(en_US.UTF-8.*\)/\1/' /etc/locale.gen						\
    && locale-gen en_US en_US.UTF-8

# Setup ssh
RUN mkdir /var/run/sshd

# Setup user mxs
RUN yes | adduser --disabled-password mxs --shell /bin/zsh					\
    && usermod -a -G docker mxs									\
    && mkdir -p /home/mxs/.ssh/									\
    && wget https://github.com/aimxhaisse.keys -O /home/mxs/.ssh/authorized_keys		\
    && chown -R mxs:mxs /home/mxs								\
    && chmod 700 /home/mxs/.ssh									\
    && chmod 600 /home/mxs/.ssh/authorized_keys							\
    && echo '%mxs   ALL= NOPASSWD: ALL' >> /etc/sudoers						\
    && sudo -u mxs sh -c 'cd /home/mxs ; wget http://install.ohmyz.sh -O - | sh || true'

# Blog
RUN gem install redcarpet jekyll

# Confs and files
ADD confs/motd /etc/motd
ADD confs/emacs /home/mxs/.emacs
ADD confs/gitconfig /home/mxs/.gitconfig
ADD confs/zsh /home/mxs/.zshrc
RUN chown mxs:mxs /home/mxs/.emacs /home/mxs/.gitconfig /home/mxs/.zshrc

# Dockerception
ADD bin/wrapdocker /usr/local/bin/wrapdocker
RUN pip install fig

ADD bin/init /init-container
EXPOSE 22 20000
CMD ["/init-container"]
