$batch = [Io.File]::ReadAllText("$PSScriptRoot/input.txt")
# $batch = [Io.File]::ReadAllText("$PSScriptRoot/test.txt")

$entries= ([regex]'(?sm)(?<key>[\w]+):(?<value>[\w#]+)[ ]?|^$').Matches($batch)
$expectedKeys = @('byr','iyr','eyr','hgt','hcl','ecl','pid')
$validKeysCount = 0
$validCount = 0
foreach($entry in $entries){
    $value = $entry[0].Value
    write-host $value

    if([string]::IsNullOrEmpty($value)){
        if($validKeysCount -eq $expectedKeys.Count){
            $validCount++
            write-host "--- VALID"
        }else{
            write-error "--- INVALID !!!"
        }
        $validKeysCount = 0
    }else{
        if($expectedKeys -contains $entry.Groups['key']){
            $validKeysCount++
        }
    }
}

write-host "Found $validCount valid passports"