Copy-Item "www\exams_data.js" "www\exams_data.bak.js" -Force
$subjMap = @{
  "civics"    = "សីលធម៌-ពលរដ្ឋវិទ្យា"
  "earth"     = "ភូមិវិទ្យា/ផែនដី"
  "english"   = "ភាសាអង់គ្លេស"
  "french"    = "ភាសាបារាំង"
  "geography" = "ភូមិវិទ្យា"
  "history"   = "ប្រវត្តិវិទ្យា"
  "khmer"     = "អក្សរសាស្ត្រខ្មែរ"
  "math"      = "គណិតវិទ្យា"
}
$items = @()
Get-ChildItem "www\pdfs" -Directory | Sort-Object Name | ForEach-Object {
  $yr = $_.Name
  Get-ChildItem $_.FullName -Filter "*.pdf" | Sort-Object Name | ForEach-Object {
    $base = $_.BaseName.ToLower()
    $sName = if ($subjMap.ContainsKey($base)) { $subjMap[$base] } else { $base }
    $items += [PSCustomObject]@{
      id       = "$base-$yr"
      subj     = $sName
      tag      = "ផ្លូវការ $yr"
      type     = "past"
      title    = "វិញ្ញាសា និងអត្រាកំណែ $sName ($yr)"
      question = "វិញ្ញាសាប្រឡងសញ្ញាបត្រមធ្យមសិក្សាទុតិយភូមិ"
      answer   = ""
      pdf      = "pdfs/$yr/$($_.Name)"
    }
  }
}
$json = $items | ConvertTo-Json -Depth 3
$content = "window.EXAM_PAGES_DIR = `"pages/`";`r`nwindow.EXAM_ARCHIVE = $json;`r`n"
Set-Content -Path "www\exams_data.js" -Value $content -Encoding UTF8
Write-Host "Done! Total PDFs linked:" $items.Count
