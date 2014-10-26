FROM debian:wheezy
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
	    python-virtualenv									\
	    openssh-server									\
   	    emacs23-nox										\
	    git-core										\
    	    zsh											\
	    tmux										\
	    htop										\
	    pep8										\
	    golang										\
	    python-sphinx									\
	    jekyll										\
	    php5-cgi										\
	    aptitude										\
	    libxml2-dev										\
	    libxslt1-dev									\
	    rubygems										\
	    ruby-dev										\
    && apt-get clean -q -y

# Setup ssh
RUN mkdir /var/run/sshd

# Middleman
RUN gem install middleman

# Setup user mxs
RUN yes | adduser --disabled-password mxs --shell /bin/zsh					\
    && mkdir -p /home/mxs/.ssh/									\
    && wget https://github.com/aimxhaisse.keys -O /home/mxs/.ssh/authorized_keys		\
    && chown -R mxs:mxs /home/mxs								\
    && chmod 700 /home/mxs/.ssh									\
    && chmod 600 /home/mxs/.ssh/authorized_keys							\
    && echo '%mxs   ALL= NOPASSWD: ALL' >> /etc/sudoers						\
    && sudo -u mxs sh -c 'cd /home/mxs ; wget http://install.ohmyz.sh -O - | sh || true'

# Confs and files
ADD confs/motd /etc/motd
ADD confs/emacs /home/mxs/.emacs
ADD confs/gitconfig /home/mxs/.gitconfig
ADD confs/zsh /home/mxs/.zshrc
RUN chown mxs:mxs /home/mxs/.emacs /home/mxs/.gitconfig /home/mxs/.zshrc

EXPOSE 22 8080
CMD ["/usr/sbin/sshd", "-D"]
