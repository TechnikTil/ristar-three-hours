$MOD_ROOT = "../.."

# Haxe Formatter
if (Get-Command "haxelib" -errorAction SilentlyContinue)
{
	haxelib --quiet install formatter
	Get-ChildItem $MOD_ROOT -Recurse -Filter *.hxc |
	Foreach-Object {
		# stupid utf8 workaround
		echo $_.FullName
		$content = Get-Content $_.FullName
		$formattedContent = $content | haxelib run formatter --stdin -s $MOD_ROOT
		$Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False
		[System.IO.File]::WriteAllLines($_.FullName, $formattedContent, $Utf8NoBomEncoding)
	}
}
else
{
	echo "Haxe is not installed! Script files cannot be formatted."
}

# JSON Formatter (Prettier)
if (Get-Command "npx" -errorAction SilentlyContinue)
{
	npm --global install prettier
	npx prettier --write "$MOD_ROOT/**/*.json"
}
else
{
	echo "Node.JS is not installed! JSON files cannot be formatted."
}