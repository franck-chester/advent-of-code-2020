#$entries = Get-Content './input.txt'
$entries = Get-Content './test.txt'

$s1=$s2=0
$group = @(0) * 26
$groupSize = 0
foreach($entry in $entries){
    if([string]::IsNullOrEmpty($entry)){
        $group | ForEach-Object {if($_ -gt 0 ){$s1++}; if($_ -eq $groupSize ){$s2++}}
        $group = @(0) * 26
        $groupSize = 0
        continue
    }
    foreach($answer in $entry.ToCharArray()){
        $group[([int]$answer)-97]++
    }
    $groupSize++
}
write-host "Part1 : $s1 `n Part2 : $s2"