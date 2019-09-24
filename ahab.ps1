##########################
# All the functions up top
##########################

# Assemble a single page from a markdown source and any snippets
function buildPage($source, $destDir) {
    # create new file
    $output = New-Item -Path $destDir'\index.html'
    # convert markdown source to html and add to new file
    (ConvertFrom-Markdown $source).Html | Add-Content -Path $output
    # search new file for any @use statements
    $find = Select-String -Path $output -Pattern '<!-- @use \w+ -->' -AllMatches -CaseSensitive
    # if file contains @use statements, proceed to add snippets
    if($null -ne $find) {
        # add each snippet in turn
        foreach($use in $find) {
            # get the snippet name
            $a,$b = ($use.Matches[0].Value).split(' ')[1,2]
            # get the path and contents of the snippet
            $templatePath = 'templates/' + $b + '.html'
            $template = Get-Content -Path $templatePath
            # replace the @use line in the new file with the contents of the snippet
            (Get-Content -Path $use.Path) -replace $use.Line, $template | Set-Content -Path $output
        }
    }
    
}

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
# if file: build the page
# if directory: create a new directory of the same name in the build directory
# directory structure is preserved
foreach($f in $fileList)
{
    if (Test-Path -Path $f -PathType Leaf) {
        if ($f.Name -eq "index.md") {
            $destDir = Split-Path ($f -replace $contentDir, $buildDir)
            buildPage $f $destDir
        } else {
            $destDir = New-Item -Path (Split-Path ($f -replace $contentDir, $buildDir)) -Name (Get-Item $f).BaseName -ItemType "directory"
            buildPage $f $destDir
        }
    }
    elseif (Test-Path -Path $f -PathType Container) {
         New-Item -Path ($f -replace $contentDir, $buildDir)  -ItemType "directory" 
    }
}



