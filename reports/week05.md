## Johdanto

Tietoturva verkonhallinnan näkökulmasta.

## Kaappaus

aloitetaan kaappaus:

root@web1:/# tcpdump -i eth1 -w web1.pcap

Kun porttiskannaus on suoritettu:

Lopetetaan kaappaus: CTRL+C

Kaappauksen tulos piti kopioida kontista pois komennolla:

docker cp clab-hamk-verkonhallinta-golden-web1:/web1.pcap .

Tämän jälkeen tiedosto piti vielä ladata pois ympäristöstä (VScode downloadilla)

## Porttiskannaus

nmap 10.10.20.101

Ei toiminut ilman lisäparametria -Pn

nmap -Pn 10.10.20.101

Porttiskannaus kuvakaappaus:

~/images/porttiskannaus.png

## Wireshark

Havaintoja liikenteestä.

## Loki-analyysi

Tutkitut lokit ja löydökset.

## Turvallisuusarvio

Parannusehdotukset.

## Yhteenveto

Opitut asiat.
