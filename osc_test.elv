use github.com/chlorm/elvish-term/osc
use github.com/chlorm/elvish-stl/test

test:assert {
    ==s (osc:-dec-to-ti-hex [ &r=238 &g=238 &b=238 ]) 'ee/ee/ee'
}

test:assert {
    eq (osc:-ti-hex-to-dec 'askldfrgb:EE/EE/EEasdfjkh') [ &r=238 &g=238 &b=238 ]
}
