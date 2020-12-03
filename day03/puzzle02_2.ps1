[string[]]$entries = Get-Content './input.txt'
#[string[]]$entries = Get-Content './test.txt'


$slopes = (1,1),(3,1),(5,1),(7,1),(1,2)

$total = 1
foreach($slope in $slopes){
    $right = $slope[0]
    $down = $slope[1]
    $firstLine = $true
    $treesCount = 0
    $x = 0
    $y = 0
    $outputFile = "./output_$($right)_$($down).txt"
    foreach($entry in $entries){
        if($firstLine){
            $firstLine = $false
            Set-Content $outputFile $entry
            continue
        }
        $line = $entry.ToCharArray()
        
        $y = ($y+1) % $down
        if($y -eq 0){
            $x = ($x+$right) % $line.Length
            if($line[$x] -eq '#'){
                $treesCount++
                Add-Content $outputFile "$($entry.Substring(0,$x))X$($entry.Substring($x+1))"
            }else{
                Add-Content $outputFile "$($entry.Substring(0,$x))O$($entry.Substring($x+1))"
            }
        }else{
            Add-Content $outputFile $entry
        }
    }
    $total = $total * $treesCount
    write-host "Slope [$right,$down] : Counted $treesCount Xmas trees"
}
write-host "Timed = $total"