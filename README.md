# Ahab

A (very) basic static site generator in PowerShell

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
$ps_script_dir = "<YOUR PATH>\Powershell\scripts"
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

### Using defaultSnippets in your configuration file

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

**Note**: Ahab does not add any HTML when converting your Markdown to HTML. In other words, without default snippets, your site will have no `<!DOCTYPE>`, no `<head></head>`, and so on. It is strongly recommended to use the default snippets to provide this, at a minimum:

```html
<!-- start snippet -->
<!DOCTYPE html>
<html>
    <head>
        <title>YOUR SITE TITLE</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
<body>

<!-- end snippet -->

</body>
</html
```

### In your Markdown

Add the following at any point in your Markdown to include an HTML snippet:

```
<!-- @use <snippetName> -->
```

For example:
```
<!-- @use nav -->
```

Ahab replaces the line with the contents of `snippets/nav.html`.