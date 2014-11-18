Docker Devbox
=============

A development environment containing:

* Emacs
* C/C++ compilers and tools
* Golang compilers and tools
* Python and tools
* PHP
* git
* tmux
* ssh

The devbox is as stateless as possible, every dev done inside it is
doomed to be destroyed, unless pushed to an external Git
repository. The idea is to be able fire up a known environment on a
new box, without spending 3 hours to figure out what is needed.

Usage
-----

This is a personnal Devbox, without my own set of configs and
tools. If you want to use it, fork it and edit your configuration
files to your needs.

The Dockerfile is split in two parts:

* a generic part containing what you probably need
* a non-generic part that you should tweak.

    docker run -d -h mxs-devbox --name mxs-devbox mxs-devbox

You can also edit and use the `devbox` script, to start the container
if it is not started, and ssh into it.
