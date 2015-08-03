#!/bin/sh
###############################################################################
#
# Senderlogo-Updater 0.04 fred_feuerstein [NG-Team]
#
# Ziel:
# Mit dem Updater werden die neuen und/oder geaenderten Senderlogos 
# seit dem letzten NG Image Release (aktuell NG 2.31) ins Image geholt.
# Diese werden automatisch in das Logo-Verzeichnis:
# /share/tuxbox/neutrino/icons/logo kopiert bzw. vorhandene
# aktualisiert.
# Dazu ist eine Internetverbindung erforderlich.
# Welche Logos hinzugekommen sind, koennt ihr im NG-Forum sehen.
# Thread: Kleines Logopaket (Ergaenzung zum 2.xx NG Image)
# Dort ist auch zusaetzlich bei Bedarf ein Radio-Senderlogo-Paket
# zu finden.
#
# Achtung: der Senderlogo-Updater ist nur für SAT !
#
# Changelog:
# 0.02 = bisher konnten nur Logos upgedated werden, nun
#        koennen auch neue Symlinks angelegt werden.
# 0.01 = Startversion
#
###############################################################################



BNAME=${0##*/}

archive="ng_zusatzlogos.zip"
workdir=${archive%%.*}

cleanup() {
	rm -rf /tmp/$workdir /tmp/$archive
}

cleanup

cd /tmp && wget -q http://wget.biz/logos/$archive

if [ -e $archive ]; then
	mkdir $workdir
	cd $workdir

	unzip /tmp/$archive >/dev/null

	if [ -e info.txt ]; then
		msgbox msg=/tmp/$workdir/info.txt title="Info zum Logo-Addon" >/dev/null
	fi

	test -e updates && chmod 755 updates && ./updates

	echo "$BNAME: Logo-AddOn erfolgreich installiert"
else
	echo "$BNAME: Fehler beim Download von $archive"
fi

cleanup
