$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'

[int]$earliest = $entries[0]
[int[]] $buses = ($entries[1] -split ',') | Where-Object{$_ -ne 'x'} | sort-object
$waits = @()
$null = $buses | ForEach-Object {$waits+= ($_ - ($earliest % $_))} 
$min = 999999999999
$bus = 0
for($i = 0; $i -lt $buses.Count; $i++){
    if($waits[$i] -lt $min){
        $min = $waits[$i] 
        $bus = $buses[$i] 
    }
} 

write-host $buses
write-host $waits
write-host "Bus $bus x $min = $($bus * $min)"
