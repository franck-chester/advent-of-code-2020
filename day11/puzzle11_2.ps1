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

$vmax--
$hmax--

$previousCount = -1
$count = 0
$iterations=0
$timer = [System.Diagnostics.Stopwatch]::StartNew()
$newRows = New-Object 'char[,]' ($vmax+1),($hmax+1)

do{
    $iterations++
    $previousCount = $count

    $count = 0
    for($r = 0; $r -le $vmax; $r++){
        for($c = 0; $c -le $hmax; $c++){
            $o = 0
            $seat = $rows[$r,$c]
            if($seat -eq 'L' -or $seat -eq '#'){
                $found = @('......')*8  # found clockwise from pure north

                $h=$c;$v=$r
                while((--$v) -ge 0){
                    if($rows[$v,$h]  -eq '#'){
                        $found[0] = "# N  : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[0] = "L N  : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((--$v) -ge 0 -and (++$h) -le $hmax){
                    if($rows[$v,$h]  -eq '#'){
                        $found[1] = "# NE : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[1] = "L NE : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((++$h) -le $hmax){
                    if($rows[$v,$h]  -eq '#'){
                        $found[2] = "# E  : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[2] = "L E  : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((++$v) -le $vmax -and (++$h) -le $hmax){
                    if($rows[$v,$h]  -eq '#'){
                        $found[3] = "# SE : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[3] = "L SE : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((++$v) -le $vmax){
                    if($rows[$v,$h]  -eq '#'){
                        $found[4] = "# S  : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[4] = "L S  : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((++$v) -le $vmax -and (--$h) -ge 0){
                    if($rows[$v,$h]  -eq '#'){
                        $found[5] = "# SW : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[5] = "L SW : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((--$h) -ge 0){
                    if($rows[$v,$h]  -eq '#'){
                        $found[6] = "# W  : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[6] = "L W  : $v,$h"; break
                    }
                }
                $h=$c;$v=$r
                while((--$h) -ge 0 -and (--$v) -ge 0){
                    if($rows[$v,$h]  -eq '#'){
                        $found[7] = "# NW : $v,$h"; $o++; break
                    }elseif($rows[$v,$h]  -eq 'L'){
                        $found[7] = "L NW : $v,$h"; break
                    }
                }

                # write-host "($seat) at $r,$c : $o : $($found -join ',')"
            }
            $map[$r,$c] = $o
            if($seat -eq 'L' -and $o -eq 0){ # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
                $newRows[$r,$c] = '#'
                $count++
            }elseif($seat -eq '#' -and $o -ge 5){ # If a seat is occupied (#) and five or more seats adjacent to it are also occupied, the seat becomes empty.
                $newRows[$r,$c] = 'L'
            }elseif($seat -eq '#'){
                $count++
            }
        }

    }
    # $debug = '  0123456789  ->  0123456789  ->  0123456789'
    # $debug += [System.Environment]::NewLine
    # for($r1 = 0; $r1 -le $vmax; $r1++){
    #     $debug += "$r1 :"
    #     for($c1 = 0; $c1 -le $hmax; $c1++){
    #         $debug += ($rows[$r1,$c1])
    #     }
    #     $debug += "  ->  "
    #     for($c1 = 0; $c1 -le $hmax; $c1++){
    #         $debug += $map[$r1,$c1]
    #     }
    #     $debug += "  ->  "
    #     for($c1 = 0; $c1 -le $hmax; $c1++){
    #         $debug += $newRows[$r1,$c1]
    #     }
       
    #     $debug += [System.Environment]::NewLine
    # }
    # write-host $debug
    $rows = $newRows.Clone()
    write-host "-- $iterations iterations : $count occupied seats ---"
}while($count -ne $previousCount)

write-host "$iterations iterations : $count occupied seats - in $($timer.Elapsed)"