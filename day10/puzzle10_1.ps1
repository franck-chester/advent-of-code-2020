# [int[]]$entries = Get-Content './input.txt'
#[int[]] $entries = Get-Content './test01.txt'
[int[]] $entries = Get-Content './test02.txt'
$entries = $entries | Sort-Object
$max = ($entries| Measure-Object -Maximum).Maximum
$entries += $max+3
$rating = 0
$index = 0
$j = 0
$j1 = 0
$j2 = 0
$j3 = 1
$total = 1
foreach($jolt in $entries){
    $i = 1
    $combinations = 1
    while(($index-$i) -gt 0 -and ($entries[$index] -$entries[$index-$i] -le 3)){
        if(-not($i -eq 1 -and $entries[$index] -$entries[$index-$i] -eq 1)){
            write-host "$index  -> $($entries[$index]) and $($entries[$index-$i]) (diff of $($entries[$index] -$entries[$index-$i]))"
            $combinations++    
        }
        $i++ 
    }
    if($combinations -gt 0){
        $total *= $combinations
        write-host "$index : $($entries[($index-$i)..$index] -join ',') = $combinations combination -> $total"
    }
    if($jolt - $j -eq 1){
        $j1++
    }elseif($jolt - $j -eq 3){
        $j3++
    }

    $rating += $jolt
    $j = $jolt
    # write-host "$index : + $jolts = $rating"
    $index++
}

write-host "$j1 differences of 1 jolt and $j3 differences of 3 jolts -> $j1 x $j3 = $($j1*$j3)"
write-host "$total  combinations ?"