# homebrew-tap

Homebrew tap for [eml2msg](https://github.com/Andre-Atkinson/eml_converter) —
convert Outlook-for-Mac `.eml` files into Windows Outlook `.msg` files.

```bash
brew install andre-atkinson/tap/eml2msg
```

The formula builds the self-contained binary from source; the .NET SDK is pulled
in only as a build dependency, and the installed CLI needs nothing at runtime.

After installing, enable the optional Finder **Convert to MSG** Quick Action —
`brew info eml2msg` prints the exact command, or:

```bash
python3 "$(brew --prefix eml2msg)/libexec/install_quickaction.py" \
  --binary "$(brew --prefix eml2msg)/bin/eml2msg" --from "Your Name <you@example.com>"
```
