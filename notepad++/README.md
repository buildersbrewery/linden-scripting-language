### Syntax

Check these paths first:

* portable: `...\Notepad++\userDefineLang.xml`
* installed: `C:\Users\USERNAME\AppData\Roaming\Notepad++\userDefineLang.xml`

Then:

* If user-defined languages **exist**:
  * Copy and paste the code for [LSL](https://wiki.secondlife.com/wiki/LSL_Portal) from [userDefineLang.xml](userDefineLang.xml).
  * When saving changes to the file make sure the file's encoding is `ANSI/ASCII`!
* If user-defined languages **do not exist**:
  * Open [Notepad++](https://www.notepad-plus-plus.org/) and go to `Language > Define your language > Import` to import a temporary copy of [userDefineLang.xml](userDefineLang.xml) which you can delete when done.
  * :warning: Make sure the encoding of the file you are importing is `ANSI/ASCII`!
* Choose the language via `Language > LSL` from the menu. You should should be able to find it at the bottom of the language menu in the section for user defined languages.

<p align="center">
<img src="https://raw.githubusercontent.com/buildersbrewery/linden-scripting-language/master/notepad%2B%2B/_assets/lsl_syntax.png" alt="LSL Syntax" width="704px" height="382px">
</p>

### Autocompletion

Check these paths first:

* portable: `...\Notepad++\plugins\APIs\lsl.xml`
* installed:
  * 32-bit: `C:\Program Files (x86)\Notepad++\autoCompletion\lsl.xml`
  * 64-bit: `C:\Program Files\Notepad++\autoCompletion\lsl.xml`

Then:

* Copy and paste [`lsl.xml`](plugins/APIs/lsl.xml) to the target path.
* :warning: Make sure the file's encoding is `ANSI/ASCII`!
* Goto `Settings > Preferences > Backup&Autocompletion` and make sure you set `enable auto-completion on each input` to `function completion` and you enable `function parameter hints on input`.

<p align="center">
<img src="https://raw.githubusercontent.com/buildersbrewery/linden-scripting-language/master/notepad%2B%2B/_assets/lsl_autocompletion.gif" alt="LSL Autocompletion" width="640px" height="360px">
</p>

### Snippets via FingerText

Install [FingerText](https://github.com/erinata/FingerText) from the [Notepad++](https://www.notepad-plus-plus.org/) Plugin Manager. Then from the menu go to `Plugins > FingerText > Import Snippets from ftd file` to import the [LSL](https://wiki.secondlife.com/wiki/LSL_Portal) snippets and start working on any file with an `*.lsl`-Extension.

### Code structure

Check these paths first:

* portable: `...\Notepad++\functionList.xml`
* installed: `C:\Users\USERNAME\AppData\Roaming\Notepad++\functionList.xml`

Then:

* Copy the following code snippets to your target path.
  * [`functionList.xml#L10`](functionList.xml#L10)
  * [`functionList.xml#L18-L49`](functionList.xml#L18-L49)
* Read more about the [function list in Notepad++](https://www.notepad-plus-plus.org/features/function-list.html) on its homepage.

<p align="center">
<img src="https://raw.githubusercontent.com/buildersbrewery/linden-scripting-language/master/notepad%2B%2B/_assets/lsl_function_list.png" alt="LSL Function List" width="480px" height="355px">
</p>

### Code folding

Having set up the [EOL](https://en.wikipedia.org/wiki/Newline) incorrectly will mess up the code-folding.

* :warning: Make sure `Edit >> EOL conversion` is set to `Edit >> EOL conversion >> Windows format`.
