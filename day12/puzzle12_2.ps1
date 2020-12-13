$entries = Get-Content './input.txt'
#$entries = Get-Content './test.txt'

$regex = '([NSEWLRF])(\d+)'
$wx = 10
$wy = 1
$x = 0
$y = 0

foreach ($entry in $entries) {
    $null = $entry -match $regex
    $action = $matches[1]
    $value = [int]$matches[2]
    switch ($action) {
        'N' { $wy += $value }
        'S' { $wy -= $value }
        'E' { $wx += $value }
        'W' { $wx -= $value }
        'R' {
            $count = [int]($value / 90)
            
            for ($i = 0; $i -lt $count; $i++) {
                $wx1 = $wx; $wy1 = $wy
                $wx = $wy1 
                $wy = - $wx1 
            }
        }
        'L' {
            $count = [int]($value / 90)

            for ($i = 0; $i -lt $count; $i++) {
                $wx1 = $wx; $wy1 = $wy
                $wx = - $wy1
                $wy = $wx1 
            }
        }
        'F' {
            $x += ($wx * $value)
            $y += ($wy * $value)
        }
    }
    write-host "$entry : ship $x,$y and waypoint $wx (east/west),$wy (north/south)"
}
$x = [Math]::Abs($x)
$y = [Math]::Abs($y)
write-host "Solution is $x + $y = $($x+$y)"