# Raportti

# Johdanto:

Virtuaalisen ympäristön tarkoitus on simuloida verkkoa joka vastaa erittäin kevyttä pienyrityksen verkkoa. Siinä on kolme reititintä, päätelaitteita, palvelimia, "hyökkääjä" -laite sekä valvonta- ja automaatiotyökaluja. 


# Verkkokaavio:

Verkkotopologia kuva löytyy polusta: ~/images/topology_v2.png


# Laiteluettelo:

| Laite | Tarkoitus |
|---------|---------|
| r1 | Reititin. Yhdistää USERS-verkon muuhun verkkoon r2:n kautta |
| r2 | "Keskimmäinen" reititin. Yhdistää r1:n, r3:n sekä SERVER- ja MANAGEMENT-verkon toisiinsa |
| r3 | Reititin. Yhdistää sisartoimipisteen BRANCH-verkon r2:n kautta muuhun verkkoon  |
| client1 | "Asiakkaan" päätelaite|
| attacker |"Hyökkääjän" päätelaite |
| web1 | Verkkosivupalvelin|
| db1 | Tietokantapalvelin|
| branch-client | Sisartoimipisteen päätelaite|
| ansible | Palvelin joka ajaa Ansible -softaa. Automatisoi konfigurointia|
| prometheus | Palvelin joka ajaa Prometheus -softaa. Kerää mittaustietoa laitteilta |
| grafana | Palvelin joka ajaa Grafana -softaa. Visualisoi kerättyä dataa dashboardeiksi|
| zabbix | Palvelin joka ajaa Zabbix -softaa. Seuraa laitteiden ja palveluiden tilaa|

# IP-suunnitelma

| Verkko | Tarkoitus | Yhdyskäytävä | Laitteet |
|---------|---------|---------|---------|
| 10.10.10.0/24 | Käyttäjäverkko (USERS) | 10.10.10.1 (r1)| client1, attacker |
| 10.10.20.0/24 | Palvelimien verkko (SERVER) | 10.10.20.1 (r2) | web1, db1 |
| 10.10.30.0/24 | Sisartoimipisteen verkko (BRANCH) | 10.10.30.1 (r3) | branch-client |
| 10.10.99.0/24 | Hallinnan verkko (MANAGEMENT)| 10.10.99.1 (r2) | ansible, prometheus, grafana, zabbix |
| 10.255.12.0/30 | r1-r2 yhteys | 10.255.12.1 ja 10.255.12.2 | r1, r2 |
| 10.255.23.0/30 | r2-r3 yhteys | 10.255.23.1 ja 10.255.23.2 | r2, r3 |

Containerlab luo konteille myös eth0-liitännään verkkoon 172.20.20.0/24. Koska se ei liity verkon rakenteeseen, en ole huomioinut sitä yleisesti dokumentoinnissa

### Tärkeimmät IP-osoitteet

| Laite | Osoite | Verkko |
|---------|---------|---------|
| client1 | 10.10.10.101 | 10.10.10.0/24 (USERS)|
| web1 | 10.10.20.101 | 10.10.20.0/24 (SERVER) |
| branch-client | 10.10.30.101 | 10.10.30.0/24 (BRANCH) |



# Reitityksen analyysi:

### Adapterit (client1)


root@client1:/# ip addr

1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever

43: eth1@if44: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9500 qdisc noqueue state UP group default
    link/ether aa:c1:ab:f6:43:63 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    altname clab-o-05031180f95d8850
    inet 10.10.10.101/24 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a8c1:abff:fef6:4363/64 scope link
       valid_lft forever preferred_lft forever

57: eth0@if58: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:14:14:0d brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.20.20.13/24 brd 172.20.20.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe14:140d/64 scope link
       valid_lft forever preferred_lft forever

### Ping-testit

root@client1:/# ping -c 4 10.10.20.101

PING 10.10.20.101 (10.10.20.101) 56(84) bytes of data.
64 bytes from 10.10.20.101: icmp_seq=1 ttl=62 time=0.317 ms
64 bytes from 10.10.20.101: icmp_seq=2 ttl=62 time=0.151 ms
64 bytes from 10.10.20.101: icmp_seq=3 ttl=62 time=0.167 ms
^C


--- 10.10.20.101 ping statistics ---

3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 0.151/0.211/0.317/0.074 ms


root@client1:/# ping -c 4 10.10.30.101

PING 10.10.30.101 (10.10.30.101) 56(84) bytes of data.
64 bytes from 10.10.30.101: icmp_seq=1 ttl=61 time=1.48 ms
64 bytes from 10.10.30.101: icmp_seq=2 ttl=61 time=0.214 ms
64 bytes from 10.10.30.101: icmp_seq=3 ttl=61 time=0.130 ms
^C


--- 10.10.30.101 ping statistics ---

3 packets transmitted, 3 received, 0% packet loss, time 2011ms
rtt min/avg/max/mdev = 0.130/0.606/1.475/0.615 ms


Yhteys toimi sekä palvelinverkkoon että sisartoimipisteen verkkoon

### Traceroute

root@client1:/# traceroute 10.10.30.101

traceroute to 10.10.30.101 (10.10.30.101), 30 hops max, 60 byte packets

 1  10.10.10.1 (10.10.10.1)  1.751 ms  1.657 ms  1.634 ms

 2  10.255.12.2 (10.255.12.2)  1.616 ms  1.527 ms  1.501 ms

 3  10.255.23.2 (10.255.23.2)  1.477 ms  1.144 ms  1.090 ms

 4  10.10.30.101 (10.10.30.101)  0.692 ms  0.428 ms  0.266 ms


      Hyppy 1: 10.10.10.1 (r1)

      Hyppy 2: 10.255.12.2 (r1-r2 yhteyden r2-pää)

      Hyppy 3: 10.255.23.2 (r2-r3 yhteyden r3-pää)

      Hyppy 4: 10.10.30.101 (branch-client) KOHDE


 ### Reittitauluanalyysi

root@client1:/# ip route
default via 10.10.10.1 dev eth1
10.10.10.0/24 dev eth1 proto kernel scope link src 10.10.10.101
172.20.20.0/24 dev eth0 proto kernel scope link src 172.20.20.13

   - default via 10.10.10.1 dev eth1

         Oletusyhdyskäytävä verkkoliikenteelle r1:n kautta
   - 10.10.10.0/24 dev eth1

         Omaan verkkoon (USERS) yhteys suoraan
   - 172.20.20.0/24 dev eth0

         Containerlabin hallintaverkko

client1:llä ei tietoa muista aliverkoista



 # Yhteenveto

 Eniten aikaa dokumentaation luomisessa meni tutkia verkkoja ja mitä laitteita niihin kuuluu.

 Uskon, että dokumentaatio auttaisi palvelusta vastaavaa IT-työntekijää helposti selvittämään miten verkko toimii ja mitä kaikkea siihen kuuluu

 
