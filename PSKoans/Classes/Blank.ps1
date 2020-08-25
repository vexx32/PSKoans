class Blank {
    [string] ToString() {
        return $null
    }

    [bool] Equals([object] $other) {
        return $false
    }

    static [bool] op_Equality([Blank] $self, [object] $other) {
        return $false
    }

    static [bool] op_Inequality([Blank] $self, [object] $other) {
        return $true
    }

    static [bool] op_Explicit([Blank] $Instance) {
        return $false
    }

    static [bool] op_Implicit([Blank] $Instance) {
        return $false
    }
}
