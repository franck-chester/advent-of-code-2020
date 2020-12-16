$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'

$part = 'rules'
[hashtable] $rules = @{}
[int[]]$ticket=@()
[int[]]$invalid = @()
foreach($entry in $entries){
    if([string]::IsNullOrEmpty($entry)){continue}
    if($entry -eq 'your ticket:'){$part = 'ticket'; continue}
    if($entry -eq 'nearby tickets:'){$part = 'others'; continue}
    switch($part){
        'rules'{
            $null = $entry -match '([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)'
            $rules.Add($matches[1], @([int]$matches[2],[int]$matches[3],[int]$matches[4],[int]$matches[5]))
            break
        }
        'ticket'{
            $ticket = $entry -split ','
            break
        }
        'others'{
            [int[]]$values = $entry -split ','

            foreach ($value in $values) {
                $valid = $false
                foreach ($rule in $rules.Values) {
                    $rule1 = ($rule[0] -le $value -and $rule[1] -ge $value)
                    $rule2 = ($rule[2] -le $value -and $rule[3] -ge $value)
                    
                    if($rule1 -or $rule2){
                        $valid = $true
                        break
                    }else{
                        #invalid
                        if(!$rule1){
                            write-host -ForegroundColor Magenta "$($rule[0]) <= $value <= $($rule[1])"
                            
                        }
                        if(!$rule2){
                            write-host -ForegroundColor DarkMagenta "$($rule[2]) <= $value <= $($rule[3])"
                        }
                    }
                }
                if(!$valid){
                    $invalid += $value
                    continue
                }
            }
        }

    }
}
$invalid | ForEach-Object {$sum += $_}
write-host "Solution is $sum : $($invalid -join ',')"