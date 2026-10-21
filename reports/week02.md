# Tehtävä 2.3

Järjestelmän nimi: web1

Käyttöjärjestelmä: Linux 6.18.33.2-microsoft-standard-WSL2

uptime: Timeticks: (85754) 0:14:17.54

# Tehtävä 2.4

SNMPv2-MIB::sysName.0 = STRING: web1

SNMPv2-MIB::sysDescr.0 = STRING: Linux web1 6.18.33.2-microsoft-standard-WSL2 #1 SMP PREEMPT_DYNAMIC Thu Jun 18 21:54:43 UTC 2026 x86_64

DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (106819) 0:17:48.19

# Tehtävä 2.5

root@ansible:/# snmpwalk -v2c -c public web1 ifDescr

IF-MIB::ifDescr.1 = STRING: lo

IF-MIB::ifDescr.87 = STRING: eth0

IF-MIB::ifDescr.102 = STRING: eth1

3 verkkorajapintaa

root@ansible:/# ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
93: eth0@if94: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:14:14:06 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.20.20.6/24 brd 172.20.20.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:acff:fe14:1406/64 scope link
       valid_lft forever preferred_lft forever
108: eth1@if107: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9500 qdisc noqueue state UP group default
    link/ether aa:c1:ab:bb:60:91 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    altname clab-o-36a02884b166b7e8
    inet6 fe80::a8c1:abff:febb:6091/64 scope link
       valid_lft forever preferred_lft forever

eth0 yhdistää verkkoon

# Tehtävä 2.6

| OID | Tarkoitus |
|------|------|
| sysName.0 | Laitteen nimi |
| sysDescr.0 | Laitteen kuvaus |
| sysUpTime.0 | Aika laitteen käynnistymisestä |
| ifDescr | Verkkorajapintojen nimet |
| ifOperStatus | Verkkorajapintojen yhteyden status: 1 = up, 2 = down, 3=testing |

# Tehtävä 2.7

| Laite | Nimi | Käyttöjärjestelmä | Uptime |
|---------|---------|---------|---------|
| web1 | web1 | Linux 6.18.33.2-microsoft-standard-WSL2 | Timeticks: (258225) 0:43:02.25 |
| db1 | db1 | Linux 6.18.33.2-microsoft-standard-WSL2 | Timeticks: (20083) 0:03:20.83 |
| branch-client | branch-client | Linux branch-client 6.18.33.2-microsoft-standard-WSL2 | Timeticks: (20190) 0:03:21.90 |

# Tehtävä 2.8

1. SNMP:llä saa helposti kerättyä customoidulla scriptillä olennaisia tietoja useasta verkossa olevasta koneesta

2. Yleisiä SNMP tiedonkeräyskohteita ovat:
    - rajapintojen liikennemäärät ja virheet
    - suorittimien kuormitus, muistin ja levytilan käyttö
    - käynnissä olevat prosessti
    - lämpötila ja muut anturitiedot laitteesta riippuen
    - reititys ja ARP-taulut

3. Isoin ongelma yhteisöpohjaisessa SNMPv2:ssa on tietoturva. Yhteisönimi kulkee verkossa salaamattomana ja sen voi mahdollisesti kaapata liikenteestä. Viesten aitoutta ei varmisteta ja siitä voi aiheutua vaaratilanteita

4. SNMPv3 olisi hyvä käyttää, kun verkossa liikkuu tietoturvavaatimusten alaista tietoa tai muuta salassa pidettävää. Se myös mahdollistaa paljon nykyaikaiseen tietoturvaan liittyviä ominaisuuksia.
