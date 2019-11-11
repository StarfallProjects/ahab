# Ahab

A (very) basic static site generator in PowerShell

There is a simple example site available [here](https://github.com/StarfallProjects/ahab-example-site).

## Install

Ahab requires PowerShell Core 6.0 minimum.

1. Install [Powershell Core 6.2.3](https://github.com/PowerShell/PowerShell/releases/tag/v6.2.3)
2. Download `ahab.ps1`

## Run

Option one:

1. Place `ahab.ps1` in the root directory of your site
2. Run from PowerShell with `./ahab.ps1`

Option two:

1. Place `ahab.ps1` in your PowerShell scripts directory (usually `/Powershell/scripts`)
2. Configure your PowerShell profile:

```ps
# set scripts directory to your scripts folder
$ps_script_dir = "<your path>\Powershell\scripts"
# alias the ahab command
New-Alias ahab $ps_script_dir/ahab.ps1
```

3. Run `ahab.ps1` from any directory with the `ahab` command.

## Project structure

Ahab requires a simple project structure:
- A `contents` directory, containing the markdown contents of your site. The structure of the pages and folders in `contents` will be the structure of the site.
- A `snippets` directory, containing any HTML you want to use (for example, a `footer.html` that you include on every page)
- An `assets` directory, containing your CSS, JavaScript, image files and other assets.
- A `site` directory for the build output (Ahab creates this during build)

You can configure the names of these directories in the `config.json`.

Ahab treats `index.md` files as the homepage files of their directory. Other files are output as `filename\index.html`.

Example:
```
This structure:

Project
|
+-- contents
|  |
|  +-- index.md
|  +-- aFile.md
|  +-- myFolder
|      |
|      +-- index.md
|      +-- anotherFile.md

Becomes:

Project
|
+-- site
|  |
|  +-- index.html
|  +-- aFile
|      |
|      +-- index.html
|  +-- myFolder
|      |
|      +-- index.html
|      +-- anotherFile
|          |
|          +-- index.html
```

This affects linking between pages. When writing links in your Markdown files, use `@BaseURL` and the path to the file from the root of your site:
```
This is my example link to the file named [anotherFile](@BaseURL/myFolder/anotherFile) in the diagram above.

This is my [example link](@BaseURL/myFolder) to the index.md file in myFolder in the diagrame above.
```

## Configuration

Create a `config.json` in the root of your project.

Required:
- Provide a base URL. This is the root URL of your site.

Optional:
- Configure the directories for your contents, snippets, assets and output.
- Set default snippets.


Example:
```json
{
    "baseURL": "https://example.com",
    "contentDir": "src",
    "buildDir": "dist",
    "assetsDir": "bitsnbobs",
    "snippetDir": "partials",
    "defaultSnippets": {
        "start": "head",
        "end": "footer"
    }
}
```

If you do not use the optional configuration settings, Ahab uses the following defaults:
```json
{
    "contentDir": "contents",
    "buildDir": "site",
    "assetsDir": "assets",
    "snippetDir": "snippets"
}
```


## Using snippets

Snippets are pieces of HTML that you can include in your site's pages. There are two ways of including snippets.

### With defaultSnippets in your configuration file

Use the `defaultSnippets` configuration option to include snippets that you want on every page of your site. You can add one to the start of each page, and one to the end.

Example:

Given the following `config.json`:
```json
{
    "defaultSnippets": {
        "start": "head",
        "end": "footer"
    }
}
```

Ahab takes `snippets/head.html` and adds the contents at the start of every page of your site, then takes `snippets/footer.html` and adds the contents at the end of every page of your site.

> **Warning**: Ahab does not add any HTML when converting your Markdown to HTML. In other words, without default snippets, your site will have no `<!DOCTYPE>`, no `<head></head>`, and so on. It is strongly recommended to use the default snippets to provide this, at a minimum:

```html
<!-- start snippet, for example head.html -->
<!DOCTYPE html>
<html>
    <head>
        <title>YOUR SITE TITLE</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
<body>

<!-- end snippet, for example footer.html -->

</body>
</html>
```

### With @use Markdown

Add the following at any point in your Markdown to include an HTML snippet:

```
{{ use <snippetName> }}
```

For example:
```
{{ use nav }}
```

Ahab replaces the line with the contents of `snippets/nav.html`.

## Including assets

Your CSS, JavaScript, images and any other asset files are stored in the `assets` directory.

To include them in your snippets or Markdown files, use `@BaseURL` followed by the path to the asset.

For example, adding a CSS link to your `head.html` snippet:
```html
<!DOCTYPE html>
<html>
    <head>
        <title>YOUR SITE TITLE</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" type="text/css" href="@BaseURL/assets/styles.css" />
    </head>
<body>
```

