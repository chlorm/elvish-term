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


use github.com/chlorm/elvish-term/osc
use github.com/chlorm/elvish-term/rgb


# https://github.com/JesseLeite/an-old-hope-syntax-atom
fn an-old-hope {
  put [
    &0=(rgb:hex-to-dec (rgb:hexstr-to-map '#1c1d21'))
    &1=(rgb:hex-to-dec (rgb:hexstr-to-map '#eb3d54'))
    &2=(rgb:hex-to-dec (rgb:hexstr-to-map '#78bd65'))
    &3=(rgb:hex-to-dec (rgb:hexstr-to-map '#e5cd52'))
    &4=(rgb:hex-to-dec (rgb:hexstr-to-map '#377d97'))
    &5=(rgb:hex-to-dec (rgb:hexstr-to-map '#d169f1'))
    &6=(rgb:hex-to-dec (rgb:hexstr-to-map '#4fb4d8'))
    &7=(rgb:hex-to-dec (rgb:hexstr-to-map '#848794'))
    &8=(rgb:hex-to-dec (rgb:hexstr-to-map '#686b78'))
    &9=(rgb:hex-to-dec (rgb:hexstr-to-map '#ef7c2a'))
    &10=2
    &11=3
    &12=4
    &13=5
    &14=6
    &15=(rgb:hex-to-dec (rgb:hexstr-to-map '#cbcdd2'))
    &bg=0
    &fg=15
  ]
}

# https://github.com/primer/github-atom-light-syntax
fn github {
  put [
    &0=(rgb:hex-to-dec (rgb:hexstr-to-map '#ffffff'))
    &1=(rgb:hex-to-dec (rgb:hexstr-to-map '#D73A49'))
    &2=(rgb:hex-to-dec (rgb:hexstr-to-map '#795DA3'))
    &3=(rgb:hex-to-dec (rgb:hexstr-to-map '#24292e'))
    &4=(rgb:hex-to-dec (rgb:hexstr-to-map '#183691'))
    &5=(rgb:hex-to-dec (rgb:hexstr-to-map '#795da3'))
    &6=(rgb:hex-to-dec (rgb:hexstr-to-map '#005CC5'))
    &7=3
    &8=(rgb:hex-to-dec (rgb:hexstr-to-map '#6a737d'))
    &9=(rgb:hex-to-dec (rgb:hexstr-to-map '#e36209'))
    &10=(rgb:hex-to-dec (rgb:hexstr-to-map '#795da3'))
    &11=(rgb:hex-to-dec (rgb:hexstr-to-map '#183691'))
    &12=(rgb:hex-to-dec (rgb:hexstr-to-map '#0086b3'))
    &13=(rgb:hex-to-dec (rgb:hexstr-to-map '#c8c8fa'))
    &14=(rgb:hex-to-dec (rgb:hexstr-to-map '#0086b3'))
    &15=(rgb:hex-to-dec (rgb:hexstr-to-map '#24292e'))
    &bg=0
    &fg=15
  ]
}

# https://github.com/morhetz/gruvbox
fn gruvbox {
  put [
    &0=(rgb:hex-to-dec (rgb:hexstr-to-map '#282828'))
    &1=(rgb:hex-to-dec (rgb:hexstr-to-map '#cc241d'))
    &2=(rgb:hex-to-dec (rgb:hexstr-to-map '#98971a'))
    &3=(rgb:hex-to-dec (rgb:hexstr-to-map '#d79921'))
    &4=(rgb:hex-to-dec (rgb:hexstr-to-map '#458588'))
    &5=(rgb:hex-to-dec (rgb:hexstr-to-map '#b16286'))
    &6=(rgb:hex-to-dec (rgb:hexstr-to-map '#689d6a'))
    &7=(rgb:hex-to-dec (rgb:hexstr-to-map '#a89984'))
    &8=(rgb:hex-to-dec (rgb:hexstr-to-map '#928374'))
    &9=(rgb:hex-to-dec (rgb:hexstr-to-map '#fb4934'))
    &10=(rgb:hex-to-dec (rgb:hexstr-to-map '#b8bb26'))
    &11=(rgb:hex-to-dec (rgb:hexstr-to-map '#fabd2f'))
    &12=(rgb:hex-to-dec (rgb:hexstr-to-map '#83a598'))
    &13=(rgb:hex-to-dec (rgb:hexstr-to-map '#d3869b'))
    &14=(rgb:hex-to-dec (rgb:hexstr-to-map '#8ec07c'))
    &15=(rgb:hex-to-dec (rgb:hexstr-to-map '#ebdbb2'))
    &bg=0
    &fg=15
  ]
}

# http://www.monokai.nl/blog/2006/07/15/textmate-color-theme/
fn monokai {
  put [
    &0=(rgb:hex-to-dec (rgb:hexstr-to-map '#272822'))
    &1=(rgb:hex-to-dec (rgb:hexstr-to-map '#f92672'))
    &2=(rgb:hex-to-dec (rgb:hexstr-to-map '#a6e22e'))
    &3=(rgb:hex-to-dec (rgb:hexstr-to-map '#e6db74'))
    &4=(rgb:hex-to-dec (rgb:hexstr-to-map '#2196e8'))
    &5=(rgb:hex-to-dec (rgb:hexstr-to-map '#ae81ff'))
    &6=(rgb:hex-to-dec (rgb:hexstr-to-map '#66d9ef'))
    &7=(rgb:hex-to-dec (rgb:hexstr-to-map '#f8f8f2'))
    &8=(rgb:hex-to-dec (rgb:hexstr-to-map '#75715e'))
    &9=(rgb:hex-to-dec (rgb:hexstr-to-map '#fd971f'))
    &10=2
    &11=3
    &12=4
    &13=5
    &14=6
    &15=(rgb:hex-to-dec (rgb:hexstr-to-map '#f8f8f0'))
    &bg=(rgb:hex-to-dec (rgb:hexstr-to-map '#282828'))
    &fg=(rgb:hex-to-dec (rgb:hexstr-to-map '#f8f8f2'))
  ]
}


# Defines terminals colors used by ANSI 0-15 color codes.
# example_colors = [
#   &0=[ &r=39 &g=40 &b=34 ]
#   ...
#   &6=(hex-to-rgb '#66d9ef')
#   ...
#   &15=6
# ]
fn -eval-color-scheme [colorScheme]{
    var colorSchemeEval = [&]
    var colorSchemeMapped = [ ]
    # Manually define keys to ensure they all exist.
    for i [ (range 16 | each [a]{to-string $a}) 'bg' 'fg' ] {
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

    put $schemeEval
}

fn set [colorScheme]{
    set colorScheme = (-eval-color-scheme $colorScheme)

    osc:init-background $colorScheme['bg']
    osc:init-foreground $colorScheme['fg']

    for i [ (keys $colorScheme) ] {
        if (has-value [ 'bg' 'fg' ] $i) {
            continue
        }

        osc:init-color $i $colorScheme[$i]
    }
}
