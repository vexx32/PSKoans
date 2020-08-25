Deploy Module {
    By PSGalleryModule {
        FromSource "$PSScriptRoot/../PSKoans"
        To FileSystem
        WithOptions @{
            ApiKey = 'FileSystem'
        }
    }
}
