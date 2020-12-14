$entries = Get-Content './input.txt'
#$entries = Get-Content './test2.txt'

[hashtable]$mem = @{}
foreach ($entry in $entries) {
    if ($entry -match 'mask = ([X10]*)$') {
        $mask = ($matches[1]).ToCharArray()
        $xcount = 0;
        $mask | ForEach-Object { if ($_ -eq 'X') { $xcount++ } }
    }
    elseif ($entry -match 'mem\[(\d+)\] = (\d+)\s*$') {
        $value = [int]$matches[2]
       
        $maskedAddr = ([Convert]::ToString($matches[1], 2).padLeft(36, '0').ToCharArray())
        $maskedAddresses = New-Object 'int[,]' 1, 36
        for ($i = 0 ; $i -lt 36; $i++) {
            if ($maskedAddr[$i] -eq '1') { $maskedAddresses[0, $i] = 1 }else { $maskedAddresses[0, $i] = 0 }
        }

        # $debug += " from: "
        # $debug += [System.Environment]::NewLine
        # for ($j = 0; $j -lt $maskedAddresses.GetLength(0); $j++) {
        #     for ($k = 0; $k -lt 36; $k++) {
        #         $debug += "$($maskedAddresses[$j,$k])"
        #     }
        #     $debug += [System.Environment]::NewLine
        # }

        for ($i = 0; $i -lt 36; $i++) {
            switch ($mask[$i]) {
                'X' {
                    # copy all variations fo far
                    $midPoint = $maskedAddresses.GetLength(0)
                    $new = New-Object 'int[,]' ($midPoint*2), 36
                    [array]::copy($maskedAddresses, 0, $new, 0, $midPoint*36)
                    [array]::copy($maskedAddresses, 0, $new, $midPoint*36,$midPoint*36)

                    $maskedAddresses = $new
                    
                    for ($j = 0; $j -lt $midpoint; $j++) {
                        $maskedAddresses[$j, $i] = 1
                    }
                    for ($j = $midpoint; $j -lt $maskedAddresses.GetLength(0); $j++) {
                        $maskedAddresses[$j, $i] = 0
                    }
                    break
                }
                '1' {
                    for ($j = 0; $j -lt $maskedAddresses.GetLength(0); $j++) {
                        $maskedAddresses[$j, $i] = 1
                    }
                }
            }
        }
        
        # $debug += ' to: '
        # $debug += [System.Environment]::NewLine
        # for ($j = 0; $j -lt $maskedAddresses.GetLength(0); $j++) {
        #     for ($k = 0; $k -lt 36; $k++) {
        #         #write-host "`$maskedAddresses[$j,$k]"
        #         $debug += "$($maskedAddresses[$j,$k])"
        #     }
        #     $debug += [System.Environment]::NewLine
        # }
        # write-host "$entry : "
        # write-host "$($mask -join '')  <- mask"
        # write-host "$($maskedAddr -join '')  <- $($matches[1])"
        # write-host $debug

        for ($j = 0; $j -lt $maskedAddresses.GetLength(0); $j++) {
            [int64]$addr = 0
            $debug = ''
            for ($i = 0; $i -lt 36; $i++) {
                $addr += $maskedAddresses[$j, $i] * [Math]::Pow(2, (35 - $i))
                $debug = "$($maskedAddresses[$j,$i])$debug" 
            }

            if(!$mem.ContainsKey($addr)){$mem.Add($addr,0)}
            $mem[$addr] = $value 
            # write-host "$entry :  `$mem[$addr] = $debug = $value "
        }
    }

}
$sum = ($mem.Values  | Measure-Object -Sum).Sum
write-host "Solution is $sum"