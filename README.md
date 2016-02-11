# A simple but complete ELK setup

Just one ELK node, with IP address ``192.168.33.200``.

Kibana app is published on http://192.168.33.200

## Prerequisites

1. [VirtualBox](https://www.virtualbox.org/)
2. [Vagrant](https://www.vagrantup.com/) >= 1.8.*

### Required vagrant plugins

* vagrant-berkshelf
* vagrant-proxyconf
* vagrant-cachier _(this in optional BTW)_

```
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-cachier
```

## Configuration
Put a file named ``.config.yml`` into the root of the project and add there your proxy configuration

e.g.
```
proxy: http://proxy.something.local:1080
```

or, if you are not behind a proxy (you lucky guy!), just put

```
proxy: false
```
