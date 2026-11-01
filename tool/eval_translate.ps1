$cli = "C:\Users\andre\OneDrive\Documents\AI\_asvab\lfm3\llama\llama-cli.exe"
$model = "C:\Users\andre\OneDrive\Documents\AI\_asvab\lfm3\LFM3-Omni-2B-Q4_K_M.gguf"
$items = (Get-Content build\eval_items.json -Raw -Encoding UTF8 | ConvertFrom-Json).items
$pick = @("wk-002","mk-002","ar-002","gs-002")
$out = "build\eval_translate"
New-Item -ItemType Directory -Force -Path $out | Out-Null
foreach ($lang in @("es","it")) {
  $sys = "You are a careful technical translator for a military aptitude study app. Translate the English explanation into " + $(if ($lang -eq "es") { "Spanish (neutral Latin American)" } else { "Italian" }) + ". Keep the technical terms AFQT, MOS and ASVAB in English. Keep every number exactly. Translate nothing that is an answer option."
  foreach ($id in $pick) {
    $item = $items | Where-Object { $_.id -eq $id }
    if (-not $item) { continue }
    $notes = @()
    for ($i = 0; $i -lt $item.choiceNotes.Count; $i++) { $notes += $item.choiceNotes[$i] }
    $p = "Translate this study explanation. Output only the translation.\nTEXT:\n" + $item.explanation + "\nNOTES:\n" + ($notes -join "\n")
    $file = Join-Path $out ("translate-" + $id + "-" + $lang + ".txt")
    $sw = [Diagnostics.Stopwatch]::StartNew()
    & $cli -m $model --jinja -st -sys $sys -p $p -n 300 -t 4 -c 2048 --temp 0 --no-warmup --no-display-prompt -o $file 2>&1 | Out-Null
    $sw.Stop()
    Write-Host ("[translate {0}] {1} {2}s" -f $lang, $id, [math]::Round($sw.Elapsed.TotalSeconds,1))
  }
}