# [int[]]$entries = Get-Content './input.txt'
#[int[]] $entries = Get-Content './test01.txt'
[int[]] $entries = Get-Content './test02.txt'

$timer = [System.Diagnostics.Stopwatch]::StartNew()
$entries = $entries | Sort-Object
$entries = @(0) + $entries
$max = ($entries | Measure-Object -Maximum).Maximum
$entries += $max + 3
write-host "$($entries -join ',')"
 
$counts = @(0) * $entries.Count
for ($i = 2; $i -lt $entries.Count - 1; $i++) {
    $counts[$i]++  # single
    $countSoFar = @(1)

    if ($entries[$i + 1] - $entries[$j-1] -le 3) {
        $counts[$i]++ # preceding single
        $countSoFar += 1
    
        for ($j = $i - 1; $j -gt 0; $j--) {
            if ($entries[$i + 1] - $entries[$j-1] -gt 3) {
                # skip entries forming a contiguous range
                break;
            }
        }
    }else{
        $j= $i-1
    }

    
    for ($k = 2; $k -lt $j; $k++) {
        $counts[$i] += $counts[$k]
        $countSoFar += $counts[$k]
    }
    
    write-host "$i : $($counts[$i]) = $($countSoFar -join '+')---------------"
}
$total = 0
for ($i = 1; $i -lt $entries.Count - 1; $i++) {
    $total += $counts[$i]
}
write-host "Solution $total - took : $($timer.Elapsed)"
