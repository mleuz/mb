# --------------------------------
function switchtest {
    [CmdletBinding()]
    Param (
        [switch]$off       
    )
    # === ohne switch param ===
    $test = "ist nicht gesetzt"
    # === mit switch param ===
    if ($off.IsPresent) {
        $test = "ist gesetzt"
    }
    # === Return ===
    return $test
}

Switchtest
Switchtest -off
# test test
# test 02
 