# Johdanto

Prometheus on avoimen lähdekoodin monitorointijärjestelmä, joka kerää mittareita aikasarjatietokantaan.

Prometheus hakee mittarit kohteista HTTP:llä säännöllisin väliajoin

# Tehtävä 3.2

Node Exporter esimerkkidata:

~/images/nodeE.png

# Tehtävä 3.3

Prometheus-web1 -yhteys:

~/images/prometheus.png

# Tehtävä 3.4

Grafana-Prometheus -yhteys:

~/images/prometheus_yhteys.png

# Tehtävä 3.6

CPU-käyrä nousi terävästi n. 15% utilisatioon, pysyi siinä noin neljä minuuttia, ja sitten laski normaaliin

Levytilan käyttö nousi nopeasti testitiedoston luomisen aikana ja pysyy nyt siinä

Verkkoliikenteessä ei muuten testien aikana tapahtunut muutoksia, paitsi kun asensin cpu:n kuormitukseen sovelluksen

Kuvakaappaukset tarkkailusta:

~/images/graf_cpu_mem_disk.png
~/images/graf_network.png

# Tehtävä 3.7

| Ominaisuus | SNMP | Prometheus |
|------------|------|------------|
| Tiedonkeruu | Valvontajärjestelmä kysyy laitteilta arvoja (pollaus). Laite voi myös lähettää trap-ilmoituksia | Hakee mittarit kohteista HTTP:llä säännöllisin välein |
| Käyttöönotto | Usein valmiina laitteissa, pitää vain asettaa käyttöön ja valita "community". MIB-tiedostot tuotti itselleni vaivoja | Asennetaan Prometheus ja valitsemasi exporter (Node Exporter) |
| Mittarien määrä | Rajattu laitteen ja MIB:n tarjoamiin | Todella paljon, ja omia voi luoda suhteellisen helposti lisää |
| Visualisointi | Ei omaa visualisointia, tarvitaan erillinen työkalu (esim. Zabbix) | Oma yksinkertainen käyttöliittymä yksittäisiin queryihin, yleensä käytetään Grafanaa lisänä |
| Hälytysmahdollisuudet | Hälytykset tehdään valvontatyökalussa kynnysarvoilla | Hälytyssäännöt tehdään PromQL:llä ja Alertmanager lähettää ilmoitukset eteenpäin (esim. sähköposti) |
| Soveltuvuus pilviympäristöihin | Heikko, soveltuu paremmin perinteisiin verkkolaitteisiin | Erinomainen |

# Tehtävä 3.8

1. Mitä hyötyä Prometheuksesta on verrattuna SNMP:hen?

    - Prometheus löytää kohteet automaattisesti, tarjoaa enemmän mittareita, hälytykset on helppo määrittää ja Grafana tekee helposti selkeämmän dashboardin

2. Millaisia mittareita ylläpitäjän kannattaa seurata jatkuvasti?

    - CPU-kuorma, muistin käyttö, levytila, verkkoliikenne ja palveluiden tila

3. Mitä tietoa dashboardisi tarjoaa ylläpitäjälle?

    - Ympäristön yleisen tilan silmäyksellä

4. Mitä uusia mittareita lisäisit dashboardiin?

    - Ainakin lämpötilan seurannan

5. Miten monitorointitiedosta voisi olla hyötyä vianetsinnässä?

    - Historiasta näkee milloin ongelma alkoi ja mitkä mittarit muuttuivat samaan aikaan vian alun kanssa


# Yhteenveto

Opin harjoituksesta hyvin, miten Prometheus toimii ja kerää mittareita, sekä miksi kylkeen tarvitaan Node Exporter tai joku muu. Kuormitustestillä näki hyvin miten kuorma esiintyy mittareissa.

SNMP sopii edelleen hyvin verkkolaitteisiin, mutta palvelimiin ja pilviympäristöihin Prometheus sopii monipuolisuutensa vuoksi paremmin