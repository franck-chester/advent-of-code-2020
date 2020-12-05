[string[]]$entries = Get-Content './input.txt'
# [string[]]$entries = Get-Content './test.txt'

$maxId = 0
foreach($entry in $entries){
    $bits = $entry.ToCharArray()
    $rangeStart = 0
    $rangeEnd = 127
    for($i = 0; $i -lt 6; $i++){
        $half = [int](($rangeEnd - $rangeStart) / 2)
        if($bits[$i] -eq 'B'){
            $rangeStart += $half
        }
        elseif ($bits[$i] -eq 'F'){
            $rangeEnd -= $half
        }
    }
    if($bits[6] -eq 'B'){
        $row= $rangeEnd
    }
    elseif ($bits[6] -eq 'F'){
        $row= $rangeStart
    }
    $rangeStart = 0
    $rangeEnd = 7
    for($i = 7; $i -lt 9; $i++){
        $half = [int](($rangeEnd - $rangeStart) / 2)
        if($bits[$i] -eq 'R'){
            $rangeStart += $half
        }
        elseif ($bits[$i] -eq 'L'){
            $rangeEnd -= $half
        }

    }
    if($bits[9] -eq 'R'){
        $col= $rangeEnd
    }
    elseif ($bits[9] -eq 'L'){
        $col= $rangeStart
    }
    $id = ($row*8)+$col
    if($id -gt $maxId){
        $maxId = $id
    }
    write-host "$entry : Row $row Column $col ID = $id"
}

write-host "Solution is ID $maxId"