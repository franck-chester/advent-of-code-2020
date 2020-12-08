$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'


$entries2 = @() + $entries
$fix = 0
$timer = [System.Diagnostics.Stopwatch]::StartNew()
while($fix -lt $entries.Count ){
    $i = 0
    $acc = 0
    # write-host "------- $fix -----------------"

    do{
        $cmd = $entries2[$i].trim() -split ' '
        if($cmd.count -eq 2){
            $cmd+= 1
        }
        else{
            break;
        }
        $entries2[$i] = "$($cmd[0]) $($cmd[1]) $($cmd[2])"
        # $ib = $i
        switch($cmd[0]){
            'nop' {
                $i+= 1 
            }
            'acc' {
                $i++
                $acc+=[int]$cmd[1]
            }
            'jmp'{
                $i+= [int]$cmd[1]
            }
        }
        # write-host "$fix / $ib -> $i | $($entries2[$ib])-> $($entries2[$i])"
        if($i -ge $entries2.Count){
            write-host "Solution is $acc"
        }
    }while($i -lt $entries2.Count)
    if($i -ge $entries2.Count){
        break;
    }
    
    do{
        $fix++
    }
    while(($entries[$fix] -notmatch 'nop|jmp')  -and ($fix -lt $entries.Count) )
    $entries2 = @() + $entries
    $before = $entries[$fix]
    if($entries2[$fix] -match 'nop'){
        $entries2[$fix] = $before -replace 'nop', 'jmp'
    }elseif($entries[$fix] -match 'jmp'){
        $entries2[$fix] = $before -replace 'jmp', 'nop'
    }
    # write-host "$fix : $before becomes $($entries2[$fix])"

}

write-host "Solution is $acc  (took : $($timer.Elapsed))"
