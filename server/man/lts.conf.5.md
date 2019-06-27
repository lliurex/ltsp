lts.conf 5 2018-12
==================

## NAME

lts.conf - Main configuration file for LTSP

## SYNOPSIS

Any line beginning with a '#' is considered a comment. Options are of the format:

VARIABLE=value


## DESCRIPTION

This file gets parsed when LTSP client starts up. The section defined
by [default] gets applied to all clients, unless there is a
specification for a particular client that overrides it. The
per-client specs are prefixed by [<mac address>]

You may also name an arbitrary section with a name, with settings
underneath that section. You may then inherit that section with the
LIKE variable. The Example section has an illustration of this.

boolean values are specified by 'Y,y,True,true' for true
and 'N,n,False,false' for false.


## GENERAL PARAMETERS

*CONFIGURE_FSTAB*
 boolean, default *True*

/etc/fstab is generated by boot scripts


*FSTAB_0...FSTAB_9*
 string, default *unset*

Complete lines to add to /etc/fstab, for example:

    FSTAB_1="server:/home /home   nfs  defaults,nolock 0  0"


*CRONTAB_01...CRONTAB_10*
 string, default *unset*

A crontab line to add for a thin client.


*DNS_SERVER*
 IP address, default *unset*

A valid IP for domain name server Used to build the client's
resolv.conf file. Not needed by default.


*SEARCH_DOMAIN*
 string, default *unset*

sets a valid search domain in the clients's resolv.conf file. Used to
build the resolv.conf file. Not needed by default.

Needed if DNS_SERVER is set


*HOSTNAME*
 string, default *unset*

This parameter sets the host name for the thin client, for situations
when if no DNS is available. A hostname is auto-generated if no
hostname is set.


*HOSTNAME_BASE*
 string, default *ltsp*

This parameter sets the base for the autogenerated host name for the
thin client.


*HOSTNAME_EXTRA*
 string, default *ip*

This parameter determines weather autogenerated host names are
appended with information based on the ip address or mac
address. Values are "ip" or "mac".


*NBD_SWAP*
 boolean, default *False*

Set this to True if you want to turn on NBD swap.

If unspecified, it's automatically enabled for thin clients with less
than 300 MB RAM and for fat clients with less than 800 MB RAM.


*NBD_SWAP_PORT*
 integer, default *10809*

The port on which NBD swapping will occur. An nbd-server export named
swap is normally used.


*NBD_SWAP_SERVER*
 IP address, default *SERVER*

The NBD swap server can exist on any server on the network that is
capable of handling it. You can specify the IP address of that
server. The default is whatever the value of SERVER set to.

*NBD_SWAP_THRESHOLD*
 integer, default *300*

Automatically enable NBD_SWAP if the client has less RAM than the
specified. For FAT clients, it defaults to 800.


*RM_SYSTEM_SERVICES*
 string, default *unset*

A space separated list of services that shouldn't start on the
clients even if they're installed, for example:

    RM_SYSTEM_SERVICES="apache2 dnsmasq mysql nbd-server nfs-kernel-server"


*RM_THIN_SYSTEM_SERVICES*
 string, default *unset*

Same as RM_SYSTEM_SERVICES, but it only affects thin clients.


*KEEP_SYSTEM_SERVICES*
 string, default *unset*

Some services are deleted by default when an LTSP client boots, either
to save RAM, or because they don't make sense for netbooted
machines. If you need some of them you can list them in
KEEP_SYSTEM_SERVICES, for example:

    KEEP_SYSTEM_SERVICES="acpid avahi-daemon bluetooth cups"


*SERVER*
 IP address, default *unset*

This is the server that is used for the XDM_SERVER, TELNET_HOST,
XFS_SERVER and SYSLOG_HOST, if any of those are not specified
explicitly. If you have one machine that is acting as the server for
everything, then you can just specify the address here and omit the
other server parameters. If this value is not set, it will be auto
detected as the machine that the thin client booted from.


*SYSLOG_HOST*
 IP address, default *unset*

If you want to send logging messages to a machine other than the
default server, then you can specify the machine here. If this
parameter is NOT specified, then it will use the SERVER parameter
described above.  Starting from LTSP 5.4.1 and on, this parameter must
be specified to enable remote logging.

You have to configure your server to accept remote logging as well.

*USE_LOCAL_SWAP*
 boolean, default *False*

If you have a hard drive installed in the thin client, with a valid
swap partition on it, this parameter will allow the thin client to
swap to the local hard drive.


*TIMEZONE*
 string, default *unset*

The timezone code for the thin client to use.

*TIMESERVER*
 IP address, default *unset*

The address of an NTP time server that the thin client can set it's
time from. If unset, the thin client just uses the BIOS time.


*SHUTDOWN_TIME*
 string, format hh:mm:ss in 24 hour format, default *unset*

Time at which thin client will automatically shut down.


*LTSP_FATCLIENT*
 boolean, default *unset*

Enable Fat Client support. It's automatically enabled if any sessions
exist in /usr/share/xsessions.


*FAT_RAM_THRESHOLD*
 integer, default *300*

Disable fat client support if less RAM is present.


## LOCAL DEVICES

*LOCALDEV*
 boolean, default *True*

This parameter enables local devices support, like CD's and USB
sticks. Users plugging them in should see them on the desktop, after
they've been allowed to access the FUSE subsystem on the server. Check
your distribution's docs to see how this is done on your distribution.


*LOCALDEV_DENY_CD*
 boolean, default *False*

This parameter disables local device support for CD and DVD-rom
devices.


*LOCALDEV_DENY_FLOPPY*
 boolean, default *False*

This parameter disables local device support for floppy devices.


*LOCALDEV_DENY_INTERNAL_DISKS*
 boolean, default *True*

This parameter disables local device support for internal ATA and SCSI
hard disk devices.


*LOCALDEV_DENY_USB*
 boolean, default *False*

This parameter disables local device support for USB devices.


*LOCALDEV_DENY*
 string, default *unset*

This parameter disables local device support for devices matching
certain patterns. Values are specified as a comma-separated list of
sysfs attributes, which can be obtained by using udevadm info (or
udevinfo). for example:

    udevadm info -q env -n /dev/hda
    ID_TYPE=disk
    ID_BUS=ata

should return a list of the attributes relevant to /dev/hda. to
exclude this disk and disks like it using LOCALDEV_DENY:
LOCALDEV_DENY="ID_BUS:ata+ID_TYPE:disk" would match devices that were
on the ata bus that were disks.


## SCRIPTS AND MODULES

*MODULE_01...MODULE_10*
 string, default *unset*

Up to 10 kernel modules can be loaded by using these configuration
entries. The entire command line that you would use when running
insmod can be specified here. For example:

    MODULE_01 = uart401.o
    MODULE_02 = "sb.o io=0x220 irq=5 dma=1"
    MODULE_03 = opl3.o

If the value of this parameter is an absolute path name, then insmod
will be used to load the module.  Otherwise, modprobe will be used.

In normal circumstances, you shouldn't need to specify anything here,
as most hardware will be auto-detected.


*RCFILE_01...RCFILE_10*
 string, default *unset*

Commands to be executed from /etc/rc.local when the client boots.


## PRINTER PARAMETERS

*PRINTER_0_DEVICE*
 string, default *unset*

The device name of the printer. Valid device names such as /dev/lp0, or /dev/usb/lp0 are allowed.


*PRINTER_0_PORT*
 integer, default 9100

The TCP/IP Port number to use for the print server.


*PRINTER_0_TYPE*
 string, default *unset*

Can either be set to P (for parallel), U (for USB) or S (for
serial). Autodetected in most cases (except for serial).


*PRINTER_0_WRITE_ONLY*
 boolean, default *False*

Some parallel printers may need this set in order for the thin client
to communicate to them properly. If you have problems with a parallel
printer only printing part of the print job, try setting this to True.


*PRINTER_0_SPEED*
 integer, default *9600*

Should be set to the baud rate of the printer (serial printers only).


*PRINTER_0_FLOWCTRL*
 string, default *unset*

Should be set to the flow control desired for the printer (serial
printers only).


*PRINTER_0_PARITY*
 boolean, default *False*

Specifies whether parity should be enabled for the printer (serial
printers only).


*PRINTER_0_DATABITS*
 integer, default 8

Specifies how many data bits for the printer (serial printers only).


*PRINTER_0_OPTIONS*
 string, default *unset*

Specifies specific options for the printer (serial printers only).


*LDM_PRINTER_LIST*
 string, default *unset*

Comma separated list of printers that will be displayed for that thin
client (requires patched cups, included in Debian and Ubuntu).


*LDM_PRINTER_DEFAULT*
 string, default *unset*

Default printer for the thin client.


*SCANNER*
 boolean, default *unset*

This parameter enables scanners for the thin client.


## KEYBOARD PARAMETERS

*CONSOLE_KEYMAP*
 string, default *en*

A valid console keymap. Allows you to specify a valid console keymap
for TELNET_HOST sessions.


*XKBLAYOUT*
 string, default *unset*

A valid xkb layout. Consult the X.org documentation for valid
settings.


*XKBMODEL*
 string, default *unset*

A valid xkb model. Consult the X.org documentation for valid settings.


*XKBVARIANT*
 string, default *unset*

A valid xkb variant. Consult the X.org documentation for valid
settings.


*XKBRULES*
 string, default *unset*

A valid xkb rules specifier. Consult the X.org documentation for valid
settings.


*XKBOPTIONS*
 string, default *unset*

A valid xkb options specifier. Consult the X.org documentation for
valid settings.


## TOUCHSCREEN PARAMETERS

*USE_TOUCH*
 boolean, default *unset*

Enable touchscreen.

    X_TOUCH_DEVICE     Path to device       /dev/ttyS0    set device for touchscreen
    X_TOUCH_DRIVER     Touchscreen driver   elographics   set driver for touchscreen
    X_TOUCH_MAXX       integer              3588          Xmax
    X_TOUCH_MAXY       integer              3526          Ymax
    X_TOUCH_MINX       integer              433           Xmin
    X_TOUCH_MINY       integer              569           Ymin
    X_TOUCH_UNDELAY    integer              10            Untouch delay
    X_TOUCH_RTPDELAY   integer              10            Repeat touch delay


## SOUND AND VOLUME CONTROL PARAMETERS

These parameters allow you to control the volume on the thin client.

*SOUND*
 boolean, default *True*

This parameter enables sound for the thin client.

*SOUND_DAEMON*
 string, default *pulse*

This parameter sets which sound daemon to use on the thin
client. Values are esd, nasd, and pulse (default).

*VOLUME*
 integer, default *90*

This represents an integer percentage of the volume, ranging from 0 to
100%.

*HEADPHONE_VOLUME*
 integer, default *unset*

This represents an integer percentage of the headphone volume, ranging
from 0 to 100%.

*PCM_VOLUME*
 integer, default *unset*

This represents an integer percentage of the PCM volume, ranging from
0 to 100%.

*CD_VOLUME*
 integer, default *unset*

This represents an integer percentage of the CD input volume, ranging
from 0 to 100%.

*FRONT_VOLUME*
 integer, default *unset*

This represents an integer percentage of the front speaker volume,
ranging from 0 to 100%.

*MIC_VOLUME*
 integer, default *unset*

This represents an integer percentage of the microphone input volume,
ranging from 0 to 100%.


## XORG PARAMETERS

These parameters affect how Xorg behaves.

*USE_XFS*
 boolean, default *False*

Instructs the thin client to look at the XFS_SERVER option, and use
XFS for serving fonts.

*XFS_SERVER*
 IP address, default *unset*

If you are using an X Font Server to serve fonts, then you can use
this entry to specify the IP address of the host that is acting as the
font server. If this is not specified, it will use the default server,
which is specified with the SERVER entry described above.

*CONFIGURE_X*
 boolean, default *False*

If you want to be able to configure the individual settings of the X
configuration file, without having the X automatically configure the
graphics card for you, you must enable this option. By default this
option is turned off. To turn it on do:

    CONFIGURE_X = True

You don't need this option just for keyboard and mouse settings. It
corresponds to the graphic card and monitor options only.

*X_CONF*
 string, default *unset*

If you want to create your own complete X.org config file, you can do
so and place it in the /opt/ltsp/<arch>/etc/X11 directory. Then,
whatever you decide to call it needs to be entered as a value for this
configuration variable. For example: X_CONF =
/etc/X11/my-custom-xorg.conf Note that for the thin client, you
reference it from /etc/X11.

*X_RAMPERC*
 integer, default 100

Percentage of RAM for X server. Some programs allocate a large amount
of ram in the X.org server running on your thin client. Programs like
Firefox and Evince can use up so much ram, that they eventually
exhaust all your physical ram, and NBD swap, causing your thin client
to crash. If you find your clients being booted back to a login
prompt, or freezing up when viewing certain PDF's or web pages, this
may be the problem.

The X_RAMPERC variable stands for X RAM PERCent, and is a number
between 0 and 100 that specifies how much of the free space on your
thin client X.org is allowed to consume. You'll generally want to set
it at something lower than 100 percent, if you're having
problems. Experimentation has shown a value between 80 and 90 will
usually keep the terminal alive. What will then happen is the program
consuming the memory will die, as opposed to the thin client
itself. If you're having unexplained terminal problems, specifying:

    X_RAMPERC = 80

in your lts.conf file may improve things.

*X_VIRTUAL*
 string, default *unset*

If you want to have a virtual screen which is larger than the physical
screen on your thin client, you would configure that by providing a
 string of the form "width height" in this parameter, similar to the
xorg.conf format.

*XDM_SERVER*
 IP address, default *unset*

If you're using the older startx screen script, and need to specify a
different XDMCP server, then you can specify the server here. If this
parameter is NOT specified, then it will use the SERVER parameter
described above.

*XSERVER*
 string, default *unset*

You can use this parameter to override which X server the thin client
will run. For PCI and AGP video cards, this parameter should not be
required. The thin client should normally be able to auto-detect the
card.

If, for some reason you do need to manually set it, here are some valid values:

ark, ati, atimisc, chips, cirrus_alpine cirrus, cirrus_laguna, cyrix,
dummy, fbdev fglrx, glint, i128, i740, i810, imstt, mga, neomagic,
newport, nsc, nv, r128, radeon, rendition, riva128, s3, s3virge,
savage, siliconmotion, sis, sisusb, tdfx, tga, trident, tseng, v4l,
vesa, vga, via, vmware, voodoo

*X_MOUSE_DEVICE*
 string, default *unset*

This is the device node that the mouse is connected to. If it is a
serial mouse, this would be a serial port, such as /dev/ttyS0 or
/dev/ttyS1. This is not needed for PS/2 or USB mice, as they are
auto-detected.

*X_MOUSE_PROTOCOL*
 string, default *unset*

Should be auto-detected. However, valid entries include:

sunkbd, lkkbd, vsxxxaa, spaceorb, spaceball, magellan, warrior,
stinger, mousesystems, sunmouse, microsoft, mshack, mouseman,
intellimouse, mmwheel, iforce, h3600ts, stowawaykbd, ps2serkbd,
twiddler, twiddlerjoy

*X_MOUSE_EMULATE3BTN*
 boolean, default *unset*

Normally unset, may need to be set to Y for certain 2 button mice.

*X_NUMLOCK*
 boolean, default *False*

If this variable is set to True, then the numlock key will be
defaulted to on when the terminal boots. Note that the numlockx
command must be installed in the chroot for this to work.

*X_COLOR_DEPTH*
 Integer, default *unset*

This is the number of bits to use for the colour depth. Possible
values are 8, 16, 24 and 32. 8 bits will give 256 colours, 16 will
give 65536 colours, 24 will give 16 million colours and 32 bits will
give 4.2 billion colours! Not all X servers support all of these
values. The default for thin clients is 16 in order to minimize
network bandwidth, while for fat clients the X server default is used.

*X_SMART_COLOR_DEPTH*
 boolean, default *True*

If set, thin clients no longer default to 16 bit colour depth but use
the X server default instead.

*X_HORZSYNC*
min-max, default *unset*

This sets the X.org HorizSync configuration parameter. This should be
auto-detected for your monitor, however, if you want to force a lower
resolution, use this parameter to do so.

*X_VERTREFRESH*
min-max, default *unset*

This sets the X.org VertRefresh configuration parameter. This should
be auto-detected for your monitor. If you need to force a lower
resolution, use this parameter to do so.

*X_VIDEO_RAM*
 string, default *unset*

This sets the X.org VideoRam configuration parameter. The setting is
in kilobytes. This should be auto-detected for your monitor. If you
need to force a different video ram setting, use this parameter to do
so.

*X_OPTION_01...X_OPTION_12*
 string, default *unset*

A valid Device option. This allows you to specify Option settings in
the xorg.conf file, to add options to the video driver. A common use
for this will be to test turning off acceleration in your driver, if
you're having trouble. An example usage would be:

    X_OPTION_01 = "\"NoAccel\"" X_OPTION_02 = "\"AnotherOption\" \"True\""

You probably won't need these except in special circumstances.

*X_MONITOR_OPTION_01...X_MONITOR_OPTION_10*
 string, default *unset*

A valid Monitor option, that would normally be used in an xorg.conf
file.

*X_MODE_0...X_MODE_2*
 string, default *unset*

These set the X.org ModeLine configuration. For example, if your thin
client comes up in a higher resolution than what you want, say,
1280x1024, specifying:

    X_MODE_0 = 1024x768

should get your desired resolution on startup.

X_MODE\_* require XRANDR_DISABLE=True to work. For drivers that
support XRANDR, the XRANDR_MODE\_* variabled are preferred. See the
XRANDR section.

*X_BLANKING*
 integer, default *unset*

When set, X_BLANKING will cause DPMS standby to activate after the
number of seconds provided. If the monitor does not support DPMS,
then the blanking screensaver will activate. If X_BLANKING is set to
0, the monitor will remain on indefinitely. NOTE: This does not apply
to the xdmcp or startx screen script. Also, server-side Xclients such
as power managers and screensavers may override this setting.


## XRANDR OPTIONS

*XRANDR_COMMAND_0...XRANDR_COMMAND_9*
 string, default *unset*

Full xrandr command to run when X starts. They're useful to define and
add custom modes, for example:

    XRANDR_COMMAND_0="xrandr --newmode 1024x600 49.00 1024 1072 1168 1312 600 603 613 624 -hsync +vsync"
    XRANDR_COMMAND_1="xrandr --addmode VGA1 1024x600"
    XRANDR_COMMAND_2="xrandr --output VGA1 --mode 1024x600"

You can use cvt to find the correct timings for new modes.

*XRANDR_DISABLE*
 boolean, default *False*

Disables XRANDR output handling so that the older X_MODE_0 way of
setting resolution works. This is useful on older Xorg drivers that
don't support XRANDR.

*XRANDR_OUTPUT_0...XRANDR_OUTPUT_8*
 string, default *unset*

Define xrandr output - can also be used for multihead positioning

*XRANDR_MODE_0...XRANDR_MODE_8*
 string, default *unset*

Valid video mode resolution. Sets mode for corresponding output.

*XRANDR_NEWMODE_0...XRANDR_NEWMODE_8*
 string, default *unset*

Specifies a valid modeline for a corresponding output.

*XRANDR_RATE_0...XRANDR_RATE_8*
 string, default *unset*

Sets refresh rate for the corresponding output.

*XRANDR_DPI_0...XRANDR_DPI_8*
 string, default *unset*

Sets the DPI for the corresponding output.

*XRANDR_ROTATE_0...XRANDR_ROTATE_8*
 string, default *unset*

Sets the rotation for the corresponding output.

*XRANDR_REFLECT_0...XRANDR_REFLECT_8*
 string, default *unset*

Sets the reflection for the corresponding output.

*XRANDR_SIZE_0...XRANDR_SIZE_8*
 string, default *unset*

Sets the resolution for the corresponding output (for xrandr <1.2).

*XRANDR_ORIENTATION_0...XRANDR_ORIENTATION_8*
 string, default *unset*

Sets the orientation for the corresponding output (for xrandr <1.2).


## SCREEN SCRIPTS

*SCREEN_01...SCREEN_12*
 string, default *ldm*

Up to 12 screen scripts can be specified for a thin client. This will
give you up to 12 sessions on the thin client, each accessible by
pressing the Ctrl-Alt-F1 through Ctrl-Alt-F12 keys.

Currently, possible values include: kiosk, ldm, menu, rdesktop
(deprecated), shell, ssh, startx (deprecated), telnet, xdmcp,
xfreerdp, xterm

Look in the $CHROOT/usr/share/ltsp/screen.d directory for more
scripts, or write your own, and put them there.

*TELNET_HOST*
 IP address, default *unset*

If the thin client is setup to have a character based interface, then
the value of this parameter will be used as the host to telnet
into. If this value is NOT set, then it will use the value of SERVER
above.


## LDM OPTIONS

*LDM_AUTOLOGIN*
 boolean, default *False*

This option allows the thin client to login automatically without the
need for a username and password. To set it set:

    LDM_AUTOLOGIN = True

for the corresponding thin client. This will attempt to log in the
thin client with username = hostname and password = hostname. You can
also set a user and password with LDM_USERNAME and LDM_PASSWORD
variables.

*LDM_DEBUG_TERMINAL*
 boolean, default *False*

Opens a local terminal after login for debugging purposes.

*LDM_DIRECTX*
 boolean, default *False*

This is arguably the most important LDM option, as it allows you to
turn off the encrypted X tunnel via SSH, and instead run a less
secure, but much faster unencrypted tunnel. Users who have slower
thin clients will want to set this to True. It is set to True by
default in Fedora.

*LDM_GUESTLOGIN*
 boolean, default *False*

This option places a GUEST LOGIN button underneath the entry field
for username and password. To set it set:

    LDM_GUESTLOGIN = True

for the corresponding thin client. You can also set a user and
password with:

    LDM_USERNAME = John

and:

    LDM_PASSWORD = secret

although not setting these will default to the hostname of the thin client.

*LDM_GUEST_SERVER*
 string, default *unset*

This is a space-separated list of available servers where guest
logins are available. The first server in the list will be the
default guest login server unless the user selects another from the
preferences menu at login time.

*LDM_USER_ALLOW*
 string, default *unset*

This option allows you to give access to certain thin clients based
on the username set in /etc/passwd. For example, thin client A should
only be used by Jane, Bob, and Fred, while thin client B is to be
used by Harry only. By adding these options to the corresponding mac
addresses you allow or deny access to the thin clients in
question. Example:
    
    [thin:client:A:mac:address]
    LDM_USER_ALLOW = Jane,Bob,Fred
    [thin:client:B:mac:adddress]
    LDM_USER_ALLOW = Harry
    
*LDM_LOGIN_TIMEOUT*
 integer

This lets LDM automatically login after the set amount of time in
seconds. If you specify this option, then do not specify
LDM_AUTOLOGIN. Use it in this format:

    [thin:client:mac:address]
    LDM_LOGIN_TIMEOUT = 25

Note that you will need to also set LDM_GUESTLOGIN=True for LDM_LOGIN_TIMEOUT to be useful.

*LDM_USERNAME*
 string, default *unset*

This is the username that LDM will use for autologin.

*LDM_PASSWORD*
 string, default *unset*

This is the password that LDM will use for autologin.

*LDM_SYSLOG*
 boolean, default *False*

Normally, LDM logs to a simple file on the thin client, namely
/var/log/ldm.log. This has the advantage of being fast, but the
disadvantage of being hard to read for the administrator in the event
of a problem, as the administrator must either spawn a shell screen
session, or enable root login in tty1. By setting this option to
"True", you can log up to the server if you've enabled your server's
syslog for remote logging.

*LDM_SERVER*
 string, default *unset*

This is a space-separated list of available servers for LDM to log
into. The first server in the list will be the default server unless
the user selects another from the preferences menu at login time.

*LDM_LANGUAGE*
 string, default *unset*

This allows the system administrator to override the default locale
settings on the server by setting the environment variables LANG,
LANGUAGE and LC_ALL at login.

Use the LANG variable to set the default locale for LDM's user
interface.

*LDM_FORCE_LANGUAGE*
 string, default *unset*

Same as LDM_LANGUAGE, but it overrides any previously user selected
language and it even hides the LDM language selection menu.

*LDM_SSHOPTIONS*
 string, default *unset*

Allows you to specify custom options to the ssh sessions started between LDM and the server.

*SSH_OVERRIDE_PORT*
 integer, default *unset*

If you run your ssh server different from the default, you may set the
port the thin client will use with this parameter.

*SSH_FOLLOW_SYMLINKS*
 boolean, default *unset*

Causes sshfs mounted filesystems for local applications to follow
symlinks. By default it's false for symlinks under $HOME and true for
any LOCAL_APPS_EXTRAMOUNTS.

*LDM_SESSION*
 string, default *unset*

Used to chose the default session on the server, for example:

    LDM_SESSION="gnome-fallback"

You can find the list of services that your server provides in /usr/share/xsessions.

If the user has selected a specific session though LDM or another DM
in the past, that's stored in his ~/.dmrc, and it overrides the
default session.

*LDM_FORCE_SESSION*
 string, default *unset*

Same as LDM_SESSION, but it overrides any previously selected
sessions by the user and it even hides the LDM session selection
menu.

*LDM_XSESSION*
 string, default *Xsession*

Allows you to specify custom script on the server for LDM to run,
rather than the server's standard script for starting an X session
(usually Xsession).

*LDM_LIMIT_ONE_SESSION*
 boolean, default *False*

Only allow a given user to log into one thin-client at a time.

*LDM_LIMIT_ONE_SESSION_PROMPT*
 boolean, default *False*

Prompt to kill processes of other logins when other logins are
detected. Requires LDM_LIMIT_ONE_SESSION to be set.

*LDM_THEME*
 string, default *unset*

Specify the name of the LDM theme. It can reference a directory in
/usr/share/ldm/themes, or be specified as a full path to the theme
dir (both relative to the chroot).

To use the theme in /opt/ltsp/i386/usr/share/ldm/themes/MYTHEME, you'd specify:

    LDM_THEME=MYTHEME

In your lts.conf file.

Alternately, To use the theme in /opt/ltsp/i386/etc/MYTHEME, you'd specify:

    LDM_THEME=/etc/MYTHEME

In your lts.conf file.

*LDM_PASSWORD_HASH*
 boolean, default *False*

When set to True, this will create a proper shadow entry on the
client, allowing for screen locking, and other things which require
authentication to work. Note, this allows you to change your password
locally, or possibly other actions such as sudo, but these changes
are only temporary and will not persist on reboot.

versions: LDM 2.2.14+, LTSP 5.5.2+


## LOCAL APPLICATIONS

*LOCAL_APPS*
 boolean, default *True*

Enables support for running local apps on the thin client.

*LOCAL_APPS_EXTRAMOUNTS*
 string, default *unset*

This parameter enables extra mount points to be mounted on the thin
client with sshfs. This require a commas separated list of directory.

*LOCAL_APPS_MENU*
 boolean, default *False*

Enables overriding of menu items from remote (server)
applications. If this is set to True, local applications in the users
menu will be used instead of the applications on the server.

*LOCAL_APPS_MENU_ITEMS*
 string, default *unset*

This item should contain a comma separated list of application names
as they appear on their .desktop files.

*LOCAL_APPS_WHITELIST*
 string, default *unset*

Used to allow only specified space-separated commands to be run as
local apps, allow all is default if unset. Full-paths are required
for each command. No spaces in the names are allowed.


## EXAMPLES

K12LTSP

    # Global defaults for all clients
    # if you refer to the local server, just use the
    # "server" keyword as value
    # see lts_parameters.txt for valid values
    ################
    [default]
    #X_COLOR_DEPTH=16
    LOCALDEV=True
    SOUND=True
    NBD_SWAP=True
    SYSLOG_HOST=server
    #XKBLAYOUT=de
    SCREEN_02=shell
    SCREEN_03=shell
    SCREEN_04=shell
    SCREEN_05=shell
    SCREEN_06=shell
    SCREEN_07=ldm
    # LDM_DIRECTX=True allows greater scalability and performance
    # Turn this off if you want greater security instead.
    LDM_DIRECTX=True
    # LDM_SYSLOG=True writes to server's syslog
    LDM_SYSLOG=True

    ################
    # A setting stanza for an old machine
    ################
    [oldmachine]
    X_COLOR_DEPTH=8
    X_MODE_0=800x600

    ################
    # Example of the LIKE variable
    ################
    [01:23:DE:AD:BE:EF]
    LIKE=oldmachine
    SCREEN_02=shell

    ################
    #[MAC ADDRESS]: Per thin client settings
    ################
    [00:11:25:84:CE:BA]
    XSERVER = vesa
    X_MOUSE_DEVICE=/dev/ttyS0
    X_MOUSE_PROTOCOL=intellimouse

    ###############
    # A Thin Client Print server
    # (switch off X by pointing tty7 to shell,
    # to save resources)
    ###############
    [00:11:25:93:CF:00]
    PRINTER_0_DEVICE=/dev/usb/lp0
    SCREEN_07=shell

    ###############
    # A workstation that executes a specific
    # command after login
    ###############
    [00:11:25:93:CF:02]
    LDM_SESSION=/usr/bin/myloginscript

## NOTES

When using NBD to export the client image (the default in Ubuntu), lts.conf is fetched via TFTP, so lts.conf
should go in the TFTP directory, for example dvar/lib/tftpboot/ltsp/i386/lts.conf. For distributions that use
NFS, the traditional lts.conf place is /opt/ltsp/i386/etc/lts.conf, although in recent versions it can be
fetched via TFTP as well.