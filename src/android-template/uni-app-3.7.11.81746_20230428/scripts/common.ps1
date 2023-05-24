# 获取env
function GetEnv {
    param (
        $Name
    )
    return [Environment]::GetEnvironmentVariable("$Name")
}

# 读取文件 utf8
function ReadFile {
    param (
        $path
    )
    return Get-Content -Path $path -Encoding UTF8
}

# 写入文件 utf8
function WriteFile {
    param (
        $path,
        $content
    )
    Set-Content -Path $path  -Value $content -Encoding UTF8 -Force
}


# 替换文本内容
function ConentReplace {
    param (
        [string]$path,
        [string]$oldVal,
        [string]$newVal
    )
    if (Test-Path $path) {    
        (Get-Content $path) -Replace $oldVal, $newVal | Set-Content $path
    }
}

# 更新xml文件的选择路径的InnerText
function UpdateXmlInnerText {
    param (
        [string]$path,
        [string]$xPath,
        [string]$innerText
    )
    if (Test-Path $path) {
        [xml]$content = Get-Content $path
        $content.SelectNodes($xPath)[0].set_InnerText($innerText)
        $content.Save($path)
    }
}