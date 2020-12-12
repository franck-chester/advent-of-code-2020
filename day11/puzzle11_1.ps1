[string[]] $entries = Get-Content './input.txt'
#[string[]] $entries = Get-Content './test.txt'
$vmax = $entries.count
$hmax = $entries[0].Length
$rows = New-Object 'char[,]' $vmax,$hmax
$map = New-Object 'int[,]' $vmax,$hmax
for($i=0; $i -lt $entries.count; $i++){
    [char[]] $x = $entries[$i].ToCharArray()
    for($j=0; $j -lt $x.count; $j++){
        $rows[$i,$j] = $x[$j]
    }
}

$previousCount = -1
$count = 0
$iterations=0
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$newRows = New-Object 'char[,]' $vmax,$hmax

do{
    $iterations++
    $previousCount = $count

    $count = 0
    for($r = 0; $r -lt $vmax; $r++){
        if($r -eq 0){$v1 = 0}else{$v1 = $r-1}
        if($r -eq ($vmax-1)){$v2 = ($vmax-1)}else{$v2 = $r+1}
        
        for($c = 0; $c -lt $hmax; $c++){
            if($c -eq 0){$h1 = 0}else{$h1 = $c-1}
            if($c -eq $hmax-1){$h2 = $hmax-1}else{$h2 = $c+1}
            $o = 0
            for($h = $h1; $h -le $h2; $h++){
                for($v = $v1; $v -le $v2; $v++){
                    if($c-eq $h -and $r -eq $v){
                        continue # skip the actual seat
                    }
                    if($rows[$v,$h] -eq '#'){
                        $o++
                    }
                }
            }
            $map[$r,$c] = $o
            if($rows[$r,$c] -eq 'L' -and $o -eq 0){
                $newRows[$r,$c] = '#'
                $count++
            }elseif($rows[$r,$c] -eq '#' -and $o -ge 4){
                $newRows[$r,$c] = 'L'
            }elseif($rows[$r,$c] -eq '#'){
                $count++
            }
        }

    }
    # $debug = ''
    # for($r1 = 0; $r1 -lt $vmax; $r1++){
    #     for($c1 = 0; $c1 -lt $hmax; $c1++){
    #         $debug += $rows[$r1,$c1]
    #     }
    #     $debug += "  ->  "
    #     for($c1 = 0; $c1 -lt $hmax; $c1++){
    #         $debug += $map[$r1,$c1]
    #     }
    #     $debug += "  ->  "
    #     for($c1 = 0; $c1 -lt $hmax; $c1++){
    #         $debug += $newRows[$r1,$c1]
    #     }
       
    #     $debug += [System.Environment]::NewLine
    # }
    # write-host $debug
    $rows = $newRows.Clone()
    write-host "-- $iterations iterations : $count occupied seats ---"
}while($count -ne $previousCount)

write-host "$iterations iterations : $count occupied seats - in $($timer.Elapsed)"