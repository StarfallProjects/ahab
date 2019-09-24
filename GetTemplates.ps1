# load user config file
$config = Get-Content -path config.json | ConvertFrom-Json

# set template directory
if($config.templateDir){ 
    $templateDir = $config.templateDir
} else { 
    $templateDir = "templates"
}

# get all templates
$templateList = Get-ChildItem -Path $templateDir -Force -Recurse
$tempTemplateList = @()

# create a "temporary" copy of each template
foreach($t in $templateList) {
    $dest = ($t.BaseName) + 'includes'
    Copy-Item $t -Destination $dest
    $tempTemplateList += $dest
}
# iterate over the temporay copies and swap out the includes for the contents of the files. Note that it DOES NOT HANDLE NESTED INCLUDES YET
foreach($i in $tempTemplateList) {
    $find = Select-String -Path $i -Pattern 'include \w+' -AllMatches -CaseSensitive
    foreach($i in $find) {
        $a,$b = ($i.Matches[0].Value).split(' ')
        $replace1 = 'templates/' + $b
        $replace = Get-Content -Path $replace1
        (Get-Content -Path $i.Path -Raw) -replace $i.Line, $replace | Set-Content $i.Path
    }

}