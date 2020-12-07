 $entries = Get-Content './input.txt'
# $entries = Get-Content './test.txt'

$sum=0
$group = @(0) * 26
foreach($entry in $entries){
    if([string]::IsNullOrEmpty($entry)){
        $group | ForEach-Object {$sum += $_}
        $group = @(0) * 26
        continue
    }
    foreach($answer in $entry.ToCharArray()){
        $group[([int]$answer)-97] = 1
    }
}
$group | ForEach-Object {$sum += $_}
write-host "Solution is $sum"