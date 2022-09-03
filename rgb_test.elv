use github.com/chlorm/elvish-stl/test
use github.com/chlorm/elvish-term/rgb


test:assert { rgb:-validate-decimal-rgb [ &r=255 &g=255 &b=255 ]}
test:refute { rgb:-validate-decimal-rgb [ &r=255 &g=255 &b=256 ]}

test:assert-bool {
    eq (rgb:hexstr-to-map '#EEEEEE') [ &r='EE' &g='EE' &b='EE' ]
}

test:assert-bool {
    var h = (rgb:hexstr-to-map '#EEEEEE')
    eq (rgb:hex-to-dec $h) [ &r=238 &g=238 &b=238 ]
}

test:assert-bool { ==s (rgb:-base16 238) 'ee' }

test:assert-bool {
    eq (rgb:dec-to-hex [ &r=238 &g=238 &b=238 ]) [ &r='ee' &g='ee' &b='ee' ]
}

test:assert-bool {
    == (rgb:get-luma [ &r=238 &g=23 &b=75 ]) 72.46340000000001
}
