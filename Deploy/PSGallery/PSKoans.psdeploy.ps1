Deploy Module {
    By PSGalleryModule {
        FromSource "$PSScriptRoot/../PSKoans"
        To PSGallery
        WithOptions @{
            ApiKey = $ENV:NugetApiKey
        }
    }
}
