#!/bin/bash
#
# Copyright 2018 Niklas Jakobsson
#
# This file is part of Remanola.
#
# Remanola is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Remanola is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Remanola.  If not, see <http://www.gnu.org/licenses/>.

check_for_undef() {
	if grep -q UNDEFINED $1; then 
		echo "Found UNDEFINED tag in $1"
	fi
}

INSTALLBASE="/Library/Application Support/Propellerhead Software/Remote"

if [ ! -z $1 ];then
	INSTALLBASE=$1
fi

export CODECSDIR="$INSTALLBASE/Codecs/Lua Codecs/Remanola/"
export MAPSDIR="$INSTALLBASE/Maps/Remanola/"
OUTDIR="/tmp/remanola-out"

if [ ! -d "$CODECSDIR" ]; then
	mkdir -p "$CODECSDIR"
fi

if [ ! -d "$MAPSDIR" ]; then
	mkdir -p "$MAPSDIR"
fi

if [ ! -d "$OUTDIR" ]; then
	mkdir -p "$OUTDIR"
fi

./build_remotemap.py
check_for_undef "$OUTDIR/Launchpad-Mini.remotemap"
check_for_undef "$OUTDIR/Launchpad-Pro.remotemap"
./build_lua.py

# Mini
cp -r $OUTDIR/Launchpad-Mini.lua "$CODECSDIR"
cp -r Codecs/Lua\ Codecs/Remanola/Launchpad-Mini.luacodec "$CODECSDIR"
cp -r Codecs/Lua\ Codecs/Remanola/Launchpad-Mini.png "$CODECSDIR"
cp -r $OUTDIR/Launchpad-Mini.remotemap "$MAPSDIR"

# Pro
cp -r $OUTDIR/Launchpad-Pro.lua "$CODECSDIR"
cp -r Codecs/Lua\ Codecs/Remanola/Launchpad-Pro.luacodec "$CODECSDIR"
cp -r Codecs/Lua\ Codecs/Remanola/Launchpad-Pro.png "$CODECSDIR"
cp -r $OUTDIR/Launchpad-Pro.remotemap "$MAPSDIR"

cp COPYING "$CODECSDIR"
cp README.md "$CODECSDIR"
