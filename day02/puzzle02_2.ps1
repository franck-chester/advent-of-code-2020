[string[]]$entries = Get-Content './input.txt'
#[string[]]$entries = Get-Content './test.txt'

$regex1 = '(\d*)\-(\d*) ([a-z]): ([a-z]*)'
$count = 0
foreach ($entry in $entries) {
    $null = $entry -match $regex1
    [int]$one = [int]$matches[1]
    [int]$two = [int]$matches[2]
    [char]$char = $matches[3].ToCharArray()[0] 
    $password = $matches[4]
    $passwordChars = $password.ToCharArray()
    if(($passwordChars[$one-1] -eq $char) -xor ($passwordChars[$two-1] -eq $char)){
        $count++
    }
    else{
        write-error "$password character $one ($($passwordChars[$one-1])) and/or $two ($($passwordChars[$two-1])) is NOT $char"
    }
}

write-host "$count passwords are correct"