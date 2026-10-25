## Johdanto

Infrastructure as Code tarkoittaa, että ympäristö hallitaan koodilla käsin tekemisen sijaan.

## Inventory

# Tehtävä 4.1

Inventory sisältää:

    Reitittimiä: r1, r2, r3

    Työasemia: client1, attacker, branch-client

    Palvelimia: web1, db1

    Valvontasovelluksia: prometheus, grafana, zabbix, cadvisor

    Hallintasovellus: ansible

Ryhmiä on muodostettu:

    Tyypin mukaan: routers, clients, servers, monitoring, management

    Verkon mukaan: user_network, server_network, branch_office

    Ryhmien ryhmiä: network_devices:children (routers)
    
        linux_hosts:children (clients, servers, monitoring, management)

        node_exporter:children (routers, clients, servers)

    Käyttöjärjestelmän mukaan: ubuntu_hosts (client1, web1, db1, branch-client)

Ryhmien hyötyjä on esim. yksi playbook saadaan ajettua koko ryhmälle, kirjautumisasetukset kirjoitetaan kerran ryhmän asetuksiin eikä joka koneelle erikseen, uuden koneen lisäys ryhmään ottaa sen automaattisesti mukaan toimintoihin.

Pingaus ei toiminut valvontasovelluksiin. Niistä mahdollisesti puuttuu ssh yhteytta varten

# Tehtävä 4.2

Suoritin: ansible-playbook -i ../inventory.ini ping.yml

Tuloksien kuvakaappaus: ~/images/playbook_ping.png

Playbook "ping.yml" testaa linux hostit pingaamalla ssh:n kautta, sekä reitittimet ajamalla komennon "show version" cli-yhteydellä

Tuloksista voidaan päätellä: 

    Koneita(client1, attacker, branch-client, web1, db1): voidaan hallita ansiblella, koska ssh, salasana ja Python toimivat

    Prometheus, grafana, zabbix ja cadvisor: Portti 22 ei ole auki, joten niissä ei ole vaadittua ssh-palvelinta

    ansible: ei ilmeisesti kelpuuttanut salasanaa (Unreachable, Permission denied)

    r1, r2, r2: ([WARNING]: ansible-pylibssh not installed, falling back to paramiko) Testaus ilmeisesti vaatisi pythonin moduulin "paramiko", joten testiyhteys epäonnistui


## SNMP Playbook

# Tehtävä 4.3

Muutin olemassa olevasta install-snmp.yml -tiedostosta hostit oikeiksi. snpmd:n käynnisty piti myös muuttaa muotoon "command: service snmpd start", koska konteista puuttuu systemd.

Playbookin ajo: 

cd /ansible/playbooks

ansible-playbook -i ../inventory.ini install-snmp.yml

Tuloksien kuvakaappaus:

~/images/snmp_playbook.png

Asennuksen varmistus näkyy kuvakaappauksessa


## Node Exporter Playbook

# Tehtävä 4.4

Muutin olemassa olevasta install-node-exporter.yml -tiedostosta hostit oikeiksi. Muuten playbook oli valmiiksi kurantti.

Playbookin ajo: 

cd /ansible/playbooks

ansible-playbook -i ../inventory.ini install-node-exporter.yml

Tuloksien kuvakaappaus:

~/images/node_playbook.png

# Tehtävä 4.5

Ajetaan: ansible all -i ../inventory.ini -m setup

Yllä oleva komento näyttää liikaa dataa joten pitää ajaa halutut tiedot yksittäin jos halutaan käyttää kyseistä komentoa jaa löytää tarvittavat tiedot:

ansible all -i ../inventory.ini -m setup -a "filter=ansible_distribution*"
ansible all -i ../inventory.ini -m setup -a "filter=ansible_default_ipv4"
ansible all -i ../inventory.ini -m setup -a "filter=ansible_processor_vcpus"
ansible all -i ../inventory.ini -m setup -a "filter=ansible_memtotal_mb"

| Kone | Käyttöjärjestelmä | IP-osoite | Prosessorit | Muisti (MB) |
|---|---|---|---:|---:|
| client1 | Ubuntu 24.04 | 10.10.10.101 | 8 | 7847 |
| attacker | Kali 2026.3 | 10.10.10.200 | 8 | 7847 |
| branch-client | Ubuntu 24.04 | 10.10.30.101 | 8 | 7847 |
| web1 | Ubuntu 24.04 | 10.10.20.101 | 8 | 7847 |
| db1 | Ubuntu 24.04 | 10.10.20.102 | 8 | 7847 |



## Vertailu

# Tehtävä 4.6

Käsin jokaiseen koneeseen täytyy kirjautua erikseen, helppo tehdä virheitä eikä jää automaattisesti dokumentaatiota

Ansiblella käyttämällä vähän aikaa playbookin tekemiseen, saat ajettua samat asiat vaikkapa sadoille koneille

Automaatio säästää aikaa, vähentää virheitä ja koneissa pysyy yhteneväisyys

Automaatio on välttämätöntä, kun koneita on paljon, ympäristö pitää pystyttää nopeasti uudelleen tai kun ympäristöjen pitää olla identtisiä

## Yhteenveto


Inventory kertoo, mitä koneita on ja miten ne on ryhmitelty.

Playbookilla sama työ ajetaan usealle koneelle yhdellä komennolla.

Asensin SNMP:n ja Node Exporterin Ansiblella web1-, db1- ja branch-client-koneille.

setup-moduulilla sai kerättyä koneiden tiedot (käyttöjärjestelmä, IP, prosessorit, muisti). Tässä olisi hyvänä vaihtoehtona vaikka erillinen playbook halutuilla tiedoilla. Liikaa dataa jos setup komennon ajaa ilman rajotteita

Automaatio säästää aikaa, vähentää virheitä ja pitää koneet samanlaisina.

Ympäristön ongelmat (puuttuva SSH, paramiko) piti selvittää virheilmoitusten perusteella.