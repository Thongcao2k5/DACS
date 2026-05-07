$utf8 = [System.Text.Encoding]::UTF8
$unicode = [System.Text.Encoding]::Unicode
$content = [System.IO.File]::ReadAllText("final_insert.sql", $utf8)
[System.IO.File]::WriteAllText("final_insert_fix.sql", $content, $unicode)
