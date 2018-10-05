class FILL_ME_IN {}
class __ : FILL_ME_IN {}

class KoanAttribute : System.Attribute {
    [uint32] $Position
    [String] $HelpURL
    [scriptblock] $HelpAction

    KoanAttribute($Position, $HelpURL, $HelpAction) {
        $this.Position = $Position
        $this.HelpURL = $HelpURL
        $this.HelpAction = $HelpAction
    }

    KoanAttribute($Position, $HelpURL) {
        $this.KoanAttribute($Position, $HelpURL)
    }
    
    KoanAttribute($Position) {
        $this.KoanAttribute($Position, $null, $null)
    }

    KoanAttribute() {
        $this.KoanAttribute([uint32]::MaxValue, $null, $null)
    }
}