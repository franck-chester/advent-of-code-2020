$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'

$mem = @(0)
foreach($entry in $entries){
    if($entry -match 'mask = ([X10]*)$'){
        $mask = ($matches[1]).ToCharArray()
    }
    elseif($entry -match 'mem\[(\d+)\] = (\d+)\s*$'){
        $value = [Convert]::ToString($matches[2],2).padLeft(36,'0')
        $addr = [int]($matches[1])
        if($addr -gt $mem.Count){
            $mem += @(0)*($addr - $mem.Count +1)
        }
        $maskedValue = $value.ToCharArray()
        for($i=0; $i -lt 36; $i++){
            if($mask[$i] -ne 'X'){
                $maskedValue[$i] = $mask[$i]
            }
        }
        $mem[$addr] =  [Convert]::ToInt64($maskedValue -join '',2)
        write-host "$entry\t: "
        write-host " : $($value)|"
        write-host " & $($mask -join '')|"
        write-host " = $($maskedValue -join '')|"
        write-host " = $($mem[$addr])"
    }

}
$sum = ($mem  | Measure-Object -Sum).Sum
write-host "Solution is $sum"