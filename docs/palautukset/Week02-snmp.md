# Viikko 2 – SNMP ja verkon perustason valvonta

## Tavoite

Verkonhallinnassa dokumentaatio ei yksin riitä. Ylläpitäjän on pystyttävä keräämään tietoa verkon laitteista ja palvelimista automaattisesti.

Tässä tehtävässä tutustutaan SNMP-protokollaan (Simple Network Management Protocol) ja kerätään tietoa kurssiympäristön laitteista.

Harjoituksen jälkeen osaat:

- asentaa SNMP-agentin Linux-laitteeseen
- suorittaa SNMP-kyselyitä
- tunnistaa keskeisiä SNMP-objekteja
- kerätä tietoa verkon laitteista
- dokumentoida valvontatietoja

---

# Oppimistavoitteet

Tehtävän jälkeen osaat:

- selittää SNMP:n toimintaperiaatteen
- tunnistaa manager- ja agenttimallin
- käyttää SNMP-kyselyitä
- kerätä tietoa verkon laitteista
- hyödyntää SNMP:tä verkon valvonnassa

---

# Lähtötilanne

Varmista että ympäristö on käynnissä:

```bash
bash scripts/status.sh
```

Tarvittaessa käynnistä ympäristö:

```bash
bash scripts/deploy.sh
```

---

# Teoria

SNMP muodostuu kahdesta pääkomponentista:

## SNMP Agent

Agentti toimii valvottavassa laitteessa.

Esimerkkejä:

- Linux-palvelin
- Reititin
- Kytkin
- Tulostin

Agentti vastaa valvontapalvelimen kyselyihin.

---

## SNMP Manager

Manager kerää tietoa agenteilta.

Esimerkkejä:

- Zabbix
- PRTG
- LibreNMS
- Observium

Kurssilla käytämme aluksi komentorivityökaluja.

---

# Tehtävä 2.1 – SNMP-agentin asennus

Kirjaudu web1-palvelimelle:

```bash
docker exec -it clab-hamk-verkonhallinta-golden-web1 bash
```

Asenna SNMP-agentti:

```bash
apt update
apt install snmp snmpd -y
```

Tarkista palvelun tila:

```bash
systemctl status snmpd
```

tai

```bash
service snmpd status
```

---

# Tehtävä 2.2 – SNMP-konfigurointi

Avaa konfiguraatiotiedosto:

```bash
nano /etc/snmp/snmpd.conf
```

Lisää tai muuta yhteisön nimeksi:

```text
rocommunity public
```

Käynnistä palvelu uudelleen:

```bash
service snmpd restart
```

Tarkista että prosessi on käynnissä:

```bash
ps aux | grep snmpd
```

---

# Tehtävä 2.3 – Ensimmäinen SNMP-kysely

Kirjaudu ansible-palvelimelle:

```bash
docker exec -it clab-hamk-verkonhallinta-golden-ansible bash
```

Asenna työkalut:

```bash
apt update
apt install snmp -y
```

Testaa yhteys:

```bash
snmpwalk -v2c -c public web1 system
```

Dokumentoi tulokset:

- järjestelmän nimi
- käyttöjärjestelmä
- uptime

---

# Tehtävä 2.4 – Kerää järjestelmätiedot

Suorita seuraavat kyselyt:

### Järjestelmän nimi

```bash
snmpget -v2c -c public web1 sysName.0
```

### Järjestelmän kuvaus

```bash
snmpget -v2c -c public web1 sysDescr.0
```

### Käyttöaika

```bash
snmpget -v2c -c public web1 sysUpTime.0
```

Tallenna vastaukset raporttiin.

---

# Tehtävä 2.5 – Verkkorajapinnat

Listaa rajapinnat:

```bash
snmpwalk -v2c -c public web1 ifDescr
```

Selvitä:

- montako verkkorajapintaa löytyi
- mikä rajapinta yhdistää laitteen verkkoon

Dokumentoi havainnot.

---

# Tehtävä 2.6 – MIB-objektien tutkiminen

Selvitä seuraavien objektien tarkoitus:

| OID | Tarkoitus |
|------|------|
| sysName.0 | |
| sysDescr.0 | |
| sysUpTime.0 | |
| ifDescr | |
| ifOperStatus | |

Voit käyttää:

```bash
snmptranslate
```

tai internetistä löytyviä MIB-hakemistoja.

---

# Tehtävä 2.7 – Usean laitteen valvonta

Asenna SNMP-agentti myös seuraaville laitteille:

- db1
- branch-client

Suorita kyselyt kaikille kolmelle laitteelle.

Täydennä taulukko:

| Laite | Nimi | Käyttöjärjestelmä | Uptime |
|---------|---------|---------|---------|
| web1 | | | |
| db1 | | | |
| branch-client | | | |

---

# Tehtävä 2.8 – Pohdinta

Vastaa seuraaviin kysymyksiin:

1. Mitä hyötyä SNMP:stä on verkonhallinnassa?
2. Mitä tietoa SNMP:n avulla voidaan kerätä?
3. Mitä ongelmia yhteisöpohjaisessa SNMPv2:ssa on?
4. Missä tilanteissa käyttäisit mieluummin SNMPv3:a?

---

# Raportointi

Luo tiedosto:

```text
reports/week02.md
```

Raportin tulee sisältää:

## 1. Johdanto

Mikä on SNMP?

## 2. Asennus

Miten SNMP-agentti asennettiin?

## 3. Kerätyt tiedot

Kuvaukset ja tulosteet.

## 4. Verkkorajapinnat

SNMP:n avulla kerätyt rajapintatiedot.

## 5. OID-analyysi

OID-objektien käyttötarkoitus.

## 6. Pohdinta

Omat havainnot SNMP:n hyödyistä ja rajoituksista.

---

# Palautus

Palauta:

```text
reports/week02.md
```

Mahdolliset kuvakaappaukset:

```text
reports/images/
```

---

# Arviointikriteerit (10 p)

| Kohde | Pisteet |
|---------|---------:|
| SNMP-asennus | 2 p |
| SNMP-kyselyt | 3 p |
| OID-analyysi | 2 p |
| Usean laitteen valvonta | 2 p |
| Raportin laatu | 1 p |

## Erinomaisen suorituksen tunnusmerkit

- SNMP toimii usealla laitteella.
- Tulokset on dokumentoitu selkeästi.
- OID-objektit on selitetty oikein.
- Raportissa pohditaan myös tietoturvaa ja SNMP:n rajoituksia.