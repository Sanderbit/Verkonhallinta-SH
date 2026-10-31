## Johdanto

Tutkin tässä tehtävässä kaapattua verkkoliikennettä ja containerlab ympäristön lokeja.

Kaappasin liikennettä web1-palvelimelta, suoritin nmap-porttiskannauksen attacker-koneelta ja analysoin kaappausta Wiresharkilla.

Lokeja tarkastelin journalctl:llä ja siihen lisättävillä parametreillä.

## Kaappaus

aloitetaan kaappaus:

root@web1:/# tcpdump -i eth1 -w web1.pcap

Kun porttiskannaus on suoritettu:

Lopetetaan kaappaus: CTRL+C

Kaappauksen tulos piti kopioida kontista pois komennolla:

docker cp clab-hamk-verkonhallinta-golden-web1:/web1.pcap .

Tämän jälkeen tiedosto piti vielä ladata pois ympäristöstä (Tein itse VScode downloadilla)

Lopulta avataan tulos Wiresharkilla

## Porttiskannaus

nmap 10.10.20.101

Ei toiminut ilman lisäparametria -Pn

nmap -Pn 10.10.20.101

Porttiskannaus kuvakaappaus:

~/images/porttiskannaus.png

## Wireshark

- Skannaus tuli IP-osoitteesta: 10.10.10.200 (attacker) 

- Ensiksi hyökkääjä testaa onko kohde "elossa": 
    
        ~/images/ws_check.png
    Tämä ilmeisesti esti nmap:n käytön ilman -Pn parametriä. Jostain syystä Wiresharkissa testaus näyttää toimineen?

- Hyökkääjä testaa tuhat porttia SYN pyynnöillä: 

        ~/images/ws_ports.png (Pieni osa koko kyselyä)

- Portti 22 on ainoa mihin kohde vastaa SYN, RST sijaan: 

        ~/images/ws_found.png

- En tiedä miksi nmap:n kuvakaappaus (porttiskannaus.png) ei näytä mitään porteista, vaikka SSH portti(22) Wiresharkin mukaan vastasi ja yritti monta kertaa uudelleen saada ACK 

- Kaappauksessa ei ollut DNS tai HTTP liikennettä


## Loki-analyysi

### Kirjautumiset
- Tarkastellaan journalctl:stä kirjautumisia ja sudo:n käyttöjä komennolla: 
        
        journalctl -q SYSLOG_FACILITY=10 SYSLOG_FACILITY=4 
    ~/images/logins.png  (Pieni osa tulostetta)

    SYSLOG_FACILITY=10 ja 4, kohdentaa journalctl:n "Security/authorization messages" -facilityyn. Jostain syystä samaa kohdetta on olemassa kaksi, en tiedä tarkalleen miksi. Varmuuden vuoksi käytän molempia

### Virhetilanteet

- Tarkastellaan virheitä komennolla:

        journalctl -p err
    ~/images/errors.png (Pieni osa tulostetta)

### Palveluiden käynnistykset

- Tarkastellaan nykyisen bootin ohjelmien käynnistyksiä ja lopetuksia komennolla (-b pois jos haluaa kaikkien boottien):

        journalctl -b | grep -E "Started|Stopping|Stopped"
    ~/images/started.png 

## Turvallisuusarvio

- Turvallista on, että vain yksi portti oli auki (22)

- Tietoturvariskinä on ainakin että SSH portti ei suoraan rajoita pääsyä ja on altis brute force kohde. Lisäksi, web1 vastaa kaikkiin pyyntöihin, eikä suoraa tiputa niitä. Mahdollinen kuormitus kohde?

- Parannuksena ainakin palomuurisääntö SSH:n sallimiselle vain tarvittavista osotteista. 


## Yhteenveto

- Opin ainakin tunnistamaan TCP SYN Stealth skannauksen verkkoliikennekaappauksesta

- Opin myös miten tehdään TCP SYN Stealth skannaus. Paljon lisää opeteltavaa asiasta tarvittaessa