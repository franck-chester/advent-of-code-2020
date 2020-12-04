$batch = [Io.File]::ReadAllText("$PSScriptRoot/input.txt")
#$batch = [Io.File]::ReadAllText("$PSScriptRoot/test.txt")
#$batch = [Io.File]::ReadAllText("$PSScriptRoot/invalid.txt")
#$batch = [Io.File]::ReadAllText("$PSScriptRoot/valid.txt")

$entries = ([regex]'(?sm)(?<key>[\w]+):(?<value>[\w#]+)[ ]?|^$').Matches($batch)
$expectedKeys = @('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid')
$validKeysCount = 0
$validCount = 0
$passport = @{}
$outputFile = "$PSScriptRoot/output.txt"
Set-Content $outputFile $entry
foreach ($entry in $entries) {
    $value = $entry[0].Value
    if ([string]::IsNullOrEmpty($value)) {
        if ($byr -and $iyr -and $eyr -and $hgt -and $hcl -and $ecl -and $pid2) {
            $validCount++
            ($passport.GetEnumerator() | ForEach-Object { Add-Content $outputFile  "$($_.Key)=$($_.Value)" })
            Add-Content $outputFile  "--- VALID  $validCount"
        }
        else {
            #write-host "--- INVALID !!!" -ForegroundColor Red
        }
        $byr= $iyr= $eyr= $hgt = $hcl = $ecl = $pid2 = $false
        $validKeysCount = 0
        #write-host "---------------------" 
        $passport = @{}
    }
    else {
        $key = $entry.Groups['key'].Value
        if ($expectedKeys -contains $key) {
            $valid = $false
            $v = $entry.Groups['value'].Value
            switch ($key) {
                'byr' {
                    # (Birth Year) - four digits; at least 1920 and at most 2002.
                    $valid = $byr = !$byr -and ($v -match '^\d{4}$') -and (([int]$v) -ge 1920) -and ([int]$v -le 2002)
                }
                'iyr' {
                    # (Issue Year) - four digits; at least 2010 and at most 2020.
                    $valid = $iyr = !$iyr -and ($v -match '^\d{4}$') -and (([int]$v) -ge 2010) -and ([int]$v -le 2020)
                }
                'eyr' {
                    # (Expiration Year) - four digits; at least 2020 and at most 2030.
                    $valid = $eyr = !$eyr -and ($v -match '^\d{4}$') -and (([int]$v) -ge 2020) -and ([int]$v -le 2030)
                }
                'hgt' {
                    # (Height) - a number followed by either cm or in:
                    #If cm, the number must be at least 150 and at most 193.
                    #If in, the number must be at least 59 and at most 76.
                    switch -Regex($v){
                        '^(\d*)cm$'{
                            $v = [int]$matches[1]
                            $valid = $hgt = !$hgt -and (([int]$v) -ge 150) -and (([int]$v) -le 193)
                        }
                        '^(\d*)in$'{
                            $v = [int]$matches[1]
                            $valid = $hgt = !$hgt -and (([int]$v) -ge 59) -and (([int]$v) -le 76)
                        }
                    }
                }
                'hcl' {
                    # (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
                    $valid = $hcl = !$hcl -and ($v -match '^#[0-9a-f]{6}$')
                }
                'ecl' {
                    # (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
                    $valid = $ecl = !$ecl -and ($v -match '^(amb|blu|brn|gry|grn|hzl|oth)$')
                }
                'pid' {
                    # (Passport ID) - a nine-digit number, including leading zeroes.
                    $valid = $pid2 = !$pid2 -and ($v -match '^\d{9}$')
                }
                default { 
                    write-host "???????? $($key)" -ForegroundColor yellow
                }
            }
            if($valid){
                $validKeysCount++
                #write-host $value
                $passport.Add($key,$entry.Groups['value'])
            }
            else{
                #write-host "$entry is INVALID !!!" -ForegroundColor red
            }
        }
    }
}

write-host "Found $validCount valid passports"