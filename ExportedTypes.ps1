class FILL_ME_IN {}
class __ : FILL_ME_IN {}

class KoanAttribute : System.Attribute {
    [uint32] $Position

    KoanAttribute($Position) {
        $this.Position = $Position
    }
}