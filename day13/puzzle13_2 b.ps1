$entries = Get-Content './input.txt'
# $entries = Get-Content './test.txt'

for($e = 1; $e -lt $entries.Count; $e++){
    
    $buses = $entries[$e] -split ','


    # see https://www.red-gate.com/simple-talk/dotnet/net-framework/high-performance-powershell-linq/
    [Func[long, long , long]] $lcm = {
        param([long]$a, [long]$b)
        $g = gcd $a $b
        $r = [Math]::Abs($a * $b) / $g
        write-host "lcm($a,$b) = ($a x $b) / gcd($a, $b) = $($a*$b)/$g = $r"
        return $r
    }
    function gcd([long]$a, [long]$b){
        if($b -eq 0){
            $r = $a
        }else{
            $r = gcd $b ($a % $b)
        }
        write-host "gcd ($a,$b) = $r"
        return $r
    }

    [long[]]$waits = @(,$buses[0])
    for($i = 1; $i -lt $buses.Count; $i++){
        if($buses[$i] -ne 'x'){
            #$waits+= [int]$buses[$i] + $i + $buses[0]
            $waits+= [int]$buses[$i] + $i
        }
    } 

    
    $lowestCommonMultiplicator = [System.Linq.Enumerable]::Aggregate([long[]]$waits, $lcm)
    $mods = @()
    for($i = 0; $i -lt $waits.Count; $i++){
        $mods+= $lowestCommonMultiplicator % $waits[$i] 
    } 
    write-host "$e : $($entries[$e]) -> $($waits -join ',')  -> $lowestCommonMultiplicator -> $($mods -join ',')"


}

write-host "Expecting:"
write-host "7,13,x,x,59,x,31,19 : 1068781"
write-host "17,x,13,19 : 3417"
write-host "67,7,59,61 : 754018"
write-host "67,x,7,59,61 : 779210"
write-host "67,7,x,59,61 : 1261476"
write-host "1789,37,47,1889 : 1202161486"