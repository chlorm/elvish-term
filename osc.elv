# Copyright (c) 2018, 2020-2022, Cody Opel <cwopel@chlorm.net>
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


# https://invisible-island.net/xterm/ctlseqs/ctlseqs.txt


use github.com/chlorm/elvish-stl/re
use github.com/chlorm/elvish-term/ansi
use github.com/chlorm/elvish-term/rgb


# Terminfo represents hexidecimal RGB as 00/00/00.
fn -dec-to-ti-hex {|decRgbMap|
    var hexRgbMap = (rgb:dec-to-hex $decRgbMap)
    printf '%s/%s/%s' $hexRgbMap['r'] $hexRgbMap['g'] $hexRgbMap['b']
}

# TODO: Maybe support rgba, not sure if anything common returns this, but it exists.
fn -ti-hex-to-dec {|tiHexStr|
    var d = '([a-fA-F0-9]{2,4})'
    var parsedRgbList = (re:finds 'rgb\:'$d'/'$d'/'$d $tiHexStr)
    var decRgbMap = (
        rgb:hex-to-dec [
            &r=$parsedRgbList[0]
            &g=$parsedRgbList[1]
            &b=$parsedRgbList[2]
        ]
    )
    put $decRgbMap
}

fn -osc {|cmd|
    # This uses C0 control codes for portability.  Windows does not interpret
    # C1 control codes.
    printf "%s%s%s%s%s" ^
        $ansi:ESC ']' ^
        $cmd ^
        $ansi:ESC '\'
}

fn -set-color {|cmd decRgbMap|
    -osc (printf "%s;rgb:%s" $cmd (-dec-to-ti-hex $decRgbMap))
}

# Sends an escape sequence to a terminal and captures the terminals response.
fn -get-raw-terminal-osc-response {|osc|
    var response = $nil
    try {
        var t = (
            var sttySettings = (e:stty -g)
            try {
                e:stty -echo raw
                printf "\u001B]%s\u001B\\" $osc >/dev/tty
                read-upto '\' </dev/tty
            } finally {
                e:stty $sttySettings
            }
        )
        set response = $t
    } catch _ {
        fail
    }

    if (eq $response $nil) {
        fail
    }

    put $response
}

# Parses an OSC color string and returns an RGB map.
fn -get-color {|cmd|
    var raw = (-get-raw-terminal-osc-response (printf '%s;?' $cmd))
    var decRgbMap = (-ti-hex-to-dec $raw)
    put $decRgbMap
}

# 1
fn set-icon-name {|icon|
    -osc (printf '%s;%s' 1 $icon)
}

# 2
fn set-window-title {|title|
    -osc (printf '%s;%s' 2 $title)
}

# 4
fn set-base-color {|colorIndex decRgbMap|
    -set-color (printf '%s;%s' 4 $colorIndex) $decRgbMap
}
fn get-base-color {|colorIndex|
    -get-color (printf '%s;%s' 4 $colorIndex)
}

# 10
fn set-foreground-color {|decRgbMap|
    -set-color 10 $decRgbMap
}
fn get-foreground-color {
    -get-color 10
}

# 11
fn set-background-color {|decRgbMap|
    -set-color 11 $decRgbMap
}
fn get-background-color {
    -get-color 11
}

# 12
fn set-cursor-color {|decRgbMap|
    -set-color 12 $decRgbMap
}
fn get-cursor-color {
    -get-color 12
}

# 50
# FIXME: check correct syntax
fn set-font {|font|
    -osc (printf '%s;%s' 50 $font)
}

# TODO: 52

# 104
fn reset-base-colors {
    -osc 104
}

# 110
fn reset-forground-color {
    -osc 110
}

# 111
fn reset-background-color {
    -osc 111
}

# 112
fn reset-cursor-color {
    -osc 112
}
