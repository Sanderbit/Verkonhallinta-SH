## 1. Johdanto

Zabbix on avoimen lähdekoodin valvontajärjestelmä. Se pitää sisällään mittareiden keräyksen ja niiden historian tallentamisen, tiedon esittämisen dashboardeilla ja triggerit hälytyksiä varten. 

Tunnukset ensikirjautumiseen:

Username: Admin
<br>
Password: zabbix

## 2. Hostien lisääminen

- Hosts: Lista valvotuista laitteista. Täältä myös lisätään uusia
- Templates: Valmiita mittari- ja triggeripohjia
- Monitoring: Reaaliaikainen seuranta ja mahdolliset ongelmatilanteet
- Dashboards: Täällä tehdään monitorointia varten dashboardit ja valitaan mikä näkyy monitoringissa
- Alerts: En löytänyt "Alerts" kohtaa
- Reports: Näyttää erilaisia yleiskatsauksia koko järjestelmästä

Johtuuko ohjeiden pieni eroavaisuus zabbix version erosta? Ilmeisesti uudempi on hieman erilainen käyttöliittymältään


SNMP piti ensiksi käynnistää laitteisiin luomallani playbook skriptillä "deploy-snmp.sh"

Lisätään uusia hosteja: 
- Host name: web1
- Groups: Linux servers
- SNMP interface:
    - IP-address: 10.10.20.101
    - Port: 161
    - Community: Koska käytämme vanhaa zabbix versiota, community täytyy lisätä macrona:
        - {$SNMP_COMMUNITY}, Value: public
- Templates: Template OS Linux SNMPv2


<br>


- Host name: db1
- Groups: Linux servers
- SNMP interface:
    - IP-address: 10.10.20.102
    - Port: 161
    - Community: Koska käytämme vanhaa zabbix versiota, community täytyy lisätä macrona:
        - {$SNMP_COMMUNITY}, Value: public
- Templates: Template OS Linux SNMPv2


<br>


- Host name: branch-client
- Groups: Linux servers
- SNMP interface:
    - IP-address: 10.10.30.101
    - Port: 161
    - Community: Koska käytämme vanhaa zabbix versiota, community täytyy lisätä macrona:
        - {$SNMP_COMMUNITY}, Value: public
- Templates: Template OS Linux SNMPv2

<br>

Kuva hosteista toiminnassa:

        ~/images/hosts.png

## 3. Dashboard

Kuvakaappaus dashboardista:

        ~/images/dashboard.png

## 4. Mittarit

Valitut mittarit ja niiden merkitys.


| Mittari | Arvo | Merkitys |
|----------|----------|----------|
| CPU utilization | 4.8879 % | Prosessorin käyttö prosentteina |
| Available memory | 4.48 GB | Vapaana oleva keskusmuisti |
| Load average (1m avg) (CPU) | 0.4 | Kertoo prosessorin kuorman 1 minuutin keskiarvolla (1.0 tarkoittaa yhtä ydintä kokonaan käytössä) |
| Uptime | 00:31:03 | Kertoo kuinka kauan järjestelmän viime käynnistyksestä on |
| Space utilization | 1.2178 % | Kertoo kuinka paljon järjestelmä käyttää levytilaa |
| Bits received/sent (eth1) | 288/504 bps | Kertoo kuinka paljon verkkoliikennettä kyseisessä adapterissa |

## 5. Triggerit


Luotu CPU trigger:

        ~/images/trigger01.png



Luotu Levytila trigger:

        ~/images/trigger02.png


## 6. Hälytys- ja häiriötestit

### CPU kuormitus

Ajetaan komento laitteella web1:

        for i in $(seq 8); do yes > /dev/null & done

Täytyy ajaa for loop että saadaan virheilmoituksen rajaan asti kuormitus

Nähdään dashboardista että triggeri aktivoituu, noin 90 sekunttia kuormituksen aloituksesta:

        ~/images/triggered01.png


### Levytilan kulutus

Ajetaan komento laitteella web1:

        dd if=/dev/zero of=testifile.img bs=1M count=1000

Koska testikomento luo vain 1 GB tiedoston, hälytys ei triggeröidy. Kuvakaappauksessa näkyy pieni nousu levyn käytössä noin 30 sekunttia komennon lähettämisestä:

        ~/images/notriggered.png


### Häiriötilanne

Koska esimerkkipalveluissa ei ole automaattisesti seurantaa, pysäytän niiden sijaan SNMP:n web1 komennolla:

        service snmpd stop

Noin 90 sekunnin jälkeen ainoat merkit ovat Host status joka näyttää että 1 on alhaalla ja web1 muistin käytön pieni lasku ja jäätyminen:

        ~/images/snmp_down.png  (web1 has been restarted on ensimmäistä yritystä ja ei liity nykyiseen häiriötilaan)

Vasta noin 5 minuutin jälkeen Problems kohdassa näkyy että yhteys ei toimi ja asiasta tulee hälytys:

        ~/images/snmp_downdown.png

SNMP:n uudelleenkäynnistämisen jälkeen Host status näytti taas ensimmäisenä että kaikki toimii, Problems näytti resolvediä nopeasti sen jälkeen:

        ~/images/snmp_up.png 

web1 sai outoja lukuja ja sekoitti koko graafin piirtämisen SNMP:n uudelleenkäynnistämisessä. En löytänyt tapaa clearata pelkkää CPU util graafia että näyttäisi taas normaalilta


## 7. Vertailu

SNMP vs Prometheus vs Zabbix.


| Ominaisuus | SNMP | Prometheus | Zabbix |
|------------|------|------------|--------|
| Tiedonkeruu | Tarjoaa tiedot | Kerää tiedot exporterilta. Minulla Node Exporter | Hakee itse SNMP:llä tai agenteilta |
| Dashboardit | Ei ole | Ei omaa. Tehtiin grafanalla | Sisäänrakennettuna. Tehtiin oma |
| Hälytykset | Ei ole | Erillisellä Alertmanagerilla | Omat triggerit |
| Käyttöönotto | Helppo. Tarvitsee vain asentaa | Vaati jonkun verran selvittelyä että sai dataa muodostumaan, mutta löytää kaiken tarvittavan itse | Helppo etsiä kaikkia ominaisuudet, kun vain tietää oikean kohteen ja templaten |
| Skaalautuvuus | Riippu siitä millä tietoa kerää | Hyvä koska etsii kaiken itse | Vaatii enemmän itse asettamista, mutta hyvä jos tietokannasta löytyy tarvittavat itemit yms. |
| Yrityskäyttö | Verkkolaitteet | Pilvi- ja konttiympäristöissä | Perinteinen IT-infra |



1. Mitä hyötyä keskitetystä valvonnasta on?
    - Nopea häiriöiden havaitseminen ja selkeä historia
2. Mitkä mittarit ovat mielestäsi tärkeimpiä?
    - Aikalailla kaikki mitä käytettiin tehtävässä: CPU, keskusmuisti, levytila, verkkoliikenne ja palveluiden tila
3. Millaisista tilanteista ylläpitäjän pitäisi saada hälytys?
    - Levytila tulossa täyteen, CPU kuorma korkealla pitkään tai heti kun palvelu ei vastaa
4. Missä tilanteissa käyttäisit Prometheusta?
    - Konttiympäristöissä missä seurattavia asioita on paljon, tai jos haluat "hienon" näköisiä graafeja grafanalla
5. Missä tilanteissa käyttäisit Zabbixia?
    - Kaikissa normaaleissa palvelinympäristöissä. Jos tiedän tasan tarkkaan mitä laitteita on missäkin
6. Mitä valvontatoimintoja lisäisit tähän ympäristöön?
    - Viestihälytykset pahimpiin triggereihin, palvelunvalvonta kaikkiin ympäristön eri palveluihin ja vähän selkeämpää lokinäkymää

## 8. Yhteenveto

Kurssin tehtäviä tehdessä tuli virtuaaliympäristössä toimiminen ainakin tutuksi. Loppuvaiheessa workflow oli jo yllättävän sujuvaa hyödyntämällä VCodea ja sen eri ominaisuuksia.

Verkon hallintaan on monta eri työkalua ja vähän pelottaa että jos kurssin aikana käytetyt onkin vain pieni osa olemassa olevia. Zabbix on mielestäni toimivin useimpiin tilanteisiin.

Valvomalla hyvää dashboardia tarkkaan näkee kyllä helposti virhetilanteet, mutta oikeissa tilanteissa luulen, että pitää käyttää paljon aikaa miettiä kaikki tärkeimmät triggerit yms. ympäristöön ja konfiguroida ne lähettämään viestit heti kun jotain tapahtuu