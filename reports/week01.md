# Raportti

# Johdanto:

Ympäristön tarkoitus on simuloida verkkoa joka vastaa todella kevyttä, vaikkapa yrityksen verkkoa, asiakkailla, hyökkääjillä, tietokannoilla, ylläpitosovelluksilla ja erilaisilla aliverkoilla eri käyttötarkoituksille


# Verkkokaavio:

Topologia -kuva löytyy polusta: ~/images/topology.png


# Laiteluettelo:

| Laite | Tarkoitus |
|---------|---------|
| r1 | Reititin josta attacker ja client1 yhdistää verkkoihin|
| r2 | Reititin josta management ja palvelimet yhdistävät verkkoihin|
| r3 | Reititin josta Branch Client yhdistää verkkoihin |
| client1 | "Asiakkaan" päätelaite|
| attacker |"Hyökkääjän" päätelaite |
| web1 | Verkkosivu-palvelin|
| db1 | Tietokanta-palvelin|
| branch-client | "Sisaryritys asiakkaan" päätelaite|
| ansible | Palvelin joka ajaa Ansible -softaa|
| prometheus | Palvelin joka ajaa Prometheus -softaa |
| grafana | Palvelin joka ajaa Grafana -softaa|
| zabbix | Palvelin joka ajaa Zabbix -softaa|

# IP-suunnitelma



Pingailua:

Yhteys löytyi verkkoihin.
Liikenne kulki reitittimien välistä yhdyskäytävä verkkoa pitkin.
Reitille kuului reitittimet r2 ja r3.

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

root@client1:/# ip route
default via 10.10.10.1 dev eth1
10.10.10.0/24 dev eth1 proto kernel scope link src 10.10.10.101
172.20.20.0/24 dev eth0 proto kernel scope link src 172.20.20.13
root@client1:/# ping -c 10.10.20.101
ping: invalid argument: '10.10.20.101'
root@client1:/# ping -c 4 10.10.20.101
PING 10.10.20.101 (10.10.20.101) 56(84) bytes of data.
64 bytes from 10.10.20.101: icmp_seq=1 ttl=62 time=0.317 ms
64 bytes from 10.10.20.101: icmp_seq=2 ttl=62 time=0.151 ms
64 bytes from 10.10.20.101: icmp_seq=3 ttl=62 time=0.167 ms

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

root@client1:/# traceroute 10.10.30.101
traceroute to 10.10.30.101 (10.10.30.101), 30 hops max, 60 byte packets
 1  10.10.10.1 (10.10.10.1)  1.751 ms  1.657 ms  1.634 ms
 2  10.255.12.2 (10.255.12.2)  1.616 ms  1.527 ms  1.501 ms
 3  10.255.23.2 (10.255.23.2)  1.477 ms  1.144 ms  1.090 ms
 4  10.10.30.101 (10.10.30.101)  0.692 ms  0.428 ms  0.266 ms