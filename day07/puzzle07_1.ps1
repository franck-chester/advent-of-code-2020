$entries = Get-Content './input.txt'
#$entries = Get-Content './test1.txt'
#$entries = Get-Content './test2.txt'

function reachBottom1($colours, $depth) {
    foreach ($colour in $colours) {
        if ($colour.content -eq 'shiny gold') {
            return $true
        }
        elseif(reachBottom1 $containers[$colour.content]){
            return $true
        }
    }
    return $false
}
function reachBottom2([object[]]$content, $size) {
    $count = 1
    foreach ($colour in $content) {
        if ($colour.content -eq 'nothing') {
            return 1
        }
        $count += $colour.size * (reachBottom2 $containers[$colour.content] $colour.size)
    }
    return $count
}

$containers = @{}
foreach ($entry in $entries) {
    $regex = '([a-z]*\s[a-z]*) bags contain( (\d+) (?:([a-z]+ [a-z]*) bag(?:s)?[,\.])| no other bags.)'
    for ($i = 0; $i -lt 5; $i++) {
        $regex += '( (\d+) ([a-z]+ [a-z]*) bag(?:s)?[,\.])?'
    }
    $null = $entry -match $regex
    $container = $Matches[1]
    if (!$containers.ContainsKey($container)) {
        $containers.Add($container, @())
    }
    if ($matches[2] -eq ' no other bags.') {
        $containers[$container] += @{
            'content' = 'nothing'
            'size'    = 0
        }
    }
    else {
        for ($i = 4; $i -lt 15; $i += 3) {
            if ($matches.Count -ge $i) {
                $containers[$container] += @{
                    'content' = $matches[$i]
                    'size'    = [int]($matches[$i - 1])
                }
            }
        }
    }
}
$count = 0
foreach($color in $containers.Keys){
    if(reachBottom1($containers[$color])){
        $count++
    }
}
write-host "Part 1 is $count"
write-host "Part 2 is $((reachBottom2 $containers['shiny gold'] 1) -1 )"