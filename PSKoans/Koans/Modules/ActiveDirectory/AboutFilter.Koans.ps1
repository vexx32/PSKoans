using module PSKoans
[Koan(Position = 101, Module = 'ActiveDirectory')]
param()
<#
    About Filter

    The Filter parameter used by the AD module is perhaps one of the most frequently
    asked about topics.

    The filter parameters uses PowerShell-like syntax which is ultimately used to generate an
    LDAP filter for a query against Active Directory.
#>
Describe 'About filter' {
    Context 'Operators' {
        It '-eq' {

        }

        It '-le' {

        }

        It '-ge' {

        }

        It '-ne' {

        }

        It '-lt' {

        }

        It '-gt' {

        }

        It '-approx' {

        }

        It '-band' {

        }

        It '-bor' {

        }

        It '-recursivematch' {

        }

        It '-like' {

        }

        It '-notlike' {

        }
    }

    Context 'Logical grouping' {

    }

    Context 'Quoting and script block notation' {

    }

    Context 'Variable expansion' {

    }
}
