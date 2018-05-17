Function New-RandomPassword {

    <#

        .SYNOPSIS
            Generates a random password

        .DESCRIPTION
            Generates a random password. Allows for the specification of character classes,
            length (including a length range), the exclusion of ambiguous characters, and the
            ability to output multiple passwords at once.

        .PARAMETER LowerCase
            Specifies that the password must have at least one lower case letter.

        .PARAMETER UpperCase
            Specifies that the password must have at least one upper case letter.

        .PARAMETER Numbers
            Specifies that the password must have at least one digit (0-9).

        .PARAMETER Symbols
            Specifies that the password must have at least one common symbol.

        .PARAMETER ExcludeAmbiguousCharacters
            Specifies that the password must not have any ambiguous or similar characters.
            This prevents confustion when manually reading and typing the password.

        .PARAMETER Length
            The required length of the randomly generated password. This also accepts an array
            of only 2 integers. Ex: 6,25 (Randomly generated passwoed between 6 and 25 characters)
            If unspecified, the length has a default fixed value of 10.
        
        .PARAMETER Count
            Specifies the number of randomly generated passwords to return. The default is 1.

        .EXAMPLE
            PS C:> .\Generate-RandomPassword.ps1 -Length 6 -LowerCase -UpperCase -Numbers -Symbols
            2@,+Yl

        .EXAMPLE
            PS C:> .\Generate-RandomPassword.ps1 -Length 6,10 -LowerCase -UpperCase -Numbers -Symbols
            zz7(=EE
        
        .EXAMPLE
            PS C:> .\Generate-RandomPassword.ps1 -Length 6,40 -LowerCase -UpperCase -Numbers -Symbols -Count 5
            <w7G_YY@Zfcr,0D#gTxl<:-tGu&w
            5V3Gh3Jlu7P^v)$7!
            _x<V@4fa*O#\{<Y_L%!UWnXeHyT=WvB+e/
            QKU\Sf)v_;u68t
            UJ=)0JyVsaT3#!Q*GA9k%nG>KNQp%}7C-S2mh2#

        .EXAMPLE
            PS C:> .\Generate-RandomPassword.ps1 -Length 6,40 -LowerCase -UpperCase -Numbers -Symbols -ExcludeAmbiguousCharacters -Count 5
            UJ5lCZsU7TAqFlg8xX*DZLh%FI=:
            bPMf_3E?dn6IDlM
            2f*bWC=-C1gvfr:2;p7=f
            K_*&jXnui$dsPx3*nbZqa4
            7y%3J8^;YaHuS&npzN&I

    #>

    [CmdletBinding()]
    Param (

        [Switch]$LowerCase,

        [Switch]$UpperCase,

        [Switch]$Numbers,

        [Switch]$Symbols,

        [Switch]$ExcludeAmbiguousCharacters,

        [Int32[]]$Length = 10,

        [Int]$Count = 1,

        [Switch]$CopyToClipboard

    )

    #Validate at least one character type is chosen
    If (!$LowerCase -and !$UpperCase -and !$Numbers -and !$Symbols) {

        Write-Error "At least one character group must be chosen!"
        Break

    }

    #Validate that the length parameter is an array with either 1 or 2 elements (a fixed length or a length range)
    If ($Length.count -gt 2 -or $Length.count -lt 1) {
        Write-Error "Specified length must be a single number or a range of two numbers separated by a comma (an array)."
        Break
    } 

    #Available Character Types
    $LowerCaseCharacters = @('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
    $UpperCaseCharacters = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
    $NumberCharacters = @('0','1','2','3','4','5','6','7','8','9')
    $SymbolCharacters = @('!','@','#','$','%','^','&','*','(',')','[',']','{','}','-','_','=','+','<','>',',','?','/','\',':',';')
    $AmbiguousCharacters = @('(',')','[',']','{','}','/','\','.',',','0','O','o','Q')

    #Construct a character Set. An array list is used for easy removal of items from array
    [System.Collections.ArrayList]$CharacterSet = @()

    #Check if each possible character type has been chosen. 
    If ($LowerCase) {
        
        #If it has, add it to the character set and increment the character set count by 1
        $CharacterSet += $LowerCaseCharacters
        $CharacterSetCount++

    }

    If ($UpperCase) {

        #If it has, add it to the character set and increment the character set count by 1
        $CharacterSet += $UpperCaseCharacters
        $CharacterSetCount++

    }

    If ($Numbers) {

        #If it has, add it to the character set and increment the character set count by 1
        $CharacterSet += $NumberCharacters
        $CharacterSetCount++

    }

    If ($Symbols) {

        #If it has, add it to the character set and increment the character set count by 1
        $CharacterSet += $SymbolCharacters
        $CharacterSetCount++

    }

    #Ensure the (minimum) length is greater than or equal to the number of character set counts. Otherwise verification later on will cause an infinite loop.
    If ($Length[0] -lt $CharacterSetCount) {

        Write-Error "The specified length of the password must be greater than or equal to the number of character sets chosen!"
        Break
        
    }

    If ($ExcludeAmbiguousCharacters) {

        ForEach ($Item in $AmbiguousCharacters) {

            $CharacterSet.Remove($Item)

        }

    }    

    #Create a password N number of times based on the count variable
    For ($i = 1; $i -le $Count; $i++) {

        Write-Verbose "Starting password: $i."

        Do {
            
            #Create an empty password array
            $PasswordArray = @()

            #If a length range is specified (if it is a multi item array)
            If ($Length.Count -gt 1) {

                Write-Verbose '$Length is an array'

                #Choose a random length between the min and max specified
                [Int32]$PasswordLength = $Length[0]..$Length[1] | Get-Random

            }

            Else {
                
                #Convert the length to a non array integer
                [Int32]$PasswordLength = $Length[0]
            
            }
            
            Write-Verbose "`$PasswordLength is $PasswordLength" 

            #Loop through each character space and choose a random character from the character set
            1..$PasswordLength | ForEach-Object {

                Write-Verbose "Processing character $($_)"
                $PasswordArray += $CharacterSet | Get-Random

            }

            $Password = $PasswordArray -join ''

            $PasswordValid = $True

            #Ensure randomly generated password meets original requirements
            If ($LowerCase) {

                If ($Password -cnotmatch '[a-z]') {

                    Write-Verbose '$Password does not contain lowercase letters. Starting over.'

                    $PasswordValid = $False
                    Continue

                } Else {$PasswordValid = $True}

            }

            If ($UpperCase) {

                If ($Password -cnotmatch '[A-Z]') {

                    Write-Verbose '$Password does not contain uppercase letters. Starting over.'

                    $PasswordValid = $False
                    Continue
                    
                } Else {$PasswordValid = $True}

            }

            If ($Numbers) {

                If ($Password -notmatch '\d') {

                    Write-Verbose '$Password does not contain numbers. Starting over.'

                    $PasswordValid = $False
                    Continue

                } Else {$PasswordValid = $True}

            }

            If ($Symbols) {

                If ($Password -notmatch '(\p{P}|\p{S})+') {

                    Write-Verbose '$Password does not contain symbols. Starting over.'

                    $PasswordValid = $False
                    Continue

                } Else {$PasswordValid = $True}

            }

        } Until ($PasswordValid -eq $True)
        
        Write-Output $Password

        If ($CopyToClipboard) {

            [Array]$Passwords += $Password

        }

    }

    If ($CopyToClipboard) {

        Write-Information "Password(s) copied to clipboard." -InformationAction Continue
        Set-Clipboard $Passwords

    }

}