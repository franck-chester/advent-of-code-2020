$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'

function isExpression([char[]]$steps) {
    return ($steps -contains '+') -or ($steps -contains '-') -or ($steps -contains '*') -or ($steps -contains '(') -or ($steps -contains ')')
}
function bracket ([char[]]$steps) {
    #write-host "Put brackets around: ($($steps -join '')) ..."
    $newSteps = @('(')
    $openBracket = 1
    $previousExpressionStart = 0
    for ($i = 0; $i -lt $steps.Count; $i++) {
        $step = $steps[$i]
        switch ($step) {
            
            '*' {  
                if (isExpression $steps[$previousExpressionStart..($i - 1)]) {
                    $newSteps += @(')')
                    $newSteps = @('(') + $newSteps
                }
                $newSteps += '*'
                if (isExpression $steps[($i + 1)..($steps.count - 1)]) {
                    $newSteps += @('(')
                    $openBracket++
                    $previousExpressionStart = $i + 1
                }
                break
            }
            '(' {  
            
                $open = 1
                $braketContent = @()
                do {
                    $i++
                    $braketContent += $steps[$i]
                    switch ($steps[$i]) {
                        '(' {
                            $open++
                            break
                        }
                        ')' {
                            $open--
                            break
                        }
                        default {}
                    }
                }while ($open -gt 0 -and $i -lt $steps.Count)
                $newSteps += bracket $braketContent[0 .. ($braketContent.Count - 2)]
                break
            }
            ')' { write-host -ForegroundColor red "closing bracket!!!" }
            default {
                $newSteps += $step
            }
        }
    }
    while ($openBracket -gt 0) {
        $newSteps += @(')')
        $openBracket--
    }
    write-host "Put brackets around: $($steps -join '') -> $($newSteps -join '')"
    return $newSteps
}

function calculate ([char[]]$steps) {
    #write-host "calculate $($steps -join '') = ????"

    $result = 0
    $number = 0
    $value = ''
    $operator = '+'
    for ($i = 0; $i -lt $steps.Count; $i++) {
        $step = $steps[$i]
        switch ($step) {
            '+' {  
                #write-host "Parsing '$value' before a + sign"
                try{
                    $number = [int64]::Parse($value)
                }
                catch{

                    write-error $_.Exception
                    exit
                }

                switch ($operator) {
                    '+' {  
                        write-host "$result + $number = $($result + $number)"
                        $result += $number
                        break
                    }
                    '-' {  
                        write-host "$result - $number = $($result - $number)"
                        $result -= $number
                        break
                    }
                    '*' {  
                        write-host "$result * $number = $($result * $number)"
                        $result *= $number
                        break
                    }
                }

                $value = ''
                $operator = $step
                break
            }
            '-' {  
                #write-host "Parsing '$value' before a - sign"
                $number = [int32]::Parse($value)

                switch ($operator) {
                    '+' {  
                        write-host "$result + $number = $($result + $number)"
                        $result += $number
                        break
                    }
                    '-' {  
                        write-host "$result - $number = $($result - $number)"
                        $result -= $number
                        break
                    }
                    '*' {  
                        write-host "$result * $number = $($result * $number)"
                        $result *= $number
                        break
                    }
                }
                $value = ''
                $operator = $step
                break
            }
            '*' {  
                #write-host "Parsing '$value' before a * sign"
                $number = [int32]::Parse($value)

                switch ($operator) {
                    '+' {  
                        write-host "$result + $number = $($result + $number)"
                        $result += $number
                        break
                    }
                    '-' {  
                        write-host "$result - $number = $($result - $number)"
                        $result -= $number
                        break
                    }
                    '*' {  
                        write-host "$result * $number = $($result * $number)"
                        $result *= $number
                        break
                    }
                }

                $value = ''
                $operator = $step
                break
            }
            '(' {  
            
                $open = 1
                $braketContent = @()
                do {
                    $i++
                    $braketContent += $steps[$i]
                    switch ($steps[$i]) {
                        '(' {
                            $open++
                            break
                        }
                        ')' {
                            $open--
                            break
                        }
                        default {}
                    }
                }while ($open -gt 0 -and $i -lt $steps.Count)
                write-host "calculate   $($braketContent[0 .. ($braketContent.Count-2)] -join '')"
                $number = calculate $braketContent[0 .. ($braketContent.Count - 2)]
                $value = "$number"
                break
            }
            ')' { write-host -ForegroundColor red "closing bracket!!!" }
            default {
                if ($value -eq '') {

                    $value += $step
                }
            }
        }
    }
    #write-host "Parsing final '$value' before = sign"
    $number = [int64]::Parse($value)
    switch ($operator) {
        '+' {  
            write-host "$result + $number = $($result + $number)"
            $result += $number
            break
        }
        '-' {  
            write-host "$result - $number = $($result - $number)"
            $result -= $number
            break
        }
        '*' {  
            write-host "$result * $number = $($result * $number)"
            $result *= $number
            break
        }
    }
    write-host "$($steps -join '') = $result"
    return $result
}


$sum = 0
foreach ($entry in $entries) {
    write-host "Calculating $entry = ????"
    $solution = calculate ( bracket ($entry.ToCharArray() | Where-Object { $_ -ne ' ' }) )
    write-host "$entry = $solution" -ForegroundColor DarkGreen
    $sum += $solution
}

write-host "final sum  = $sum"
