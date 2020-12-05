#$batch = [Io.File]::ReadAllText("$PSScriptRoot/input.txt")
#$batch = [Io.File]::ReadAllText("$PSScriptRoot/test.txt")
$batch = [Io.File]::ReadAllText("$PSScriptRoot/invalid.txt")
#$batch = [Io.File]::ReadAllText("$PSScriptRoot/valid.txt")
$expectedKeys = @('byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid')
$entries = ([regex]'(?sm)(?:(?:(?:(?:(?:byr:(?<byr>\d{4}))|(?:iyr:(?<iyr>\d{4}))|(?:eyr:(?<eyr>\d{4}))|(?:hgt:(?<hgt>\d*)(?<hgtu>cm|in))|(?:hcl:(?<hcl>#[0-9a-f]{6}))|(?:ecl:(?<ecl>amb|blu|brn|gry|grn|hzl|oth))|(?:pid:(?<pid>\d{9})))\s?))+(^$)?)').Matches($batch)
$validCount = 0
foreach ($entry in $entries) {
    if(! $entry.Groups.Keys -contains $expectedKeys){
        continue
    }
    foreach($key in $expectedKeys){
        $v = $entry.Groups[$key].Value
        switch ($key) {
            'byr' {
                # (Birth Year) - four digits; at least 1920 and at most 2002.
                $valid = (([int]$v) -ge 1920) -and ([int]$v -le 2002)
            }
            'iyr' {
                # (Issue Year) - four digits; at least 2010 and at most 2020.
                $valid = (([int]$v) -ge 2010) -and ([int]$v -le 2020)
            }
            'eyr' {
                # (Expiration Year) - four digits; at least 2020 and at most 2030.
                $valid = (([int]$v) -ge 2020) -and ([int]$v -le 2030)
            }
            'hgt' {
                # (Height) - a number followed by either cm or in:
                #If cm, the number must be at least 150 and at most 193.
                #If in, the number must be at least 59 and at most 76.
                switch ($entry.Groups['hgtu'].Value){
                    'cm'{
                        $valid = (([int]$v) -ge 150) -and (([int]$v) -le 193)
                    }
                    'in'{
                        $valid = (([int]$v) -ge 59) -and (([int]$v) -le 76)
                    }
                }
            }
        }
    }
    if($valid){
        write-host $entry
        $validCount++
    }
}

write-host "Found $validCount valid passports"