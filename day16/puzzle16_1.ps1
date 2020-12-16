$entries = Get-Content './input.txt'
#$entries = Get-Content './test1.txt'
#$entries = Get-Content './test2.txt'
$part = 'rules'
[string[]] $rulesNames = @()
[int[][]] $rulesValues = @()
[int[]]$ticket = @()
[int[][]]$validEntries = @()
[int[]]$invalid = @()
foreach ($entry in $entries) {
    if ([string]::IsNullOrEmpty($entry)) { continue }
    if ($entry -eq 'your ticket:') { $part = 'ticket'; continue }
    if ($entry -eq 'nearby tickets:') { $part = 'others'; continue }
    switch ($part) {
        'rules' {
            $null = $entry -match '([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)'
            $rulesNames += $entry
            $rulesValues += , @([int]$matches[2], [int]$matches[3], [int]$matches[4], [int]$matches[5])
            break
        }
        'ticket' {
            $ticket = $entry -split ','
            $validEntries = @(, $ticket)
            break
        }
        'others' {
            [int[]]$values = $entry -split ','
            $validCount = 0
            foreach ($value in $values) {
                $valid = $false
                foreach ($rule in $rulesValues) {
                    $rule1 = ($rule[0] -le $value -and $rule[1] -ge $value)
                    $rule2 = ($rule[2] -le $value -and $rule[3] -ge $value)
                    
                    if ($rule1 -or $rule2) {
                        $valid = $true
                        break
                    }
                    else {
                        
                        if (!$rule1) {
                            #write-host -ForegroundColor Magenta "$($rule[0]) <= $value <= $($rule[1])"
                            
                        }
                        if (!$rule2) {
                            #write-host -ForegroundColor DarkMagenta "$($rule[2]) <= $value <= $($rule[3])"
                        }
                    }
                }
                if (!$valid) {
                    $invalid += $value
                    continue
                }
                else {
                    $validCount++
                }
            }
            if ($validCount -eq $values.Count) {
                $validEntries += , $values
            }
        }

    }
}
$invalid | ForEach-Object { $sum += $_ }
write-host "Solution 1 is $sum : $($invalid -join ',')"

write-host "=========================================="
[bool[][][]]$allMatchingEntries = @()
foreach ($validEntry in $validEntries) {
    [bool[][]]$matchingEntries = @()
    #write-host "$($validEntry -join ',')"
    for ($i = 0; $i -lt $rulesNames.Count ; $i++) {
        $rule = $rulesValues[$i]
        [bool[]]$matchingValues = @()
        foreach ($value in $validEntry) {
            $rule1 = ($rule[0] -le $value -and $rule[1] -ge $value)
            $rule2 = ($rule[2] -le $value -and $rule[3] -ge $value)
            
            $matchingValues += ($rule1 -or $rule2) # 3rd index is position in entry
        }
        #write-host "$($rulesNames[$i]) : $($matchingValues -join ',')"
        $matchingEntries += , $matchingValues  # 2nd index is rule
    }
    $allMatchingEntries += , $matchingEntries  # first index is entries
    
}
$solution1 = @{}

for ($p = 0; $p -lt $rulesNames.Count ; $p++) {  # position in entry
    for ($i = 0; $i -lt $rulesNames.Count ; $i++) {  # rule
        $allTrue = $true
        for ($j = 0; $j -lt $allMatchingEntries.Count ; $j++) {  #entry
            # if this position is true for all entries for a given rule, that position could be the rule's
        
            if (!$allMatchingEntries[$j][$i][$p]) {
                $allTrue = $false
                break
            }
        }
        if ($allTrue) {
            #write-host "position $p : rule $($rulesNames[$i]) : all entries are true"
            if(!$solution1.ContainsKey($rulesNames[$i])){
                $solution1.Add($rulesNames[$i],@())
            }
            $solution1[$rulesNames[$i]] += , $p
        }
        else{
            #write-host "position $p : rule $($rulesNames[$i]) : entry $j ($($matchingEntries[$j] -join',')) is false"
        }
    }
}

$solution1
$solution2

$done = $true
$pass = 0
$indexesFound = @()
do{
    $done = $true
    foreach($key in $rulesNames){
        $possibleIndexes = $solution1[$key]
        if($possibleIndexes.Count -eq 1){
            $index = $possibleIndexes[0]
            #remove that index from all other possibilities
            if($indexesFound -notcontains $index){
                
                $indexesFound+= ,$index
                write-host "pass $pass : $key confirmed index $index : $($indexesFound -join',')"
            }
        }else{
            $done = $false
            $filteredIndexes = @()
            foreach($index in $possibleIndexes){
                if($indexesFound -notcontains $index){
                    $filteredIndexes+= ,$index
                }
            }
            write-host "pass $pass : $key remove ($($indexesFound -join',')) from ($($possibleIndexes -join',')) -> ($($filteredIndexes -join','))"
            $solution1[$key] = $filteredIndexes
        }
    }
    write-host "pass $pass : confirmed indexes ($($indexesFound -join','))"
    #$solution1
    $pass++
}while(!$done)


$solution1
$result = 1
foreach($key in $solution1.Keys | Where-Object {$_ -match '^departure.*'}){
    write-host "$key : field $($solution1[$key][0]) = $($ticket[$index])"
    $index = [int32]::Parse($solution1[$key][0])
    $result *= $ticket[$index]
}
write-host "Solution 2 is $result"
