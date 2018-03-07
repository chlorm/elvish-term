# Copyright (c) 2018, Cody Opel <codyopel@gmail.com>
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

fn -validate-rgb [x]{
  for local:i [(keys $x)] {
    if (or (< $x[$i] 0) (> $x[$i] 255)) {
      fail 'Invalid RGB decimal range'
    }
  }
}

# Converts hexadecimal to decimal RGB.
fn hex-to-rgb [x]{
  if (and (!=s $x[0:1] '#') (== (count $x) 7)) {
    fail 'Got a non-hex string'
  }

  put [
    &r=(base 10 '0x'$x[1:3])
    &g=(base 10 '0x'$x[3:5])
    &b=(base 10 '0x'$x[5:7])
  ]
}

# Converts decimal to hexadecimal RGB.
fn rgb-to-hex [x]{
  -validate-rgb $x

  put '#'(base 16 $x[r])(base 16 $x[g])(base 16 $x[b])
}

fn set-gnome-terminal [x]{
  profile = (dconf list /org/gnome/terminal/legacy/profiles:/)
  if (==s (kind-of $profile) 'list') {
    # We don't have a way to differentiate profiles.
    return
  }

  local:palette = ''
  # Make sure that we iterate over the list in order because gnome-terminal's
  # palette is order dependent.
  for local:i [(range 0 16)] {
    local:rgb = $x[$i]

    # Allow reassigning values
    if (and (==s (kind-of $rgb) 'string')) {
      rgb = $x[$rgb]
    }

    palette = [ $@palette "'rgb("$rgb[r]','$rgb[g]','$rgb[b]")'" ]
  }

  local:bg = $x[0]
  try {
    dconf write \
      '/org/gnome/terminal/legacy/profiles:/'$profile'background-color' \
      "'rgb("$bg[r]','$bg[g]','$bg[b]")'"
  } except {
    fail 'dconf failed to set background-color'
  }
  local:fg = $x[15]
  try {
    dconf write \
      '/org/gnome/terminal/legacy/profiles:/'$profile'foreground-color' \
      "'rgb("$fg[r]','$fg[g]','$fg[b]")'"
  } except {
    fail 'dconf failed to set foreground-color'
  }
  try {
    dconf write \
      '/org/gnome/terminal/legacy/profiles:/'$profile'palette' \
      '['(joins ', ' $palette)']'
  } except {
    fail 'dconf failed to set palette'
  }
}

fn set-x11 [x]{
  for local:i [(keys $x)] {
    if (or (< $i 0) (> $i 15)) {
      fail 'Invalid ANSI color code'
    }

    local:rgb = $x[$i]

    # Allow reassigning values
    if (and (==s (kind-of $rgb) 'string')) {
      rgb = $x[$rgb]
    }

    -validate-rgb $rgb

    # X11 only supports hex
    local:hex = (rgb-to-hex $rgb)

    print "\x1b]4;"$i";rgb:"$hex[1:3]"/"$hex[3:5]"/"$hex[5:7]"\x1b\\"
  }
}

fn reset-x11 {
  print "\x1b]104\a"
}

# Defines terminals colors used by ANSI 0-15 color codes.
# example_colors = [
#   &0=[ &r=39 &g=40 &b=34 ]
#   ...
#   &6=(hex-to-rgb '#66d9ef')
#   ...
#   &15=6
# ]
fn set [x]{
  if (!= (count $x) 16) {
    fail 'invalid'
  }

  set-x11 $x

  # TODO: Attempt to automatically set DBUS_SESSION_BUS_ADDRESS to work even
#         when displays are not connected.
  if (and (has-env DISPLAY) (has-external dconf)) {
    set-gnome-terminal $x
  }
}
