class Blank {
    [string] ToString() {
        return $null
    }
    
    [bool] op_Equals([object] $other) {
        return $false
    }
}
