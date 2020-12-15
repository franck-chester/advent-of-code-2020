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
$counts[0]=1
$counts[1]=1

for ($i = 2; $i -lt $entries.Count - 1; $i++) {
    $countSoFar = @()

    $j=0

    if( $entries[$i+1]-$entries[$i-1] -gt 3){
        # can't remove that adapter, therefore no variations for it
        write-host "$i : 0 ($($entries[$i+1])-$($entries[$i-1]) > 3)"
        continue
    }else{
        $counts[$i]+= 1
        $countSoFar+= "1"
    }
    
    $j = $i - 1
    $gap = $counts[$j] -eq 0 -or $entries[$i+1]-$entries[$j-2] -gt 3
    while($j -gt 1 -and !$gap){
        if(!$gap){
            $gap = $true
            $counts[$i]+= $counts[$j]  
            $countSoFar+= "$($counts[$j]) [$($counts[$j]) = 0 or $($entries[$i+1])-$($entries[$j-2]) > 3]"
        }else{
            if($counts[$j] -gt 0){
                $counts[$i]+= 1
                $countSoFar+= "1 [$($entries[$i+1])-$($entries[$j-2]) > 3]"
            }else{
                
                $counts[$i]+= 0
                $countSoFar+= "0 [$($entries[$i+1])-$($entries[$j-2]) > 3]"
            }
        }
        $j--
    }
    
    # first gap - can start adding all previous variations
    while($j -gt 0){
        $counts[$i]+= $counts[$j]
        $countSoFar+= "$($counts[$j])"
        $j--
    }
        
    write-host "$i : $($counts[$i]) = $($countSoFar -join ' + ')"
}
$total = 0
for ($i = 1; $i -lt $entries.Count - 1; $i++) {
    $total += $counts[$i]
}
write-host "Solution $total - took : $($timer.Elapsed)"
