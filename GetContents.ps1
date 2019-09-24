# load user config file
$config = Get-Content -path config.json | ConvertFrom-Json

# set content directory
if($config.contentDir){ 
    $contentDir = $config.contentDir
} else { 
    $contentDir = "contents"
}
# set build directory
if($config.buildDir){ 
    $buildDir = $config.buildDir
} else { 
    $buildDir = "site"
}



# if the build directory already exists, remove it and all its contents
if(test-path $buildDir) {
    Remove-Item -r $buildDir
}
New-Item -Path $buildDir -ItemType "directory"


# get all items in the contents directory
$fileList = Get-ChildItem -Path $contentDir -Force -Recurse
# for each item in the contents directory, check if it is a file or a directory
# if file: convert it to html and output it to the build directory
# if directory: create a new directory of the same name in the build directory
# directory structure is preserved
foreach($f in $fileList)
{
    if (Test-Path -Path $f -PathType Leaf) {
        if ($f.Name -eq "index.md") {
            $destDir = Split-Path ($f -replace $contentDir, $buildDir)
            (ConvertFrom-Markdown $f).Html | Out-File -FilePath $destDir'\index.html'
        } else {
            $destDir = New-Item -Path (Split-Path ($f -replace $contentDir, $buildDir)) -Name (Get-Item $f).BaseName -ItemType "directory"
            (ConvertFrom-Markdown $f).Html | Out-File -FilePath $destDir'\index.html'
        }
    }
    elseif (Test-Path -Path $f -PathType Container) {
         New-Item -Path ($f -replace $contentDir, $buildDir)  -ItemType "directory" 
    }
}

