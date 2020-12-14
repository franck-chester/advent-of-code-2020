#$entries = Get-Content './input.txt'
$entries = Get-Content './test.txt'

for($e = 1; $e -lt $entries.Count; $e++){
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $buses = $entries[$e] -split ','
    [int[]] $ids1 = @()
    $offsets1 = @()
    for($i = 0; $i -lt $buses.Count; $i++){
        if($buses[$i] -eq 'x'){
            continue
        }
        $ids1 += $buses[$i]
        $offsets1 += $i
    } 
    $ids = $ids1 | Sort-Object -Descending
    $offsets = @()
    for($i = 0; $i -lt $ids.Count; $i++){
        $offsets+= $offsets1[[array]::IndexOf($ids1,$ids[$i])]
    }
    [decimal]$t = 0
    $k = 1
    $step = $ids[0]
    $stepOffset = $offsets[0]
    $tmin = 0 #([decimal] (4190339999983 / $step)) *$step
    do{
        $k++
        $t = $tmin+ ($k * $step) - $stepOffset

        $found = $true
        for($i = 1; $i -lt $ids.Count; $i++){
            if(($t+$offsets[$i]) % ($ids[$i]) -gt 0){
                $found = $false
                break
            }
        } 
        if($found){
            break;
        }
        if($k % 10000000 -eq 0){
            write-host "$k : $t ... $($timer.Elapsed)"
        }
    }while($true)

    write-host "$e : Solution 2 is $t (took : $($timer.Elapsed))"
}
write-host "Expecting:"
write-host "7,13,x,x,59,x,31,19 : 1068781"
write-host "17,x,13,19 : 3417"
write-host "67,7,59,61 : 754018"
write-host "67,x,7,59,61 : 779210"
write-host "67,7,x,59,61 : 1261476"
write-host "1789,37,47,1889 : 1202161486"
