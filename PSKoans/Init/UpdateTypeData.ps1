$TypeData = @{
    TypeName                  = 'PSKoans.Result'
    DefaultDisplayPropertySet = @(
        'Describe'
        'It'
        'Expectation'
        'Meditation'
        'KoansPassed'
        'TotalKoans'
        'CurrentTopic'
    )
}
Update-TypeData @TypeData -Force