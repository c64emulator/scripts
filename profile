#!/bin/sh
#
# Commands meant to run at every login
#
# To be sourced by ~/.profile
#
# To run, add these lines to ~/.profile:
#
#	export CUSTOM_ROOT="/path/to/custom"
#	if [ -f "$CUSTOM_ROOT/.custom_profile" ] ; then
#		. "$CUSTOM_ROOT/.custom_profile"
#	fi
#
# And edit "/path/to/custom" to the proper path (usually /dados/progs/linux)
# Dont forget to un-comment the lines too.
#
# Notes:
#
#  #!/bin/sh is specified to enforce compliance with /etc/gdm/Xession,
#  which sources ~/.profile at login. Thus, bashisms are not allowed here.
#
#  CUSTOM_ROOT variable must be set in ~/.profile, as this script rely on it
#
##############################################################################

if [ -z "$CUSTOM_ROOT" ] ; then
	export CUSTOM_ROOT=/dados/progs/linux
fi

export CUSTOM_SCRIPTS=$CUSTOM_ROOT/scripts
export CUSTOM_BIN=$CUSTOM_ROOT/bin

##############################################################################

# Prepend folders to $PATH, avoiding duplicates
# Parameters: a single string, ':' separated, cointaining the folders to add
# This function breaks the string and check each folder to avoid duplicates
prepend_path()
{
	SAVED_IFS="$IFS"
	IFS=:
	for folder in $1 ; do
		if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$folder" ) ; then
			PATH=$folder:$PATH
		fi
	done
	IFS="$SAVED_IFS"
	unset folder
}

##############################################################################

# Check (and fix) $HOME/.local/bin -> $CUSTOM_ROOT/bin relation
if [ -d "$HOME/.local/bin" ] ; then
	if [ -h "$HOME/.local/bin" ] ; then
		# ~/.local/bin is already a symlink (hopefully, to $CUSTOM_BIN).
		# So ill impersonate it, and its my job to maintain it.
		# Make sure it is in PATH.
		prepend_path "$HOME/.local/bin"
	else
		# ~/.local/bin is a physical, independent folder.
		# not my business to use it and/or add it to PATH.
		# So, add $CUSTOM_BIN
		prepend_path "$CUSTOM_BIN"
	fi
else
	# ~/.local/bin does not exist. Create Symlink and add it to PATH
	mkdir -p "$HOME/.local"
	ln -s "$CUSTOM_BIN" "$HOME/.local/bin"
	prepend_path "$HOME/.local/bin"
fi

# Add scripts and current folder to PATH
prepend_path "$CUSTOM_SCRIPTS"

export PATH

# Thousand separator in ls filesizes
# could also use ls -l --block-size="'1" as alias
export LS_BLOCK_SIZE="'1"

# Run-once definitions
export CUSTOM_RUNONCE_OK=0
export CUSTOM_RUNONCE_NOT_YET=10
export CUSTOM_RUNONCE_ALREADY_DID=20

# Wine Bottles
export WINEBOTTLEHOME="$HOME/.local/share/wineprefixes"

# Debian Development
export DEBFULLNAME="Rodrigo Silva"
export DEBEMAIL="linux@rodrigosilva.com"

# Locales
export LANG="en_US.utf8"
export LANGUAGE="en_US:en"
#export LC_NUMERIC="pt_BR.utf8" # qt4 (and maybe others) unfortunately use this
export LC_TIME="pt_BR.utf8"
export LC_MONETARY="pt_BR.utf8"
export LC_PAPER="pt_BR.utf8"
export LC_MEASUREMENT="pt_BR.utf8"

# if running bash (interactive login shell)
if [ -n "$BASH_VERSION" ]; then
	if [ -f "$CUSTOM_ROOT/bashrc" ] ; then
		. "$CUSTOM_ROOT/bashrc"
	fi
fi