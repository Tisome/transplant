param(
    [string]$DocRoot = $PSScriptRoot,
    [string]$ContentDir = "具体内容",
    [string]$OutputFile = "论文架构\字数统计表.md"
)

$ErrorActionPreference = "Stop"

function Get-SectionSortKey {
    param([string]$Section)

    if ($Section -match '^(\d+)\.(\d+)$') {
        return ([int]$matches[1] * 1000 + [int]$matches[2])
    }

    return [int]::MaxValue
}

function Get-WordCountRow {
    param([System.IO.FileInfo]$File)

    $text = [System.IO.File]::ReadAllText($File.FullName, [System.Text.Encoding]::UTF8)
    $whitespace = [regex]::Matches($text, '\s').Count
    $nonWhitespace = [regex]::Replace($text, '\s', '').Length
    $tableImageText = 0

    foreach ($line in ($text -split "`r?`n")) {
        $trimmed = $line.Trim()
        if ($trimmed.StartsWith('|') -or $trimmed.StartsWith('![')) {
            $tableImageText += ([regex]::Replace($line, '\s', '').Length)
        }
    }

    $null = $File.BaseName -match '^(\d+)\.(\d+)'
    $section = "$($matches[1]).$($matches[2])"

    [pscustomobject]@{
        Section       = $section
        File          = $File.Name
        Total         = $text.Length
        Whitespace    = $whitespace
        NonWhitespace = $nonWhitespace
        Body          = $nonWhitespace - $tableImageText
        TableImage    = $tableImageText
        Chapter       = [int]$matches[1]
        SortKey       = Get-SectionSortKey -Section $section
    }
}

function Add-StatTable {
    param(
        [System.Collections.Generic.List[string]]$Output,
        [string]$Title,
        [object[]]$Items,
        [string]$RangeLabel
    )

    $Output.Add("## $Title")
    $Output.Add("")
    $Output.Add("| 小节 | 文件名 | 总字符数 | 空白数 | 去空白字符数 | 正文文字量 | 表格/图像文字量 |")
    $Output.Add("| --- | --- | ---: | ---: | ---: | ---: | ---: |")

    foreach ($row in $Items) {
        $Output.Add("| $($row.Section) | ``$($row.File)`` | $($row.Total) | $($row.Whitespace) | $($row.NonWhitespace) | $($row.Body) | $($row.TableImage) |")
    }

    $sumTotal = ($Items | Measure-Object Total -Sum).Sum
    $sumWhitespace = ($Items | Measure-Object Whitespace -Sum).Sum
    $sumNonWhitespace = ($Items | Measure-Object NonWhitespace -Sum).Sum
    $sumBody = ($Items | Measure-Object Body -Sum).Sum
    $sumTableImage = ($Items | Measure-Object TableImage -Sum).Sum

    $Output.Add("| 小计 | ``$RangeLabel`` | $sumTotal | $sumWhitespace | $sumNonWhitespace | $sumBody | $sumTableImage |")
    $Output.Add("")
}

function Get-RangeLabel {
    param(
        [int]$Chapter,
        [object[]]$Items
    )

    $first = ($Items | Sort-Object SortKey | Select-Object -First 1).Section
    $last = ($Items | Sort-Object SortKey | Select-Object -Last 1).Section

    if ($Chapter -eq 0) {
        return "摘要 $first"
    }

    return "第$Chapter章 $first ~ $last"
}

$contentRoot = Join-Path $DocRoot $ContentDir
$outputPath = Join-Path $DocRoot $OutputFile

if (-not (Test-Path -LiteralPath $contentRoot)) {
    throw "内容目录不存在：$contentRoot"
}

$files = Get-ChildItem -Path $contentRoot -Recurse -File -Filter '*.md' |
    Where-Object { $_.BaseName -match '^\d+\.\d+\s' }

$rows = @($files | ForEach-Object { Get-WordCountRow -File $_ } | Sort-Object SortKey)

if ($rows.Count -eq 0) {
    throw "未找到可统计的 Markdown 小节文件：$contentRoot"
}

$output = [System.Collections.Generic.List[string]]::new()
$output.Add("# 字数统计表")
$output.Add("")
$output.Add("本文档用于记录论文各章节草稿的当前字数情况，后续撰写推进时可在此基础上持续更新。")
$output.Add("")
$output.Add("统计口径说明：")
$output.Add("")
$output.Add("- 当前统计对象为 ``guaduation_prj_doc/具体内容`` 下已完成的 Markdown 小节文件，按文件名前缀统计；``2.4.X 误差来源解释_给自己看.md`` 等说明性辅助文件不计入。")
$output.Add("- “总字符数”为 Markdown 原文字符数，包含标题、标点、公式符号、代码反引号、表格、图片链接和换行。")
$output.Add("- “空白数”统计空格、换行、制表等空白字符；“去空白字符数” = 总字符数 - 空白数。")
$output.Add("- “正文文字量” = 去空白字符数 - 表格/图像文字量；“表格/图像文字量”统计 Markdown 表格行（以 ``|`` 开头）和图片行（以 ``![`` 开头）的非空白字符。")
$output.Add("")

foreach ($chapterGroup in ($rows | Group-Object Chapter | Sort-Object { [int]$_.Name })) {
    $chapter = [int]$chapterGroup.Name
    $items = @($chapterGroup.Group | Sort-Object SortKey)
    $title = if ($chapter -eq 0) { "摘要统计" } else { "第$chapter章统计" }
    $rangeLabel = Get-RangeLabel -Chapter $chapter -Items $items
    Add-StatTable -Output $output -Title $title -Items $items -RangeLabel $rangeLabel
}

$firstSection = ($rows | Select-Object -First 1).Section
$lastSection = ($rows | Select-Object -Last 1).Section
$output.Add("## 当前总计")
$output.Add("")
$output.Add("| 统计范围 | 总字符数 | 空白数 | 去空白字符数 | 正文文字量 | 表格/图像文字量 |")
$output.Add("| --- | ---: | ---: | ---: | ---: | ---: |")
$output.Add("| ``$firstSection ~ $lastSection`` | $(($rows | Measure-Object Total -Sum).Sum) | $(($rows | Measure-Object Whitespace -Sum).Sum) | $(($rows | Measure-Object NonWhitespace -Sum).Sum) | $(($rows | Measure-Object Body -Sum).Sum) | $(($rows | Measure-Object TableImage -Sum).Sum) |")

$text = ($output -join "`n") + "`n"
[System.IO.File]::WriteAllText($outputPath, $text, [System.Text.UTF8Encoding]::new($false))

Write-Host "已更新：$outputPath"
Write-Host "统计文件数：$($rows.Count)"
Write-Host "总字符数：$(($rows | Measure-Object Total -Sum).Sum)"
Write-Host "正文文字量：$(($rows | Measure-Object Body -Sum).Sum)"
Write-Host "表格/图像文字量：$(($rows | Measure-Object TableImage -Sum).Sum)"
