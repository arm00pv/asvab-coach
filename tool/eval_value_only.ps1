# The design question the first run raised: if the app never asks the model
# for a letter, and instead asks for the option TEXT and matches it against
# its own option list, how often does the right answer come out?
param(
    [string]$Model = "C:\Users\andre\OneDrive\Documents\AI\_asvab\lfm3\LFM3-Omni-2B-Q4_K_M.gguf",
    [string]$Cli = "C:\Users\andre\OneDrive\Documents\AI\_asvab\lfm3\llama\llama-cli.exe",
    [string]$ItemsFile = "build\eval_items.json",
    [int]$MaxItems = 16,
    [string]$Out = "build\eval_value"
)
$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
$items = @((Get-Content $ItemsFile -Raw -Encoding UTF8 | ConvertFrom-Json).items | Select-Object -First $MaxItems)
$sys = "You are an ASVAB tutor. Work the question out carefully and honestly. Do not guess."
$rows = @()
foreach ($item in $items) {
    $parts = @()
    $parts += "ASVAB question, " + $item.subtestLabel + ":"
    if ($item.passage) { $parts += $item.passage }
    $parts += $item.stem
    $letters = @("A","B","C","D")
    for ($i = 0; $i -lt $item.choices.Count; $i++) { $parts += $letters[$i] + ") " + $item.choices[$i] }
    $parts += "Work it out step by step, then finish with one final line of exactly this form:"
    $parts += "CHOICE: <the option text copied word for word from the list above>"
    $prompt = $parts -join "\n"
    $file = Join-Path $Out ($item.id + "-value.txt")
    $sw = [Diagnostics.Stopwatch]::StartNew()
    & $Cli -m $Model --jinja -st -sys $sys -p $prompt -n 260 -t 4 -c 2048 --temp 0 --no-warmup --no-display-prompt -o $file 2>&1 | Out-Null
    $sw.Stop()
    $t = Get-Content $file -Raw -Encoding UTF8
    $m = $t.LastIndexOf("Assistant:")
    if ($m -ge 0) { $t = $t.Substring($m + 10) }
    $said = ""
    $cm = [regex]::Match($t, "(?im)^\s*CHOICE\s*:\s*(.+)$")
    if ($cm.Success) { $said = $cm.Groups[1].Value.Trim() }
    # The app does this part: match what was said against its own options.
    $matched = -1
    for ($i = 0; $i -lt $item.choices.Count; $i++) {
        $c = $item.choices[$i].ToLower().Trim().TrimEnd(".")
        $s = $said.ToLower().Trim().TrimEnd(".")
        if ($s -ne "" -and ($s -eq $c -or $s.Contains($c) -or $c.Contains($s))) { $matched = $i; break }
    }
    $rows += [pscustomobject]@{ id = $item.id; key = $item.answerIndex; matched = $matched; said = $said; seconds = [math]::Round($sw.Elapsed.TotalSeconds,1) }
    Write-Host ("[{0}] matched={1} key={2} {3}s :: {4}" -f $item.id, $matched, $item.answerIndex, [math]::Round($sw.Elapsed.TotalSeconds,1), $said)
}
$rows | ConvertTo-Json -Depth 3 | Set-Content (Join-Path $Out "results.json") -Encoding UTF8
"recovered the keyed option: " + @($rows | Where-Object { $_.matched -eq $_.key }).Count + " of " + @($rows).Count
"mean seconds: " + [math]::Round((($rows | Measure-Object seconds -Average).Average),1)