#!/bin/bash
#
# Commands meant to run at every shell
#
# To be sourced by ~/.bashrc
#
# To run, add these lines to ~/.bashrc:
#
#	if [ -f "$CUSTOM_ROOT/.custom_bashrc" ] ; then
#		source "$CUSTOM_ROOT/.custom_bashrc"
#	fi
#

if [ -f "$CUSTOM_ROOT/bash_aliases" ] ; then
	source "$CUSTOM_ROOT/bash_aliases"
fi

# Disable the dreaded history expansion for interactive sessions
# A.K.A 'why echo "Hello World!" do not work?'
set +o histexpand # same as set +H

wine-cd() {
	local prefix="$1"
	if [[ -z "$1" || "$1" = "default" ]] ; then
		# default prefix
		cd "$HOME/.wine/drive_c"
	else
		cd "$WINEBOTTLEHOME/$prefix/drive_c"
	fi
}

wine-list() {
	ls "$@" "$WINEBOTTLEHOME"
}

wine-cmd() {
	local prefix="$1"
	local cmd="$2"

	if [ -z "$cmd" ] ; then
		echo "Usage: wine-cmd PREFIX COMMAND"
		echo ""
		echo "wine-cmd: error: please specify the command to run"
	else
		shift; shift
		env WINEPREFIX="$WINEBOTTLEHOME/$prefix" wine $cmd "$@"
	fi
}

wine-install() {
	wine-cmd "$1" "uninstaller"
}

wine-run() {
	local app="$1"
	local prefix

	if [ -z "$app" ] ; then
		echo "Usage: wine-run APP"
		echo ""
		echo "wine-run: error: please specify the application to run"
	else
		if [ ! -d "$WINEBOTTLEHOME/$app" ] ; then
			# default prefix
			prefix="$HOME/.wine"
		else
			prefix="$WINEBOTTLEHOME/$app"
		fi
		env WINEPREFIX="$prefix" wine cmd /c c:\run-$app.bat
	fi
}