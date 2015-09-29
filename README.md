vagrant-magento2-apache-base
============================

Quick and dirty Vagrant image for building Magento 2. The idea is you run
MySQL and Apache in a Vagrant 'box' (VM), but do all your development
using your normal tools on your desktop.

It purposely only uses shell scripts to configure things so readers can poke
around and not have to learn yet another technology like Chef, Puppet, or
Ansible. Serious developers might like to look at other Vagrant images.

See http://vagrantup.com/ for Vagrant installation instructions.

Make sure to install the latest version of VirtualBox and VirtualBox Addons before proceeding.

If you want a stable Vagrant set up, clone or keep a copy - I am going to
rework as I see fit for a while yet.

To use, check out Magento 2 and this Vagrant files in sibling directories.
For example:

    cd myprojects
    git clone https://github.com/magento/magento2.git
    git clone https://github.com/alankent/vagrant-magento2-apache-base.git

The Vagrantfile mounts ../magento2 under /var/www/magento2.

You can edit using your local tools in your laptop/desktop etc. Go into the
'magento2' directory and edit away!

To start up the Vagrant image, go into 'vagrant-magento2-apache-base' and
run 'vagrant up'. It contains its own MySQL database and Apache web server.
You need to log in and run the deploy script from inside for now. This runs
the Magento setup script (wipes database, wipes caches, creates config files
etc). This may change in the future

    cd vagrant-magento2-apache-base
    vagrant up

First time you check out the tree, you need to run composer to download 3rd
party libraries. You can do this on your laptop/desktop or inside Vagrant.
First time you do an install, later you would do a comoser update after each
git pull to make sure the libraries are kept up to date. This is slow, so I
did not include in the deploy.sh script.

    vagrant ssh -- "cd /var/www/magento2 && composer install"

You also need to create the local database, or occasionally wipe it to start
again. A deploy.sh shell script is provided to do this.

    vagrant ssh -- sh /vagrant/scripts/deploy.sh

Finally, accesses your site on your laptop/desktop using http://localhost:8080/

Feedback welcome!


See also
* Blog post https://alankent.wordpress.com/2014/12/21/reducing-magento-2-install-pain-through-virtualization/
* Alernative: Nicer than mine, but with all files inside VM https://github.com/ryanstreet/magento2-vagrant
* Another one: https://github.com/rgranadino/mage2_vagrant, using NFS for better hosting performance

(Future ideas include parameterizing so you can pick the web server (Apache or
Nginx), pick the database server (MySQL, MariaDB, Percona etc), add Redis,
Varnish etc auxiliary servers. One day!)
