#!/usr/bin/sh
# Copyright (C) 1999 - 2005 Red Hat, Inc. All rights reserved. This
# copyrighted material is made available to anyone wishing to use, modify,
# copy, or redistribute it subject to the terms and conditions of the
# GNU General Public License version 2.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Authors:
#	Mike A. Harris <mharris@redhat.com>

# Mandatorily source xinitrc-common, which is common code shared between the
# Xsession and xinitrc scripts which has been factored out to avoid duplication
. /etc/X11/xinit/xinitrc-common

# Configure sxhkd, urvxt and bspwm
sxhkd &
konsole &
exec bspwm


#
## Keyboard configuration: Temporary: use udev instead
#
setxkbmap -option caps:escape




