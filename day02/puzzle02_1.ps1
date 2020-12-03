[string[]]$entries = Get-Content './input.txt'
#[string[]]$entries = Get-Content './test.txt'

$regex1 = '(\d*)\-(\d*) ([a-z]): ([a-z]*)'
$count = 0
foreach ($entry in $entries) {
    $null = $entry -match $regex1
    [int]$min = $matches[1]
    [int]$max = $matches[2]
    [char]$char = $matches[3].ToCharArray()[0] 
    $password = $matches[4]
    $charCount = ($password.ToCharArray() | Where-Object {$_ -eq $matches[3]} | Measure-Object).Count
    if(($charCount -le $max) -and ($charCount -ge $min)){
        $count++
    }
    else{
        write-error "$password contains $charCount '$char' NOT $min <= $charCount <= $max"
    }
}

write-host "$count passwords are correct"