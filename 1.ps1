# git-set-filetime.ps1
if (-not (Test-Path ".git")) {
    Write-Host "Error: 当前目录不是 git 仓库根目录"
    exit 1
}

Get-ChildItem -Path content -Recurse -File | ForEach-Object {
    $fullPath = $_.FullName

    # 使用 --literal-pathname 处理特殊字符文件名
    $timestampStr = git log -1 --format="%ct" -- "$fullPath"

    if ($timestampStr) {
        $timestamp = [int]$timestampStr
        $date = (Get-Date "1970-01-01 00:00:00").AddSeconds($timestamp).ToLocalTime()

        # 清除只读并修改时间
        $_.IsReadOnly = $false
        $_.LastWriteTime = $date

        Write-Host "Updated $fullPath -> $date"
    } else {
        Write-Host "Skipped $fullPath (not tracked by git)"
    }
}

Write-Host "All content files updated."
