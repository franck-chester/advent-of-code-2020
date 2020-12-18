[string[]] $entries = Get-Content './input.txt'
#[string[]] $entries = Get-Content './test.txt'

$halfCubeWidth = 13
$cubeWidth = 27
$cube = New-Object 'bool[,,,]' $cubeWidth, $cubeWidth, $cubeWidth, $cubeWidth

$a = 0
if ($entries.count % 2 -eq 0) {
    $halfWidth = [int]($entries.count / 2)
}
else { 
    $halfWidth = [int](($entries.count - 1)) / 2 
}

for ($i = 0; $i -lt $entries.count; $i++) {
    [char[]] $row = $entries[$i].ToCharArray()
    $y = $i + $halfCubeWidth - $halfWidth
    for ($j = 0; $j -lt $row.count; $j++) {
        $x = $j + $halfCubeWidth - $halfWidth
        $cube[$x, $y, $halfCubeWidth, $halfCubeWidth] = ($row[$j] -eq '#')
        if ($row[$j] -eq '#') { $a++ }
    }
}


$cube2 = New-Object 'bool[,,,]' $cubeWidth, $cubeWidth, $cubeWidth, $cubeWidth
# display 0 $cube
[int64]$allActive = $a
$timer = [System.Diagnostics.Stopwatch]::StartNew()

for ($c = 0; $c -lt 6; $c++) {

    [array]::copy($cube, 0, $cube2, 0, $cubeWidth * $cubeWidth * $cubeWidth * $cubeWidth)
    write-host "====== after $c cycles : $allActive active ===== took : $($timer.Elapsed)"
    $allActive = 0
    for ($x = 0; $x -lt $cubeWidth; $x++) {
        for ($y = 0; $y -lt $cubeWidth; $y++) {
            for ($z = 0; $z -lt $cubeWidth; $z++) {
                for ($w = 0; $w -lt $cubeWidth; $w++) {
                    # count active cubes around us
                    $a = 0
                    for ($x1 = -1; $x1 -lt 2; $x1++) {
                        if (($x + $x1 -eq -1) -or ($x + $x1 -eq $cubeWidth)) { continue }
                        for ($y1 = -1; $y1 -lt 2; $y1++) {
                            if (($y + $y1 -eq -1) -or ($y + $y1 -eq $cubeWidth)) { continue }
                            for ($z1 = -1; $z1 -lt 2; $z1++) {
                                if (($z + $z1 -eq -1) -or ($z + $z1 -eq $cubeWidth)) { continue }
                                for ($w1 = -1; $w1 -lt 2; $w1++) {
                                    if (($w + $w1 -eq -1) -or ($w + $w1 -eq $cubeWidth)) { continue }
                                    if (($x1 -eq 0) -and ($y1 -eq 0) -and ($z1 -eq 0)-and ($w1 -eq 0)) { continue }
                                    if ($cube2[($x + $x1), ($y + $y1), ($z + $z1), ($w + $w1)]) {
                                        $a++
                                    }
                                    if ($a -ge 4) { break }
                                }
                            }
                            if ($a -ge 4) { break }
                        }
                        if ($a -ge 4) { break }
                    }

                    # write-host "cube2[$x, $y, $z] : $($cube2[$x, $y, $z]) : $a active cubes around, $allActive in total"

                    if ($cube2[$x, $y, $z, $w]) {
                        if (($a -eq 2) -or ($a -eq 3)) {
                            $cube[$x, $y, $z, $w] = $true
                            $allActive++
                            
                        }
                        else {
                            $cube[$x, $y, $z, $w] = $false
                        }
                    }
                    else {
                        if ($a -eq 3) {
                            $cube[$x, $y, $z, $w] = $true
                            $allActive++
                        }
                        else {
                            $cube[$x, $y, $z, $w] = $false
                        }
                    }
                }
            }
        }
    }
}
write-host "====== after $c cycles : $allActive active ====="
