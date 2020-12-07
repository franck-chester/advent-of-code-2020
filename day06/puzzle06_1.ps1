#$entries = Get-Content './input.txt'
$entries = Get-Content './test.txt'

$sum=0
$group = @(0) * 26
$groupSize = 0
foreach($entry in $entries){
    if([string]::IsNullOrEmpty($entry)){
        $group | ForEach-Object {if($_ -eq $groupSize ){$sum++}}
        $group = @(0) * 26
        $groupSize = 0
        continue
    }
    $groupSize++
    foreach($answer in $entry.ToCharArray()){
        $group[([int]$answer)-97]++
    }
}
$group | ForEach-Object {$sum += $_}
write-host "Solution is $sum"