# Only attempt to load dummy types if they're not already present in the session

switch ($true) {
    { -not ('FillerType' -as [type]) } {
        class FillerType {}
    }
    { -not ('__' -as [type]) } {
        class __ : FillerType {}
    }
}
