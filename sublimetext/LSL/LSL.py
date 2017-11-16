#!/usr/bin/env python
# coding: utf-8


import sublime

MIN_SUBL_BUILD = 3124


if MIN_SUBL_BUILD <= int(sublime.version()):
    from .src import *
else:
    sublime.error_message("LSL: Requires Sublime Text Build {} or later.".format(MIN_SUBL_BUILD))
