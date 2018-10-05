class FILL_ME_IN {}
class __ : FILL_ME_IN {}

class KoanAttribute : System.Attribute {
    [uint32] $Position
    [String] $HelpURL
    [String] $HelpPath
    [scriptblock] $HelpAction
    
    KoanAttribute($Position, $HelpURL, $HelpAction) {
        $this.Position = $Position
        $this.HelpURL = $HelpURL
        $this.HelpAction = $HelpAction
    }

    KoanAttribute($Position, $HelpURL) {
        $this.Position = $Position
        $this.HelpURL = $HelpUrl
    }

    KoanAttribute($Position) {
        $this.Position = $Position
        
    }

    KoanAttribute() {
        $this.Position = [uint32]::MaxValue
    }
}