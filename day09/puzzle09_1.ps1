[long[]]$entries = Get-Content './input.txt'
$preamble = 25

# [int[]]$entries = Get-Content './test.txt'
# $preamble = 5

function containsSum($index) {
    # write-host "--- $index ------------------" 
    $range = $entries[($index-$preamble)..($index-1)]
    $sum = $entries[$index]
    for($i=0; $i -lt $preamble; $i++){
        for($j=0; $j -lt $preamble; $j++){
            if($j -eq $i){
                continue
            }
            # write-host "$($range[$i]) + $($range[$j]) =  $($range[$i]+$range[$j]) ? $sum"
            if($sum -eq $range[$i]+$range[$j]){
                
                return $true
            }
        }
    }
    return $false
}

$i = $preamble
$s1 = 0
while($i -lt ($entries.Count-1)){
    if(!(containsSum $i)){
        $s1 = $entries[$i]
        write-host "Solution 1 is $($i) : $s1"
        break
    }
    $i++
}


for($i=0; $i -lt $entries.Count; $i++){
    $j = $i+1
    $sum = $entries[$i]
    $range = @($entries[$i])
    while(($j -lt $entries.Count) -and ($sum -lt $s1)){
        $sum += $entries[$j]
        $range += $entries[$j]
        if($sum -eq $s1){
            $min = ($range | Measure-Object -Minimum).Minimum
            $max = ($range | Measure-Object -Maximum).Maximum
            write-host "Solution 2 is $($range -join ',') : $min + $max = $($min+$max)"
        }
        $j++
    }
    # write-host "$i : $($range -join ',') nope"
}
