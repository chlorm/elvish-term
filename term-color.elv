# Copyright (c) 2018, 2020, Cody Opel <cwopel@chlorm.net>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Methods for defining the colors used by ANSI 0-15 color codes.


use re
use str


fn -validate-rgb [x]{
    for i [ (keys $x) ] {
        if (or (< $x[$i] 0) (> $x[$i] 255)) {
            fail 'RGB decimal out of range'
        }
    }
}

# Converts hexadecimal to decimal RGB.
fn hex-to-rgb [x]{
    if (and (!=s $x[0..1] '#') (== (count $x) 7)) {
        fail 'Got a non-hex string'
    }

    put [
        &r=(base 10 '0x'$x[1..3])
        &g=(base 10 '0x'$x[3..5])
        &b=(base 10 '0x'$x[5..7])
    ]
}

fn -base16 [int]{
    var b16 = (base 16 $int)

    # 00 gets truncated to 0
    if (< (count $b16) 2) {
        set b16 = '0'$b16
    }

    put $b16
}

# Converts decimal to hexadecimal RGB.
fn rgb-to-hex [rgb]{
    -validate-rgb $rgb

    put '#'(-base16 $rgb['r'])(-base16 $rgb['g'])(-base16 $rgb['b'])
}

fn reset-terminfo {
    print "\033]104\a"
}

fn -set-gnome-terminal [scheme]{
    var profile = [ (e:dconf 'list' '/org/gnome/terminal/legacy/profiles:/') ]
    if (> (count $profile) 1) {
        fail "We don't have a way to differentiate gnome-terminal profiles."
    } else {
        set profile = $profile[0]
    }

    try {
        e:dconf 'write' \
            '/org/gnome/terminal/legacy/profiles:/'$profile'background-color' ^
            "'rgb("$scheme['bg']['r']','$scheme['bg']['g']','$scheme['bg']['b']")'"
    } except _ {
        fail 'dconf failed to set background-color'
    }
    try {
        e:dconf 'write' ^
            '/org/gnome/terminal/legacy/profiles:/'$profile'foreground-color' ^
            "'rgb("$scheme['fg']['r']','$scheme['fg']['g']','$scheme['fg']['b']")'"
    } except _ {
        fail 'dconf failed to set foreground-color'
    }
    var palette = [ ]
    for i [ (keys $scheme) ] {
        if (has-value [ 'bg' 'fg' ] $i) {
            continue
        }
        set palette = [
            $@palette
            "'rgb("$scheme[$i]['r']','$scheme[$i]['g']','$scheme[$i]['b']")'"
        ]
    }
    try {
        e:dconf 'write' ^
            '/org/gnome/terminal/legacy/profiles:/'$profile'palette' ^
            '['(str:join ', ' $palette)']'
    } except _ {
        fail 'dconf failed to set palette'
    }
}

fn -terminfo-hex [rgb]{
    var hex = (rgb-to-hex $rgb)
    put $hex[1..3]'/'$hex[3..5]'/'$hex[5..7]
}

# see: terminfo(5) initialize_color/initc
fn -set-terminfo [scheme]{
    # Fallback escape sequence
    var esc = "\033]4;0;rgb:00/00/00\a"
    try {
        # NOTE: `tput initc` seems to use the hex value of the nearest
        #        color in `tput colors` even when truecolor is supported.
        #        So we only use it to find the correct escape sequence.
        # FIXME: make sure this doesn't pass for terminals with a different
        #        pattern.
        set esc = (e:tput initc 0 0 0 0)
    } except _ { }

    var s = '0;rgb:00/00/00'
    print (re:replace '4;'$s '11;rgb:'(-terminfo-hex $scheme['bg']) $esc)
    print (re:replace '4;'$s '10;rgb:'(-terminfo-hex $scheme['fg']) $esc)

    for i [ (keys $scheme) ] {
        if (has-value [ 'bg' 'fg' ] $i) {
            continue
        }

        print (re:replace $s $i';rgb:'(-terminfo-hex $scheme[$i]) $esc)
    }
}

# Defines terminals colors used by ANSI 0-15 color codes.
# example_colors = [
#   &0=[ &r=39 &g=40 &b=34 ]
#   ...
#   &6=(hex-to-rgb '#66d9ef')
#   ...
#   &15=6
# ]
fn -eval-color-scheme [scheme]{
    var schemeEval = [&]
    var schemeMapped = [ ]
    # Manually define keys to ensure they all exist
    for i [ (range 16 | each [a]{to-string $a}) bg fg ] {
        var rgb = $scheme[$i]

        # Allow re-assigning values. Since we only accept RGB as a map,
        # any string is assumed to be a valid key.
        if (==s (kind-of $rgb) 'string') {
            set schemeMapped = [ $@schemeMapped $i ]
            continue
        }

        -validate-rgb $rgb

        set schemeEval[$i] = $rgb
    }
    # Mapped assignments have to be processed after their targets have been
    # eval'd
    for i $schemeMapped {
        set schemeEval[$i] = $schemeEval[$scheme[$i]]
    }

    put $schemeEval
}

fn set [scheme]{
    # TODO: Attempt to automatically set DBUS_SESSION_BUS_ADDRESS to work even
    #       when displays are not connected.
    var gnomeTerminal = $false
    if (and (has-env 'DISPLAY') ^
            (has-external 'gnome-terminal') ^
            (has-external 'dconf')) {
        set gnomeTerminal = $true
    }

    var schemeEval = (-eval-color-scheme $scheme)
    -set-terminfo $schemeEval
    if $gnomeTerminal {
        try {
            -set-gnome-terminal $schemeEval
        } except _ {
            # Ignore errors
        }
    }
}
