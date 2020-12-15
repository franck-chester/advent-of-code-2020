# $input = 0,3,6  # expect 436
# $input = 1,3,2  # the 2020th number spoken is 1.
# $input = 2,1,3  # the 2020th number spoken is 10.
# $input = 1,2,3  # the 2020th number spoken is 27.
# $input = 2,3,1  # the 2020th number spoken is 78.
# $input = 3,2,1  # the 2020th number spoken is 438.
$input = 16,12,1,0,15,7,11

$counts = @{}
for($i = 0; $i -lt $input.count; $i++){
    $counts.Add($input[$i],$i+1)
}

$t = $input[-1]
$new = $true
$previous = $input[-1]
for($i = $input.count+1; $i -le 2020; $i++){
    
    if($new){
        $t = 0
        write-host "$i : $previous was new therefore speak $t  : `$counts[$t] = $i"
    }else{
        write-host "$i : $previous was NOT new therefore speak $($counts[$t])-$previous = $($counts[$t] - $previous) and  : `$counts[$($counts[$t] - $previous)] = $i"
        $t = $counts[$t] - $previous
    }

    $new = !$counts.ContainsKey($t)
    if($new){
        $counts.Add($t,$i)
    }else{
        $previous = $counts[$t]
        $counts[$t] = $i
    }
   
}

write-host "Solution is $t"