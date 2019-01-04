# Only attempt to load dummy types if they're not already present in the session

switch ($false) {
    { 'FillerType' -as [type] } {
        class FillerType {}
    }
    { '__' -as [type] } {
        class __ : FillerType {}
    }
}
