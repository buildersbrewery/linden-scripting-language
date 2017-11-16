### Setup

Copy [lsl-mode.el](lsl-mode.el) to directory `~/emacs`, start emacs and compile the file via <kbd>M</kbd><kbd>-</kbd><kbd>x</kbd> to create `lsl-mode.elc`.

* Put these lines into your [Emacs](http://www.gnu.org/software/emacs/) init file `.emacs`:

```lisp
(add-to-list 'load-path "~/.emacs.d/") ;; create the dir if it doesn't exist
(autoload 'lsl-mode "lsl-mode" "Load lsl-mode for editing Linden Scripting Language." t)
(add-to-list 'auto-mode-alist '("\\.lsl\\'" . lsl-mode))
```

* Restart [Emacs](http://www.gnu.org/software/emacs/).

### Snippets

* Download YASnippet from [github.com/capitaomorte/yasnippet](https://github.com/capitaomorte/yasnippet).
