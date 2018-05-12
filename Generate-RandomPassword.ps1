[CmdletBinding()]
Param (
    
    [Int32[]]$Length = 10,

    [Switch]$LowerCase,

    [Switch]$UpperCase,

    [Switch]$Numbers,

    [Switch]$Symbols,

    [Switch]$ExcludeAmbiguousCharacters,

    [Int]$Count = 1

)

#Validate at least one character type is chosen
If (!$LowerCase -and !$UpperCase -and !$Numbers -and !$Symbols) {

    Write-Error "At least one character group must be chosen!"
    Break

}

#Available Character Types
$LowerCaseCharacters = @('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
$UpperCaseCharacters = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
$NumberCharacters = @('0','1','2','3','4','5','6','7','8','9')
$SymbolCharacters = @('!','@','#','$','%','^','&','*','(',')','[',']','{','}','-','_','=','+','<','>',',','?','/','\',':',';')
$AmbiguousCharacters = @('(',')','[',']','{','}','/','\','.',',')

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

#Ensure the (minimum) length is greater than or equal to the number of character set counts. Otherwise verification will fail later.
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

    Do {
        
        #Create an empty password array
        $PasswordArray = @()

        #If a length range is specified (if it is a multi item array)
        If ($Length.Count -gt 1) {

            Write-Verbose '$Length is an array'

            #Choose a random length between the min and max specified
            $Length = $Length[0]..$Length[1] | Get-Random

        }

        #Convert the length to a non array integer
        [Int32]$Length = $Length[0]

        #Loop through each character space and choose a random character from the character set
        1..$Length | ForEach-Object {

            Write-Verbose "Processing character $($_)"
            $PasswordArray += $CharacterSet | Get-Random

        }

        $Password = $PasswordArray -join ''

        $PasswordValid = $True

        #Ensure that the password meets the requirements
        If ($LowerCase) {

            If ($Password -cnotmatch '[a-z]') {

                Write-Verbose '$Password does not contain lowercase letters'

                $PasswordValid = $False
                Continue

            } Else {$PasswordValid = $True}

        }

        If ($UpperCase) {

            If ($Password -cnotmatch '[A-Z]') {

                Write-Verbose '$Password does not contain uppercase letters'

                $PasswordValid = $False
                Continue
                
            } Else {$PasswordValid = $True}

        }

        If ($Numbers) {

            If ($Password -notmatch '\d') {

                Write-Verbose '$Password does not contain numbers'

                $PasswordValid = $False
                Continue

            } Else {$PasswordValid = $True}

        }

        If ($Symbols) {

            If ($Password -notmatch '(\p{P}|\p{S})+') {

                Write-Verbose '$Password does not contain symbols'

                $PasswordValid = $False
                Continue

            } Else {$PasswordValid = $True}

        }

    } Until ($PasswordValid -eq $True)
    
    Write-Output $Password

}