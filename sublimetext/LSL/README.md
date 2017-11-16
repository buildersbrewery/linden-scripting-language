[![License](https://img.shields.io/github/license/buildersbrewery/linden-scripting-language.svg?style=flat-square)](https://github.com/buildersbrewery/linden-scripting-language/blob/master/LICENSE)
[![Requires Sublime Text Build 3149 or later](https://img.shields.io/badge/Sublime%20Text-Build%203149%20or%20later-brightgreen.svg?style=flat-square)](https://www.sublimetext.com)
[![Latest tag](https://img.shields.io/github/tag/buildersbrewery/linden-scripting-language.svg?style=flat-square)](https://github.com/buildersbrewery/linden-scripting-language/tags)

<p align="center">

[Installation](#installation) • [Linting](#linting) • [Tooltips](#tooltips) • [Color Scheme](#color-scheme) • [Disclaimer](#disclaimer)

</p>

---

# [Linden Scripting Language (LSL)](https://wiki.secondlife.com/wiki/LSL_Portal) support for [Sublime Text](https://www.sublimetext.com)

## Requirements

* [Sublime Text](https://www.sublimetext.com) Build 3149 or later
  * [![Sublime Text 3 (stable)](https://img.shields.io/badge/Sublime%20Text%203-%28stable%29-lightgrey.svg?style=flat-square)](https://www.sublimetext.com/3)
  * [![Sublime Text 3 (dev)](https://img.shields.io/badge/Sublime%20Text%203-%28dev%29-lightgrey.svg?style=flat-square)](https://www.sublimetext.com/3dev)
* [Package Control](https://packagecontrol.io)
  * From a freshly installed `Sublime Text 3` choose `Tools > Install Package Control ...` from the main menu.
* [SublimeLinter 3](https://github.com/sublimelinter/sublimelinter3)
  * Open the command palette via `Tools > Command palette` from the main menu
  * Select `Package Control: Install Package`
  * Select `SublimeLinter`

## Installation

* open **Sublime Text 3**
* choose `Preferences > Browse packages`from the menu
* copy & paste this folder to make it a `LSL` subfolder to the Sublime Text 3 Packages directory.

## Linting

Linting with support for the [Firestorm preprocessor](http://wiki.phoenixviewer.com/fs_preprocessor) is achieved by using code from the following third-party projects:

* [`Makopo/lslint`](https://github.com/Makopo/lslint)
* [`XenHat/SublimeLinter-contrib-lslint`](https://github.com/XenHat/SublimeLinter-contrib-lslint)
* [`mcpp`](http://mcpp.sourceforge.net/download.html)

which are included in this package.

## Tooltips

[![Requires Sublime Text Build 3124 or later](https://img.shields.io/badge/Sublime%20Text-Build%203124%20or%20later-brightgreen.svg?style=flat-square)](https://www.sublimetext.com)

Support for `LSL` syntax highlighting in snippets and usage examples in tooltips.

## Color Scheme

[![Requires Sublime Text Build 3149 or later](https://img.shields.io/badge/Sublime%20Text-Build%203149%20or%20later-brightgreen.svg?style=flat-square)](https://www.sublimetext.com)

You can toggle using a LindenLab-viewer-like Color Scheme by selecting `Preferences > Package Settings > LSL > Use 'LindenLab Viewer' color scheme` from the main menu.

The file [`.sublime/color-schemes/LSL.hidden-color-scheme`](.sublime/color-schemes/LSL.hidden-color-scheme) from this package can be overridden by a similar file with the following path: `Packages/User/LSL.hidden-color-scheme`.

## Disclaimer

```text
Second Life® and the Linden Scripting Language are trademarks of
Linden Research, Inc. The Builder's Brewery is neither affiliated with nor
sponsored by Linden Research.
```
