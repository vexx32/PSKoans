Deploy Module {
    By PSGalleryModule {
        FromSource PSKoans
        To FileSystem
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }
}
