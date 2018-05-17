# PowerShell Random Password Generator
A Random Password Generator Written in PowerShell!

## Features
* Static or random length (based on a given range)
* The ability to specifiy character sets to use: Upper Case, Lower Case, Numbers, Symbols
* The ability to exclude ambiguous characters
* The ability to output multiple passwords
* Checks that the randomly generated password meets complexity requirements spcified. If it doesn't it re-generates it.
* Verbose output

## Usage
1. First begin by cloning/downloading the repo to one of the directories in your $env:PSModulePath OR manually import the module:
```PowerShell
PS C:> Import-Module .\Random-Password-Generator\Random-Password-Generator
```

2. Then call the funtion `New-RandomPassword`

```PowerShell
PS C:> New-RandomPassword -Length 6 -LowerCase -UpperCase -Numbers -Symbols

2@,+Yl
```

```PowerShell
PS C:> New-RandomPassword -Length 6,10 -LowerCase -UpperCase -Numbers -Symbols

zz7(=EE
```

```PowerShell
PS C:> New-RandomPassword -Length 6,40 -LowerCase -UpperCase -Numbers -Symbols -Count 5

<w7G_YY@Zfcr,0D#gTxl<:-tGu&w
5V3Gh3Jlu7P^v)$7!
_x<V@4fa*O#\{<Y_L%!UWnXeHyT=WvB+e/
QKU\Sf)v_;u68t
UJ=)0JyVsaT3#!Q*GA9k%nG>KNQp%}7C-S2mh2#
```

```PowerShell
PS C:> New-RandomPassword -Length 6,40 -LowerCase -UpperCase -Numbers -Symbols -ExcludeAmbiguousCharacters -Count 5

UJ5lCZsU7TAqFlg8xX*DZLh%FI=:
bPMf_3E?dn6IDlM
2f*bWC=-C1gvfr:2;p7=f
K_*&jXnui$dsPx3*nbZqa4
7y%3J8^;YaHuS&npzN&I
```

## Full Help Documentation
A full set of help documenation can be found by executing the following after importing the module:
```PowerShell
PS C:\> Get-Help New-RandomPassword -Full
```