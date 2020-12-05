$E = cat './input.txt'
$S = @()
$E|%{
 $b=(($_ -replace 'F|L','0') -replace 'B|R','1')
 $r=[Convert]::ToInt16($b.substring(0,7),2)
 $c=[Convert]::ToInt16($b.substring(7,3),2)
 $S+=($r*8)+$c
}
$S = $S | Sort-Object
"1:$($S[-1])"
$S|%{
 if($_ -2 -eq $p){"2:$($_ -1)"}
 $p=$_
}