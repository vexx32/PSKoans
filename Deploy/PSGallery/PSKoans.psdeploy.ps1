Deploy Module {
    By PSGalleryModule {
        FromSource PSKoans
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }
}
