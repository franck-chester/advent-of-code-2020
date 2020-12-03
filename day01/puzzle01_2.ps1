# find three numbers in your expense report that meet the same criteria.
# Using the above example again, the three entries that sum to 2020 are 979, 366, and 675. Multiplying them together produces the answer, 241861950.

[int[]]$entries = Get-Content './input.txt'
#[int[]]$entries = Get-Content './test.txt'

foreach ($entry1 in $entries) {
    foreach ($entry2 in $entries) {
        foreach ($entry3 in $entries) {
            if ($entry1 + $entry2 + $entry3 -eq 2020) {
                write-host "Solution is $entry1 + $entry2 + $entry3 = $($entry1 + $entry2 + $entry3) and $entry1 x $entry2 x $entry3 = $($entry1 * $entry2 * $entry3)"
                exit
            }
        }
    }
}