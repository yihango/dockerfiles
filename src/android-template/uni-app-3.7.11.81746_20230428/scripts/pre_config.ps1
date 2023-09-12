# 执行公用脚本
. ".\common.ps1"


# 返回源码根目录
Set-Location ..




# ============== 初始化基础参数 ==============
## 运行示例
### pwsh ./pre_config.ps1 "./dist/build/app" "./android" "app.jks" "bb123456" "key0" "bb123456??" "companyName" "appKey"
## 已编译的uni-app项目路径
# $uniAppDist = 'D:\dev\gct-jgz\gct.foundation.mobile\dist\build\app' # dist目录下的app目录
$uniAppDist = $args[0]
## 安卓模板项目路径
$androidTemplatePath = $args[1]

## 签名文件，从脚本输入参数获取
$signStoreFile = $args[2] # app.jks
$signStorePassword = $args[3] # 密码
$signKeyAlias = $args[4] # key0
$signKeyPassword = $args[5] # 密码

## 公司名称，从脚本输入参数获取
$companyName = $args[6]
## uni-app appkey，从脚本输入参数获取
$appKey = $args[7]

# ============== 解析manifest.json ==============
## 解析 uni-app 的 npm run build:app 编译输出后的 manifest.json 配置文件 
$manifestPath = ($uniAppDist + '/manifest.json')
$manifest = (ReadFile -path $manifestPath ) | ConvertFrom-Json

## 应用基本信息
$appId = $manifest.id
$appName = $manifest.name
$versionName = $manifest.version.name
$versionCode = $manifest.version.code
$applicationId = ('com' + '.' + "$companyName" + '.' + $appName)

## app-plus 的内容
$appPlus = $manifest.plus

### 安卓sdk最低版本
$androidMinSdkVersion = $appPlus.distribute.google.minSdkVersion

### 权限和Feature
$androidPermissionArray = $appPlus.distribute.google.permissions
$androidPermission = ''
foreach ($item in $androidPermissionArray) {
    $androidPermission += $item;
}



# ============== 替换安卓模板项目中的配置 ==============

## 配置文件
### 占位符信息
# Placeholder_AppId ## uni-app appId，脚本变量：$appId
# Placeholder_AppName ## uni-app appName，脚本变量：$appName
# Placeholder_AppKey ## uni-app 开发者应用key，脚本变量：$appKey
# Placeholder_PermissionFeature ## uni-app 安卓权限和Feature，脚本变量：$androidPermission
# Placeholder_ApplicationId ## android application id，脚本变量：$applicationId
# Placeholder_MinSdkVersion ## 安卓最低版本号，脚本变量：$androidMinSdkVersion
# Placeholder_VersionCode ## 版本编码，数字，如： 1，脚本变量：$versionCode
# Placeholder_VersionName ## 版本名称，字符串，如：1.0，脚本变量：$versionName
# Placeholder_StoreFile ## 签名文件的名称，脚本变量：$signStoreFile
# Placeholder_StorePassword ## 签名文件的密码，脚本变量：$signStorePassword
# Placeholder_KeyAlias ## 签名秘钥的键，脚本变量：$signKeyAlias
# Placeholder_KeyPassword ## 签名秘钥的密码，脚本变量：$signKeyPassword


### dcloud_control.xml
$filePath = $androidTemplatePath + "/app/src/main/assets/data/dcloud_control.xml"
ConentReplace -path "$filePath" -oldVal "Placeholder_AppId" -newVal "$appId"

## strings.xml
$filePath = $androidTemplatePath + "/app/src/main/res/values/strings.xml"
ConentReplace -path "$filePath" -oldVal "Placeholder_AppName" -newVal "$appName"

## AndroidManifest.xml
$filePath = $androidTemplatePath + "/app/src/main/AndroidManifest.xml"
ConentReplace -path "$filePath" -oldVal "Placeholder_ApplicationId" -newVal "$applicationId"
ConentReplace -path "$filePath" -oldVal "Placeholder_AppKey" -newVal "$appKey"
ConentReplace -path "$filePath" -oldVal "<!-- Placeholder_PermissionFeature -->" -newVal "$androidPermission"

## build.gradle
$filePath = $androidTemplatePath + "/app/build.gradle"
ConentReplace -path "$filePath" -oldVal "Placeholder_ApplicationId" -newVal "$applicationId"
ConentReplace -path "$filePath" -oldVal '"Placeholder_MinSdkVersion"' -newVal "$androidMinSdkVersion"
ConentReplace -path "$filePath" -oldVal '"Placeholder_VersionCode"' -newVal "$versionCode"
ConentReplace -path "$filePath" -oldVal "Placeholder_VersionName" -newVal "$versionName"
ConentReplace -path "$filePath" -oldVal "Placeholder_StoreFile" -newVal "$signStoreFile"
ConentReplace -path "$filePath" -oldVal "Placeholder_StorePassword" -newVal "$signStorePassword"
ConentReplace -path "$filePath" -oldVal "Placeholder_KeyAlias" -newVal "$signKeyAlias"
ConentReplace -path "$filePath" -oldVal "Placeholder_KeyPassword" -newVal "$signKeyPassword"


## 复制图片资源
$inputDir = ($uniAppDist + "/static/android/res/*")
$outputPath = $androidTemplatePath + "/app/src/main/res"
Copy-Item -Path "$inputDir" -Destination "$outputPath" -Force -Recurse

## 复制打包证书
$inputFilePath = ($uniAppDist + "/static/android/" + "$signStoreFile")
$outputFilePath = $androidTemplatePath + '/app/' + "$signStoreFile"
Copy-Item -Path "$inputFilePath" -Destination "$outputFilePath" -Force

## 将uni-app打包后的资源复制到android项目中
$androidAppsDir = $androidTemplatePath + '/app/src/main/assets/apps'
### 1.删除现有资源
Remove-Item -Path $androidAppsDir -Force -Recurse
### 2.创建新资源目录
$androidAppsWwwDir = $androidAppsDir + '/' + $appId + '/www'
New-Item -Type Directory -Path $androidAppsWwwDir
### 3.复制打包资源到新资源目录
$inputDir = ($uniAppDist + '/*')
$outputPath = $androidAppsWwwDir
Copy-Item -Path "$inputDir" -Destination "$outputPath" -Force -Recurse

# 返回脚本目录
Set-Location "./scripts"