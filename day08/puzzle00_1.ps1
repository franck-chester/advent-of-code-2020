#$entries = Get-Content './input.txt'
$entries = Get-Content './test.txt'

$i = 0
$acc = 0
do{
    $cmd = $entries[$i].trim() -split ' '
    if($cmd.count -eq 2){
        $cmd+= 1
    }
    else{
        break;
    }
    $entries[$i] = "$($cmd[0]) $($cmd[1]) $($cmd[2])"
    write-host "$i : $($entries[$i])"
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
}while($i -lt $entries.Count)

write-host "Solution is $acc"