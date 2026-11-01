# Runs the app's own bank items through a local LFM3-Omni GGUF and records
# what it answered, how long it took, and whether it agreed with the app.
#
# Every item carries the authored key and explanation, so the model's answer
# is marked against the app rather than admired.
param(
    [string]$Model = "C:\Users\andre\OneDrive\Documents\AI\_asvab\lfm3\LFM3-Omni-2B-Q4_K_M.gguf",
    [string]$Cli = "C:\Users\andre\OneDrive\Documents\AI\_asvab\lfm3\llama\llama-cli.exe",
    # Not "$Items": a typed parameter pins the type to the variable name, so a
    # later "$items = ..." would be coerced to a string and the loop below would
    # run once over the text of the whole list.
    [string]$ItemsFile = "build\eval_items.json",
    [string[]]$Languages = @("en"),
    [int]$MaxItems = 16,
    [int]$Predict = 240,
    [int]$Threads = 4,
    [string]$Out = "build\eval",
    # Pass one language per flag from the shell: "-Languages es,it" arrives as
    # the single string "es,it", and the lookup below then returns nothing.
    # "LetterFirst" asks for the option then the working; "ReasonFirst" asks for
    # the working then a final ANSWER: line. The two are compared because the
    # letter-first form produced a model that reasoned its way to the right
    # value and then printed the wrong option.
    [ValidateSet("LetterFirst", "ReasonFirst")][string]$Variant = "LetterFirst"
)

$ErrorActionPreference = "Stop"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
$data = Get-Content $ItemsFile -Raw -Encoding UTF8 | ConvertFrom-Json
$itemList = @($data.items | Select-Object -First $MaxItems)

$sys = @{
    en = "You are an ASVAB study coach. Answer like a patient instructor: give the correct option first, show the working in two or three sentences, then one short line for each wrong option saying why it is wrong. Keep it under 130 words."
    es = "Eres un entrenador de estudio del ASVAB. Responde en espanol como un instructor paciente: primero la opcion correcta, luego el razonamiento en dos o tres frases y por ultimo una linea corta por cada opcion incorrecta explicando por que lo es. Menos de 130 palabras."
    it = "Sei un coach di studio ASVAB. Rispondi in italiano come un istruttore paziente: prima l opzione corretta, poi il ragionamento in due o tre frasi, infine una riga breve per ogni opzione sbagliata spiegando perche e sbagliata. Meno di 130 parole."
}
$ask = @{
    en = "Answer with the letter and the option text, then why the others are wrong."
    es = "Responde con la letra y el texto de la opcion, y luego por que las otras son incorrectas. Todo en espanol."
    it = "Rispondi con la lettera e il testo dell opzione, poi perche le altre sono sbagliate. Tutto in italiano."
}
$askReason = @{
    en = "Work it out step by step, then finish with one final line exactly of the form ANSWER: B"
    es = "Resuelvelo paso a paso y termina con una linea final exactamente con la forma RESPUESTA: B. Todo en espanol."
    it = "Risolvilo passo per passo e termina con una riga finale esattamente nella forma RISPOSTA: B. Tutto in italiano."
}

function Build-Prompt($item, $lang) {
    $parts = @()
    $parts += "ASVAB question, " + $item.subtestLabel + ":"
    if ($item.passage) { $parts += $item.passage }
    $parts += $item.stem
    $letters = @("A","B","C","D")
    # One option per line. Squashed onto one line the model lost track of which
    # letter held which option and answered with the right value under the
    # wrong letter; that is a harness defect, not a model one.
    for ($i = 0; $i -lt $item.choices.Count; $i++) {
        $parts += $letters[$i] + ") " + $item.choices[$i]
    }
    $parts += $(if ($Variant -eq "ReasonFirst") { $askReason[$lang] } else { $ask[$lang] })
    # Joined with a literal backslash-n, not a real newline: a native argument
    # carrying newlines is split by the Windows command line and llama-cli takes
    # the second line as an unknown flag. It expands the escapes itself.
    return ($parts -join "\n")
}

$results = @()
foreach ($lang in $Languages) {
    foreach ($item in $itemList) {
        $outFile = Join-Path $Out ($item.id + "-" + $lang + ".txt")
        $prompt = Build-Prompt $item $lang
        $clock = [Diagnostics.Stopwatch]::StartNew()
        & $Cli -m $Model --jinja -st -sys $sys[$lang] -p $prompt -n $Predict -t $Threads -c 2048 --temp 0 --seed 42 --no-warmup --no-display-prompt -o $outFile 2>&1 | Out-Null
        $clock.Stop()
        $answer = ""
        if (Test-Path $outFile) { $answer = (Get-Content $outFile -Raw -Encoding UTF8) }
        # The output file holds the whole conversation, prompt included, so the
        # prompt's own "A) ..." line was being scored as the model's answer.
        # Only what follows the last Assistant: marker is the reply.
        $reply = $answer
        $mark = $answer.LastIndexOf("Assistant:")
        if ($mark -ge 0) { $reply = $answer.Substring($mark + 10) }
        $body = $reply
        $first = ($reply -split "\r?\n" | Where-Object { $_.Trim() -ne "" } | Select-Object -First 1)
        # The letter the model opened with, and the option text it wrote beside
        # it. Both are recorded because the two can disagree, and a tutor that
        # names the right value under the wrong letter is worse than one that
        # is simply wrong.
        if ($Variant -eq "ReasonFirst") {
            $pickMatch = [regex]::Match($reply, "(?m)^\s*(?:ANSWER|RESPUESTA|RISPOSTA)\s*:?\s*\(?([A-D])\b")
            $pick = $pickMatch.Groups[1].Value
            $pickText = ""
        } else {
            $pickMatch = [regex]::Match($reply, "(?m)^\s*([A-D])\)\s*(.*)$")
            $pick = $pickMatch.Groups[1].Value
            $pickText = $pickMatch.Groups[2].Value.Trim()
        }
        $correctLetter = @("A","B","C","D")[$item.answerIndex]
        $keyText = $item.choices[$item.answerIndex]
        $textAgrees = $false
        if ($pickText -eq "" -and $pick -ne "") { $pickText = "letter only" }
        if ($pickText -ne "" -and $pickText -ne "letter only") {
            $textAgrees = $pickText.ToLower().Contains($keyText.ToLower()) -or $keyText.ToLower().Contains($pickText.ToLower())
        }

        $results += [pscustomobject]@{
            id = $item.id
            subtest = $item.subtest
            lang = $lang
            picked = $pick
            pickedText = $pickText
            key = $correctLetter
            keyText = $keyText
            correct = ($pick -eq $correctLetter)
            textAgrees = $textAgrees
            seconds = [math]::Round($clock.Elapsed.TotalSeconds, 1)
            words = ($body -split "\s+" | Where-Object { $_ -ne "" }).Count
            firstLine = $first
            file = $outFile
        }
        Write-Host ("[{0}] {1} picked={2} key={3} {4}s" -f $lang, $item.id, $pick, $correctLetter, [math]::Round($clock.Elapsed.TotalSeconds,1))
    }
}

$results | ConvertTo-Json -Depth 4 | Set-Content (Join-Path $Out ("results-" + ($Languages -join "-") + "-" + $Variant + ".json")) -Encoding UTF8
"letter matches the key: " + @($results | Where-Object correct).Count + " of " + @($results).Count
"option text matches the key: " + @($results | Where-Object textAgrees).Count + " of " + @($results).Count
"mean seconds per answer: " + [math]::Round(($results | Measure-Object seconds -Average).Average, 1)