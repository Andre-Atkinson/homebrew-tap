# homebrew-tap

Homebrew tap for [eml2msg](https://github.com/Andre-Atkinson/eml_converter) —
convert Outlook-for-Mac `.eml` files into Windows Outlook `.msg` files.

```bash
brew install andre-atkinson/tap/eml2msg
```

The formula builds the self-contained binary from source; the .NET SDK is pulled
in only as a build dependency, and the installed CLI needs nothing at runtime.

After installing, enable the optional Finder **Convert to MSG** Quick Action
with a single command:

```bash
eml2msg-quickaction --from "Your Name <you@example.com>"
```
