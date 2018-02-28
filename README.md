# Vorlage für wissenschaftliche Arbeiten an der DHBW Horb
Diese Vorlage wurde nach Vorbild [dieser](https://github.com/dhbw-horb/latexVorlage) Vorlage erstellt, jedoch neu Strukturiert und unter Verwendung anderer Compilewerkzeuge.

Zum Bauen eines Dokuments soll der mitgelieferte Dockercontainer dienen. Dies gewährleistet über unterschiedliche Systeme hinweg gleiche Ergebnisse.

## Abhängigkeiten
Zum Compilen von Dokumenten wird lediglich Docker benötigt:

Arch Linux:
Installieren mit `sudo pacman -S docker docker-compose`

Debian/Ubuntu:
Installieren mit `sudo apt install docker docker-compose` 

Und starten mit `sudo systemctl start docker`.

## Bauen
Wenn docker läuft kann der buildcontainer mit

`make init`

initialisiert werden. Anschließend kann mit

`make`

das projekt gebaut werden. Dabei wird das `default` Target standardmäßig ausgeführt.


*  `make default` baut das Projekt still im container. 
Temporäre Dateien der verwendeten LaTeX Engine werden anschließend gelöscht.
Die Standardausgabe wird auf die mit MAKE_LOG spezifizierte Datei umgeleitet (Standardmäßig: make.logs)
*  `make grimey` baut das Projekt wie default, jedoch ohne die temporären Ausgabedateien im Anschluss zu löschen.
*  `make verbose` baut das Projekt wie grimey, leitet jedoch die Standardausgabe nicht um.
