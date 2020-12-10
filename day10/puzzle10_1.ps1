[int[]]$entries = Get-Content './input.txt'
# [int[]] $entries = Get-Content './test01.txt'
# [int[]] $entries = Get-Content './test02.txt'
$entries = $entries | Sort-Object
$max = ($entries| Measure-Object -Maximum).Maximum

$rating = 0
$index = 0
$j = 0
$j1 = 0
$j3 = 1
foreach($jolt in $entries){
    if($jolt - $j -eq 1){
        $j1++
    }elseif($jolt - $j -eq 3){
        $j3++
    }

    $rating += $jolt
    $j = $jolt
    write-host "$index : + $jolts = $rating"
    $index++
}

write-host "$j1 differences of 1 jolt and $j3 differences of 3 jolts -> $($j1*$j3)"