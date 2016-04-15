#!/bin/sh

###############################################################################
#
# Senderlogo-Updater 0.05 fred_feuerstein [NI-Team]
#
# Ziel:
# Mit dem Updater werden die neuen und/oder geänderten Senderlogos seit dem
# letzten NI Image Release (aktuell NI 3.1) ins Image geholt.
# Diese werden automatisch in das Logo-Verzeichnis:
# /share/tuxbox/neutrino/icons/logo kopiert bzw. vorhandene aktualisiert.
# Dazu ist eine Internetverbindung erforderlich.
# Welche Logos hinzugekommen sind, könnt ihr im NI-Forum sehen.
# Thread: Kleines Logopaket (Ergaenzung zum X.xx NI Image)
# Dort ist auch zusätzlich bei Bedarf ein Radio-Senderlogo-Paket zu finden.
#
# Achtung: der Senderlogo-Updater ist nur für SAT !
#
# Changelog:
# 0.05 = Download-URL und Dateiname angepasst (NG -> NI)
# 0.04 = Marginale Ausgabe-Änderungen
# 0.03 = kleine Änderungen
# 0.02 = bisher konnten nur Logos upgedated werden, nun
#        koennen auch neue Symlinks angelegt werden.
# 0.01 = Startversion
#
###############################################################################

archive="ni_zusatzlogos.zip"
workdir=${archive%%.*}

cleanup() {
	rm -rf /tmp/$workdir /tmp/$archive
}

cleanup

cd /tmp && wget -q http://www.neutrino-images.de/channellogos/$archive

if [ -e $archive ]; then
	mkdir $workdir
	cd $workdir

	unzip /tmp/$archive >/dev/null

	if [ -e info.txt ]; then
		msgbox msg=/tmp/$workdir/info.txt title="Info zum Logo-Addon" >/dev/null
	fi

	test -e updates && chmod 755 updates && ./updates

	echo "- Logo-Updater erfolgreich beendet."
else
	echo "- Fehler beim Download von $archive"
fi

cleanup
