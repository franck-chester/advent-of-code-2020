$entries = Get-Content './input.txt'
# $entries = Get-Content './test.txt'

$regex = '([NSEWLRF])(\d+)'
$x = 0
$y = 0
$directions = @('E','S','W','N')
$d = 0
foreach($entry in $entries){
    $null = $entry -match $regex
    $action = $matches[1]
    $value = [int]$matches[2]
    switch($action){
        'N'{$y+=$value}
        'S'{$y-=$value}
        'E'{$x+=$value}
        'W'{$x-=$value}
        'L'{$d= ($d -  [int]($value/90)) % 4}
        'R'{$d= ($d +  [int]($value/90)) % 4}
        'F'{
            switch($directions[$d]){
                'N'{$y+=$value}
                'S'{$y-=$value}
                'E'{$x+=$value}
                'W'{$x-=$value}
            }
        }
    }
}
$x = [Math]::Abs($x)
$y = [Math]::Abs($y)
write-host "Solution is $x + $y = $($x+$y)"