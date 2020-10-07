# elvish-term-color

###### An [Elvish](https://elv.sh) module to define terminal colors.

```elvish
epm:install github.com/chlorm/elvish-term-color
use github.com/chlorm/elvish-term-color/term-color

monokai = [
  &0=(term-color:hex-to-rgb '#272822')
  &1=(term-color:hex-to-rgb '#f92672')
  &2=(term-color:hex-to-rgb '#a6e22e')
  &3=(term-color:hex-to-rgb '#e6db74')
  &4=(term-color:hex-to-rgb '#2196e8')
  &5=(term-color:hex-to-rgb '#ae81ff')
  &6=(term-color:hex-to-rgb '#66d9ef')
  &7=(term-color:hex-to-rgb '#f8f8f2')
  &8=(term-color:hex-to-rgb '#75715e')
  &9=(term-color:hex-to-rgb '#fd971f')
  &10=2
  &11=3
  &12=4
  &13=5
  &14=6
  &15=(term-color:hex-to-rgb '#f8f8f0')
  &bg=(term-color:hex-to-rgb '#282828')
  &fg=(term-color:hex-to-rgb '#f8f8f2')
]

term-color:set $monokai
```
