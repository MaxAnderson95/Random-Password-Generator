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

If ($LowerCase) {
    
    $CharacterSet += $LowerCaseCharacters

}

If ($UpperCase) {

    $CharacterSet += $UpperCaseCharacters

}

If ($Numbers) {

    $CharacterSet += $NumberCharacters

}

If ($Symbols) {

    $CharacterSet += $SymbolCharacters

}

If ($ExcludeAmbiguousCharacters) {

    ForEach ($Item in $AmbiguousCharacters) {

        $CharacterSet.Remove($Item)

    }

}

While ($PasswordValid -eq $False) {
    
    #Create a password N number of times based on the count variable
    For ($i = 1; $i -le $Count; $i++) {

        #Create an empty password array
        $PasswordArray = @()

        #If a length range is specified
        If ($Length.Count -gt 1) {

            Write-Verbose '$Length is an array'

            #Choose a random length between the min and max specified
            $Length = $Length[0]..$Length[1] | Get-Random

        }
        
        #Convert the length to a non array integer
        [Int32]$Length = $Length[0]

        #Loop through each character space and choose a random character from the character set
        1..$Length | ForEach-Object {

            Write-Verbose "Character $($_)"
            $PasswordArray += $CharacterSet | Get-Random

        }

    $Password = $PasswordArray -join ''

    #Ensure that the password meets the requirements
    If ($LowerCase) {

        If ($Password -notmatch '[a-z]') {

            $PasswordValid = $False

        } Else {$PasswordValid = $True}

    }

    If ($UpperCase) {

        If ($Password -notmatch '[A-Z]') {

            $PasswordValid = $False
            
        } Else {$PasswordValid = $True}

    }

}

Write-Output $Password

}