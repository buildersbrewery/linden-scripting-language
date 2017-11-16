### Usage

This is a syntax highlight file for [Nano Editor](http://www.nano-editor.org) and should be placed inside of the `~/.nano/` directory. Then change your nano configuration file `~/.nanorc` to include

```
include "~/.nano/lsl.nanorc"
```

unless you have already moved all your language files to a separate subfolder `nanorc`and added the contents of `~/.nano/nanorc` into `~/.nanorc` via something like

```
cat ~/.nano/nanorc >> ~/.nanorc
```

Toggle syntax highlighting in Nano via <kbd>Esc</kbd><kbd>Y</kbd> and make sure the files have an `*.lsl` extension.
