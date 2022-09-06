use github.com/chlorm/elvish-stl/test
use ./rgb


test:pass { rgb:-validate-decimal-rgb [ &r=255 &g=255 &b=255 ]}
test:fail { rgb:-validate-decimal-rgb [ &r=255 &g=255 &b=256 ]}

test:assert {
    eq (rgb:hexstr-to-map '#EEEEEE') [ &r='EE' &g='EE' &b='EE' ]
}

test:assert {
    var h = (rgb:hexstr-to-map '#EEEEEE')
    eq (rgb:hex-to-dec $h) [ &r=238 &g=238 &b=238 ]
}

test:assert { ==s (rgb:-base16 238) 'ee' }

test:assert {
    eq (rgb:dec-to-hex [ &r=238 &g=238 &b=238 ]) [ &r='ee' &g='ee' &b='ee' ]
}

test:assert {
    == (rgb:get-luma [ &r=238 &g=23 &b=75 ]) 72.46340000000001
}
