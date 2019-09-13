# Only attempt to load dummy types if they're not already present in the session

switch ($null) {
    ('FillerType' -as [type]) {
        class FillerType { }
    }
    ('__' -as [type]) {
        class __ : FillerType { }
    }
    ('____' -as [type]) {
        class ____ : FillerType { }
    }
}
