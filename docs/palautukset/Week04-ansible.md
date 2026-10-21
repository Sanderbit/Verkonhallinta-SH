# Viikko 4 – Ansible ja Infrastructure as Code

## Tavoite

Tähän asti palveluiden käyttöönotto on tehty käsin.

Tässä tehtävässä automatisoidaan ympäristön hallintaa Ansiblella.

Harjoituksen jälkeen osaat:

- käyttää Ansiblea usean koneen hallintaan
- luoda inventory-tiedoston
- suorittaa playbookeja
- automatisoida ohjelmistojen asennuksia
- hallita infrastruktuuria koodina

---

# Oppimistavoitteet

Tehtävän jälkeen osaat:

- selittää Infrastructure as Code -periaatteen
- käyttää Ansible inventorya
- suorittaa playbookeja
- asentaa ohjelmia etänä
- automatisoida palvelinten ylläpitotehtäviä

---

# Lähtötilanne

Kirjaudu Ansible-palvelimelle:

```bash
docker exec -it clab-hamk-verkonhallinta-golden-ansible bash
```

Tarkista inventory:

```bash
cat /ansible/inventory.ini
```

Tarkista yhteydet:

```bash
ansible all -i /ansible/inventory.ini -m ping
```

---

# Tehtävä 4.1 – Tutustu inventoryyn

Selvitä:

- mitä laitteita inventory sisältää
Inventory sisältäää kaikki verkossa toimivat laitteet, ja ne on ryhmitetty sopiviin ryhmiin

- miten ryhmät on muodostettu
Ryhmät on muodostettu käyttötarkoituksen mukaan

- mitä hyötyä ryhmistä on
Ryhmät mahdollistavat useamman kohteen yhden nimen alla

Dokumentoi havainnot.

---

# Tehtävä 4.2 – Suorita ensimmäinen playbook

Siirry playbook-hakemistoon:

```bash
cd /ansible/playbooks
```

Suorita:

```bash
ansible-playbook -i ../inventory.ini ping.yml
```

Dokumentoi:

- mitä playbook tekee
Playbook testaa yhteyden jokaiseen linux-koneeseen inventoryssä pingaamalla niitä.
Lisäksi se testaa reitittimet pyytämällä niitä näyttämään versionumeronsa

- mitä tuloksista voidaan päätellä
Tuloksista voidaan päätellä, että vaikka koneet ovat kaikki linux-koneita, niissä ei välttämättä ole kyseiseen "ping" testaukseen vaadittuja toimintoja asennettuna/saatavilla
---

# Tehtävä 4.3 – SNMP:n automatisointi

Luo playbook:

```text
install-snmp.yml
```

Playbookin tulee:

- päivittää pakettilista
- asentaa snmp
- asentaa snmpd
- käynnistää palvelu

Suorita playbook seuraaville koneille:

- web1
- db1
- branch-client

Varmista asennus.

---

# Tehtävä 4.4 – Node Exporterin automatisointi

Luo playbook:

```text
install-node-exporter.yml
```

Playbookin tulee:

- luoda hakemisto
- ladata Node Exporter
- purkaa paketti
- käynnistää palvelu

Asenna vähintään:

- web1
- db1

---

# Tehtävä 4.5 – Kerää järjestelmätietoja

Suorita:

```bash
ansible all -i ../inventory.ini -m setup
```

Kerää tiedot:

- käyttöjärjestelmä
- IP-osoite
- prosessorien määrä
- muistin määrä

Dokumentoi tulokset taulukkoon.

---

# Tehtävä 4.6 – Analyysi

Vertaa:

- käsin tehtyjä asennuksia
- Ansiblella tehtyjä asennuksia

Pohdi:

- mitä hyötyjä automaatiosta on
- missä tilanteissa automaatio on välttämätöntä

---

# Raportointi

Luo tiedosto:

```text
reports/week04.md
```

Raportin tulee sisältää:

## Johdanto

Mikä on Infrastructure as Code?

## Inventory

Ympäristön rakenne.

## SNMP Playbook

Koodi ja tulokset.

## Node Exporter Playbook

Koodi ja tulokset.

## Vertailu

Käsin vs. automaatio.

## Yhteenveto

Opitut asiat.

---

# Arviointikriteerit (10 p)

| Kohde | Pisteet |
|---------|---------:|
| Inventoryn ymmärtäminen | 2 p |
| SNMP Playbook | 3 p |
| Node Exporter Playbook | 3 p |
| Raportointi | 2 p |