$Verbose = @{}
if ($env:APPVEYOR_REPO_BRANCH -and $env:APPVEYOR_REPO_BRANCH -notlike "master") {
    
    $Verbose.add("Verbose",$True)

}

$PSVersion = $PSVersionTable.PSVersion.Major
Import-Module $PSScriptRoot\..\Random-Password-Generator -Force
Describe "New-RandomPassword" {

    #Context "No Parameters" {

        It "Errors if number of character classes exceeds specified length" {

            $Error.clear()
            New-RandomPassword -LowerCase -UpperCase -Numbers -Length 2 -ErrorAction SilentlyContinue
            $Error.Exception.Message | Should Be "The specified length of the password must be greater than or equal to the number of character sets chosen!"

        }

        It "No length is specified, a 16 character password is outputted" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -LowerCase -UpperCase -Numbers -Symbols
            $Password.length | Should Be 16

        }

        It "If length is specified, the password outputted is that length" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -LowerCase -UpperCase -Numbers -Symbols -Length 14
            $Password.length | Should Be 14

        }

        It "If password count is specified, the number of outputted passwords matches the count" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -LowerCase -UpperCase -Numbers -Symbols -Count 2
            $Password.count | Should Be 2

        }

        It "If -LowerCase is specified, the password contains at least 1 lower case letter" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -LowerCase
            $Password | Should MatchExactly '[a-z]'

        }

        It "If -UpperCase is specified, the password contains at least 1 upper case letter" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -UpperCase
            $Password | Should MatchExactly '[A-Z]'

        }

        It "If -Numbers is specified, the password contains at least 1 number" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -Numbers
            $Password | Should MatchExactly '\d'

        }

        It "If -Symbols is specified, the password contains at least 1 number" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -Symbols -ErrorAction SilentlyContinue                
            $Password | Should Match "(\p{P}|\p{S})+"
        
        }

        <#
        It "If -ExcludeAmbiguousCharacters is specified, the password should not contain any" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -Symbols -ExcludeAmbiguousCharacters -ErrorAction SilentlyContinue
            ForEach ($Char in $Password.ToCharArray()) {

                @('(',')','[',']','{','}','/','\','.',',','0','O','o','Q') | Should Contain $Char

            }

        }
        #>

        It "If -CopyToClipboard is specified, the clipboard should contain the password" {

            Remove-Variable Password -ErrorAction SilentlyContinue
            $Password = New-RandomPassword -LowerCase -UpperCase -Numbers -Symbols -CopyToClipboard -ErrorAction SilentlyContinue
            $Clipboard = Get-Clipboard
            $Clipboard | Should BeExactly $Password

        }

    #}

}