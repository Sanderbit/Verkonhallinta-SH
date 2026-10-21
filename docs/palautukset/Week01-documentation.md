# Viikko 1 – Verkon dokumentointi

## Tavoite

Verkonhallinnan ensimmäinen vaihe on ymmärtää hallittava ympäristö.

Tässä tehtävässä tutustut kurssin virtuaaliseen verkkoympäristöön, dokumentoit sen rakenteen ja tuotat verkkodokumentaation, jota hyödynnetään myöhemmissä harjoituksissa.

Työelämässä vastaavaa dokumentaatiota käytetään:

- verkon ylläpidossa
- vianetsinnässä
- muutostenhallinnassa
- tietoturvatarkastuksissa
- kapasiteettisuunnittelussa

---

# Oppimistavoitteet

Tehtävän jälkeen osaat:

- tunnistaa verkkoympäristön komponentit
- selvittää laitteiden väliset yhteydet
- dokumentoida IP-osoitteet ja verkot
- tuottaa verkkokaavion
- laatia teknisen verkkodokumentin

---

# Lähtötilanne

Käynnistä ympäristö:

```bash
bash scripts/deploy.sh
```

Tarkista ympäristön tila:

```bash
bash scripts/status.sh
```

Tutki topologiaa:

```bash
containerlab inspect -t topology/golden.clab.yml
```

---

# Tehtävä 1.1 – Topologian kartoitus

Selvitä ympäristössä olevat laitteet.

Dokumentoi vähintään:

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

Kirjoita lyhyt kuvaus jokaisesta laitteesta.

---

# Tehtävä 1.2 – Verkkokaavio

Piirrä verkkokaavio ympäristöstä.

Kaaviossa tulee näkyä:

- kaikki laitteet
- reitittimet
- IP-verkot
- yhteydet

Voit käyttää esimerkiksi:

- draw.io
- Visio
- PowerPoint
- käsin piirretty ja skannattu kuva

Malliesimerkki:

```text
                     Branch Office
                     10.10.30.0/24

                  branch-client
                        |
                       r3
                        |
                 10.255.23.0/30
                        |
                       r2
          --------------+--------------
          |                           |
          |                           |
     10.10.20.0/24              10.10.99.0/24
        Server LAN             Management LAN

      web1     db1        ansible
                            grafana
                            prometheus
                            zabbix

                        |
                 10.255.12.0/30
                        |
                       r1
                        |
                 10.10.10.0/24
                    User LAN

               client1
               attacker
```

---

# Tehtävä 1.3 – IP-osoitteiden dokumentointi

Täydennä seuraava taulukko:

| Verkko | Tarkoitus | Yhdyskäytävä |
|---------|---------|---------|
| 10.10.10.0/24 | Asiakkaiden verkko | 10.10.10.1 |
| 10.10.20.0/24 | Palvelimien verkko | 10.10.20.1  |
| 10.10.30.0/24 | "Branch asiakkaiden" verkko | 10.10.30.1 |
| 10.10.99.0/24 | Hallinnan verkko | 10.10.99.1 |
| 10.255.12.0/30 | r1-r2 yhdyskäytävä verkko | 10.255.12.1 ja 10.255.12.2  |
| 10.255.23.0/30 | r2-r3 yhdyskäytävä verkko | 10.255.23.1 ja 10.255.23.2 |

Selvitä lisäksi:

- Mitä laitteita kuhunkin verkkoon kuuluu?
  10.10.10.0/24: client1, attacker ja r1. Yhdyskäytävänä r1
  10.10.20.0/24: web1, db1 ja r2. Yhdyskäytävänä r2
  10.10.30.0/24: branch-client ja r3. Yhdyskäytävänä r3
  10.10.99.0/24: prometheus, ansible, grafana, cadvisor, zabbix ja r2. Yhdyskäytävänä r2
  10.255.12.0/30: r1 ja r2. Yhdyskäytävänä r1 ja r2
  10.255.23.0/30: r2 ja r3. Yhdyskäytävänä r2 ja r3
  
- Mikä reititin toimii yhdyskäytävänä?
- Mitä tarkoitusta verkko palvelee?

---

# Tehtävä 1.4 – Reitityksen tutkiminen

Kirjaudu client1-laitteelle:

```bash
docker exec -it clab-hamk-verkonhallinta-golden-client1 bash
```

Suorita seuraavat komennot:

```bash
ip addr
```

```bash
ip route
```

Testaa yhteydet:

```bash
ping -c 4 10.10.20.101
```

```bash
ping -c 4 10.10.30.101
```

Tutki reittiä branch-clientille:

```bash
traceroute 10.10.30.101
```

Dokumentoi:

- löytyykö yhteys kaikkiin verkkoihin
- mitä reittiä liikenne kulkee
- mitä reitittimiä reitille kuuluu

Lisää komentojen tulosteet raporttiin.

---

# Tehtävä 1.5 – Dokumentaation tuottaminen

Luo tiedosto:

```text
reports/week01.md
```

Raportin tulee sisältää seuraavat osiot.

## 1. Johdanto

Kuvaile lyhyesti ympäristön tarkoitus.

## 2. Verkkokaavio

Lisää laatimasi verkkokaavio.

## 3. Laiteluettelo

Taulukko ja kuvaukset ympäristön laitteista.

## 4. IP-suunnitelma

Dokumentoi:

- verkot
- aliverkot
- yhdyskäytävät
- tärkeimmät IP-osoitteet

## 5. Reitityksen analyysi

Sisällytä:

- ping-testit
- traceroute
- reittitauluanalyysi

## 6. Yhteenveto

Pohdi:

- Mitkä asiat verkon dokumentaation muodostamisessa kuluttivat eniten aikaa ja miksi?
- Miten dokumentaatio mielestäsi auttaa palvelusta vastaavaa it-asiantuntijaa työssään?
---

# Palautus

Palauta Git-repositorioon seuraavat tiedostot:

```text
reports/week01.md
```

sekä mahdolliset kuvat:

```text
reports/images/topology.png
```

Esimerkki hakemistorakenteesta:

```text
reports/
├── week01.md
└── images/
    └── topology.png
```

---

# Arviointikriteerit (10 p)

| Kohde | Pisteet |
|---------|---------:|
| Verkkokaavio | 3 p |
| IP-dokumentaatio | 2 p |
| Laiteluettelo | 2 p |
| Reitityksen analyysi | 2 p |
| Raportin laatu | 1 p |

## Erinomaisen suorituksen tunnusmerkit

- Kaavio on selkeä ja teknisesti oikea.
- Verkot ja osoitteet on dokumentoitu oikein.
- Reititys on analysoitu oikein.
- Raportti on teknisesti täsmällinen ja hyvin jäsennelty.
- Havainnot perustuvat tehtyihin mittauksiin ja komentojen tulosteisiin.

---

# Vinkkejä

Tutustu erityisesti seuraaviin komentoihin:

```bash
ip addr
```

```bash
ip route
```

```bash
ping
```

```bash
traceroute
```

```bash
containerlab inspect -t topology/golden.clab.yml
```
Tutustu myös [/docs/topology.md](https://github.com/tjarvenpaa/Verkonhallinta/blob/main/docs/topology.md)
Näitä samoja työkaluja käytetään myöhemmillä viikoilla vianetsinnässä, valvonnassa ja verkonhallinnassa.
``
