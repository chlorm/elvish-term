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


use github.com/chlorm/elvish-stl/map


fn -validate-decimal-rgb {|decRgbMap|
    for i [ (map:keys $decRgbMap) ] {
        if (or (< $decRgbMap[$i] 0) (> $decRgbMap[$i] 255)) {
            var err = 'RGB decimal out of range: '$decRgbMap[$i]
            fail $err
        }
    }
}

fn hexstr-to-map {|hexStr|
    if (==s $hexStr[0..1] '#') {
        set hexStr = $hexStr[1..]
    }
    if (not (== (count $hexStr) 6)) {
        # FIXME: improve error
        fail 'Got a non-rgb string'
    }

    put [
        &r=$hexStr[0..2]
        &g=$hexStr[2..4]
        &b=$hexStr[4..6]
    ]
}

# Convert hexadecimal to decimal RGB.
fn hex-to-dec {|hexRgbMap|
    put [
        &r=(base 10 '0x'$hexRgbMap['r'])
        &g=(base 10 '0x'$hexRgbMap['g'])
        &b=(base 10 '0x'$hexRgbMap['b'])
    ]
}

fn -base16 {|int|
    var b16 = (base 16 $int)

    # 00 gets truncated to 0
    if (< (count $b16) 2) {
        set b16 = '0'$b16
    }

    put $b16
}

# Convert decimal to hexadecimal RGB.
fn dec-to-hex {|decRgbMap|
    put [
        &r=(-base16 $decRgbMap['r'])
        &g=(-base16 $decRgbMap['g'])
        &b=(-base16 $decRgbMap['b'])
    ]
}
