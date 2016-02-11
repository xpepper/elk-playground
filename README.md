# Infrastruttura di prova ELK

Setup di una infrastruttura completa ELK:

- 1 nodo ELK

Indirizzi IP delle macchine:

- nodo ELK:       192.168.33.200

- Interfaccia Kibana:       `http://192.168.33.200`

## Requisiti

2. [VirtualBox](https://www.virtualbox.org/)
3. [Vagrant](https://www.vagrantup.com/) >= 1.8.*

Plugin vagrant

```
vagrant plugin install vagrant-berkshelf
vagrant plugin install vagrant-proxyconf
vagrant plugin install vagrant-cachier
```

## Configurazione

Creare il file .config.yml e aggiungere la propria configurazione proxy

es.
```
proxy: http://proxy.paros.local:1080
```

se non si usa nessun proxy aggiungere

```
proxy: false
```

## Avvio dell'intera infrastruttura

```
$ vagrant up
```
