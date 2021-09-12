# Copyright (c) 2018, 2020-2021, Cody Opel <cwopel@chlorm.net>
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


use github.com/chlorm/elvish-term/ansi
use github.com/chlorm/elvish-term/rgb


fn reset {
    printf "%s%s104%s" ^
        $ansi:ESC ^
        $ansi:OSC ^
        $ansi:ST
}

# Terminfo represents hexidecimal RGB as 00/00/00.
fn -dec-to-ti-hex [decRgbMap]{
    var hexRgbMap = (rgb:dec-to-hex $decRgbMap)
    printf '%s/%s/%s' $hexRgbMap['r'] $hexRgbMap['g'] $hexRgbMap['b']
}

# See: terminfo(5) initialize_color/initc
fn init-color [colorIndex decRgbMap]{
    printf "%s%s4;%s;rgb:%s%s" ^
        $ansi:ESC ^
        $ansi:OSC ^
        $colorIndex ^
        (-dec-to-ti-hex $decRgbMap) ^
        $ansi:ST
}

fn -init-fb [fb decRgbMap]{
    printf "%s%s%s;rgb:%s%s" ^
        $ansi:ESC ^
        $ansi:OSC ^
        $fb ^
        (-dec-to-ti-hex $decRgbMap) ^
        $ansi:ST
}

fn init-background [decRgbMap]{
    -init-fb '11' $decRgbMap
}

fn init-foreground [decRgbMap]{
    -init-fb '10' $decRgbMap
}
