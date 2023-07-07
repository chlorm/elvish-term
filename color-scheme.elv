# Copyright (c) 2018, 2020-2021, Cody Opel <codyopel@gmail.com>
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


use github.com/chlorm/elvish-stl/list
use github.com/chlorm/elvish-stl/map
use ./osc
use ./rgb


# https://gerrit.googlesource.com/gitiles/+/01abf45592fe7dc4a349f9c396016a13cfd241ca/resources/com/google/gitiles/static/prettify/prettify.css
var gitiles = [
  &light= [
    &0=(rgb:hex-to-dec (rgb:hexstr-to-map '#000000'))
    &1=(rgb:hex-to-dec (rgb:hexstr-to-map '#880000'))
    &2=(rgb:hex-to-dec (rgb:hexstr-to-map '#008800'))
    &3=(rgb:hex-to-dec (rgb:hexstr-to-map '#666600'))
    &4=(rgb:hex-to-dec (rgb:hexstr-to-map '#000088'))
    &5=(rgb:hex-to-dec (rgb:hexstr-to-map '#660066'))
    &6=(rgb:hex-to-dec (rgb:hexstr-to-map '#006666'))
    &7=(rgb:hex-to-dec (rgb:hexstr-to-map '#eeeeee'))
    &8=(rgb:hex-to-dec (rgb:hexstr-to-map '#888888'))
    &9=(rgb:hex-to-dec (rgb:hexstr-to-map '#660000'))
    &10=2
    &11=(rgb:hex-to-dec (rgb:hexstr-to-map '#444400'))
    &12=(rgb:hex-to-dec (rgb:hexstr-to-map '#000066'))
    &13=(rgb:hex-to-dec (rgb:hexstr-to-map '#440044'))
    &14=(rgb:hex-to-dec (rgb:hexstr-to-map '#004444'))
    &15=(rgb:hex-to-dec (rgb:hexstr-to-map '#eeeeee'))
    &bg=(rgb:hex-to-dec (rgb:hexstr-to-map '#FFFFFF'))
    &fg=(rgb:hex-to-dec (rgb:hexstr-to-map '#000000'))
  ]

  &dark= [
    &0=(rgb:hex-to-dec (rgb:hexstr-to-map '#000000'))
    &1=(rgb:hex-to-dec (rgb:hexstr-to-map '#ff6d6d'))
    &2=(rgb:hex-to-dec (rgb:hexstr-to-map '#6dff6d'))
    &3=(rgb:hex-to-dec (rgb:hexstr-to-map '#ffff85'))
    &4=(rgb:hex-to-dec (rgb:hexstr-to-map '#79abff'))
    &5=(rgb:hex-to-dec (rgb:hexstr-to-map '#ff85ff'))
    &6=(rgb:hex-to-dec (rgb:hexstr-to-map '#85ffff'))
    &7=(rgb:hex-to-dec (rgb:hexstr-to-map '#e8e6e3'))
    &8=(rgb:hex-to-dec (rgb:hexstr-to-map '#888888'))
    &9=(rgb:hex-to-dec (rgb:hexstr-to-map '#660000'))
    &10=2
    &11=(rgb:hex-to-dec (rgb:hexstr-to-map '#444400'))
    &12=4
    &13=(rgb:hex-to-dec (rgb:hexstr-to-map '#440044'))
    &14=(rgb:hex-to-dec (rgb:hexstr-to-map '#004444'))
    &15=(rgb:hex-to-dec (rgb:hexstr-to-map '#eeeeee'))
    &bg=(rgb:hex-to-dec (rgb:hexstr-to-map '#131516'))
    &fg=(rgb:hex-to-dec (rgb:hexstr-to-map '#e8e6e3'))
  ]
]

# Defines terminals colors used by ANSI 0-15 color codes.
# example_colors = [
#   &0=[ &r=39 &g=40 &b=34 ]
#   ...
#   &6=(hex-to-rgb '#66d9ef')
#   ...
#   &15=6
# ]
fn -eval-color-scheme {|colorScheme|
    var colorSchemeEval = [&]
    var colorSchemeMapped = [ ]
    # Manually define keys to ensure they all exist.
    for i [ (range 16 | each {|a| to-string $a }) 'bg' 'fg' ] {
        var rgb = $colorScheme[$i]

        # Allow re-assigning values. Since we only accept RGB as a map,
        # any string value is assumed to be a valid key.
        if (==s (kind-of $rgb) 'string') {
            set colorSchemeMapped = [ $@colorSchemeMapped $i ]
            continue
        }

        rgb:-validate-decimal-rgb $rgb

        set colorSchemeEval[$i] = $rgb
    }
    # Mapped assignments have to be processed after their targets have been
    # eval'd.
    for i $colorSchemeMapped {
        set colorSchemeEval[$i] = $colorSchemeEval[$colorScheme[$i]]
    }

    put $colorSchemeEval
}

fn set {|colorScheme|
    # FIXME: implement light/dark support
    set colorScheme = (-eval-color-scheme $colorScheme['dark'])

    osc:set-background-color $colorScheme['bg']
    osc:set-foreground-color $colorScheme['fg']

    for i [ (map:keys $colorScheme) ] {
        if (list:has [ 'bg' 'fg' ] $i) {
            continue
        }

        osc:set-base-color $i $colorScheme[$i]
    }
}
