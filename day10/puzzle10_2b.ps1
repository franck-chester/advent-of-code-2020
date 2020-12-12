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
$solutions = @(,$entries)

for($i=1; $i -lt $entries.count - 1; $i++){
    $timer = [System.Diagnostics.Stopwatch]::StartNew()
    $solutionsSoFar = $solutions.Count
    for($j=0; $j -lt $solutionsSoFar; $j++){
        $k = [array]::indexof($solutions[$j],$entries[$i])
        $solutions+= ($entries[0..$k]+$entries[($k+1)..-1])
    }
    write-host "$i : $($solutions.Count) options in $($timer.Elapsed)"
}
