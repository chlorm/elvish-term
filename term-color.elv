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

fn -base16 [int]{
  local:b16 = (base 16 $int)

  # 00 gets truncated to 0
  if (< (count $b16) 2) {
    b16 = '0'$b16
  }

  put $b16
}

# Converts decimal to hexadecimal RGB.
fn rgb-to-hex [rgb]{
  -validate-rgb $rgb

  put '#'(-base16 $rgb[r])(-base16 $rgb[g])(-base16 $rgb[b])
}

fn reset-x11 {
  print "\033]104\a"
}

fn -set-gnome-terminal [scheme]{
  profile = [(dconf list /org/gnome/terminal/legacy/profiles:/)]
  if (> (count $profile) 1) {
    fail "We don't have a way to differentiate gnome-terminal profiles."
  } else {
    profile = $profile[0]
  }

  try {
    dconf write \
      '/org/gnome/terminal/legacy/profiles:/'$profile'background-color' \
      "'rgb("$scheme[bg][r]','$scheme[bg][g]','$scheme[bg][b]")'"
  } except _ {
    fail 'dconf failed to set background-color'
  }
  try {
    dconf write \
      '/org/gnome/terminal/legacy/profiles:/'$profile'foreground-color' \
      "'rgb("$scheme[fg][r]','$scheme[fg][g]','$scheme[fg][b]")'"
  } except _ {
    fail 'dconf failed to set foreground-color'
  }
  local:palette = [ ]
  for local:i [(keys $scheme)] {
    if (has-value [bg fg] $i) {
      continue
    }
    palette = [
      $@palette
      "'rgb("$scheme[$i][r]','$scheme[$i][g]','$scheme[$i][b]")'"
    ]
  }
  try {
    dconf write \
      '/org/gnome/terminal/legacy/profiles:/'$profile'palette' \
      '['(joins ', ' $palette)']'
  } except _ {
    fail 'dconf failed to set palette'
  }
}

fn -x11-hex [hex]{
  put $hex[1:3]'/'$hex[3:5]'/'$hex[5:7]
}

fn -set-x11 [scheme]{
  print "\033]11;rgb:"(-x11-hex (rgb-to-hex $scheme[bg]))"\a"
  print "\033]10;rgb:"(-x11-hex (rgb-to-hex $scheme[fg]))"\a"
  for local:i [(keys $scheme)] {
    if (has-value [bg fg] $i) {
      continue
    }
    # X11 only supports hex
    print "\033]4;"$i";rgb:"(-x11-hex (rgb-to-hex $scheme[$i]))"\a"
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
  local:scheme-eval = [&]
  local:scheme-mapped = [ ]
  # Manually define keys to ensure they all exist
  for local:i [ (range 16 | each [a]{to-string $a}) bg fg ] {
    local:rgb = $scheme[$i]

    # Allow re-assigning values. Since we only accept RGB as a map,
    # any string is assumed to be a valid key.
    if (==s (kind-of $rgb) 'string') {
      scheme-mapped = [ $@scheme-mapped $i ]
      continue
    }

    -validate-rgb $rgb

    scheme-eval[$i]=$rgb
  }
  # Mapped assignments have to be processed after their targets have been eval'd
  for local:i $scheme-mapped {
    scheme-eval[$i]=$scheme-eval[$scheme[$i]]
  }

  put $scheme-eval
}

fn set [scheme]{
  # TODO: Attempt to automatically set DBUS_SESSION_BUS_ADDRESS to work even
  #       when displays are not connected.
  local:gnome-terminal = $false
  if (and (has-env DISPLAY) (has-external gnome-terminal) (has-external dconf)) {
    gnome-terminal = $true
  }

  local:scheme-eval = (-eval-color-scheme $scheme)
  -set-x11 $scheme-eval
  if $gnome-terminal {
    try {
      -set-gnome-terminal $scheme-eval
    } except _ {
      # Ignore errors
    }
  }
}
