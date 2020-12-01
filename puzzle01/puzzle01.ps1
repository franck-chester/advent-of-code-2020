[int[]]$entries = Get-Content './input.txt'
# [int[]]$entries = Get-Content './test.txt'
$mappedEntries = @{}
foreach($entry in $entries){
    if($mappedEntries.ContainsKey($entry)){
        write-host "Solution is $entry + $($mappedEntries[$entry]) = $($entry + $mappedEntries[$entry]) and $entry x $($mappedEntries[$entry]) = $($entry * $mappedEntries[$entry])"
        exit
    }
    else{
        $mappedEntries.Add(2020 - $entry, $entry)
    }
}