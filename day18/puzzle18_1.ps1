$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'

function calculate ([char[]]$steps) {
    write-host "calculate ($($steps -join '')) = ????"
    $result = 0
    $number = 0
    $value = ''
    $operator = '+'
    for ($i = 0; $i -lt $steps.Count; $i++) {
        $step = $steps[$i]
        switch ($step) {
            '+' {  
                write-host "Parsing '$value' before a + sign"
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
            '-' {  
                write-host "Parsing '$value' before a - sign"
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
                write-host "Parsing '$value' before a * sign"
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
                write-host "calculate `$braketContent[0..(-2)] = ($($braketContent -join ''))[0..-2] = $($braketContent[0 .. ($braketContent.Count-2)] -join '')"
                $number = calculate $braketContent[0 .. ($braketContent.Count-2)]
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
    write-host "Parsing final '$value' before = sign"
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
    write-host "$($steps -join '') = $result"
    return $result
}


$sum = 0
foreach ($entry in $entries) {
    write-host "Calculating $entry = ????"
    $solution =  calculate ($entry.ToCharArray()| Where-Object { $_ -ne ' ' })
    write-host "$entry = $solution" -ForegroundColor DarkGreen
    $sum+=$solution
}

write-host "final sum  = $sum"
