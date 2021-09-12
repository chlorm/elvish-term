# elvish-term

###### An [Elvish](https://elv.sh) module to providing terminal related functions and constants.

```elvish
epm:install github.com/chlorm/elvish-term
use github.com/chlorm/elvish-term/color-scheme

monokai = [
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

color-scheme:set (color-scheme:monokai)
```
