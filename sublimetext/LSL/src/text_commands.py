#!/usr/bin/env python
# coding: utf-8


import sublime
import sublime_plugin

import os


PKG_NAME = __package__.split('.')[0]
INDENT_STYLE = None
ALLMAN = None
GNU = None
HORSTMANN = None
K_AND_R = None
LISP = None
PICO = None
RATLIFF = None
WHITESMITHS = None


def plugin_loaded():

    global INDENT_STYLE

    INDENT_STYLE = os.path.join(sublime.packages_path(),
                                'User',
                                'LSL_indent_style.tmPreferences')

    STYLES = 'Packages/{}/.sublime/metadata/indent_styles'.format(PKG_NAME)

    global ALLMAN
    global GNU
    global HORSTMANN
    global K_AND_R
    global LISP
    global PICO
    global RATLIFF
    global WHITESMITHS

    ALLMAN = sublime.load_resource('{}/allman.xml'.format(STYLES))
    GNU = sublime.load_resource('{}/gnu.xml'.format(STYLES))
    HORSTMANN = sublime.load_resource('{}/horstmann.xml'.format(STYLES))
    K_AND_R = sublime.load_resource('{}/k_and_r.xml'.format(STYLES))
    LISP = sublime.load_resource('{}/lisp.xml'.format(STYLES))
    PICO = sublime.load_resource('{}/pico.xml'.format(STYLES))
    RATLIFF = sublime.load_resource('{}/ratliff.xml'.format(STYLES))
    WHITESMITHS = sublime.load_resource('{}/whitesmiths.xml'.format(STYLES))

    if not os.path.exists(INDENT_STYLE):
        with open(INDENT_STYLE, mode='w', newline='\n') as file:
            file.write(ALLMAN)


def apply_indent_style(new_indent_style=ALLMAN):

    try:
        with open(INDENT_STYLE, mode='w', newline='\n') as file:
            file.write(new_indent_style)
    except Exception as e:
        print(e)


class LslChangeIndent(sublime_plugin.TextCommand):

    def run(self, edit, indent_style='Allman'):
        if indent_style == 'Allman':
            apply_indent_style(ALLMAN)
        elif indent_style == 'GNU':
            apply_indent_style(GNU)
        elif indent_style == 'Horstmann':
            apply_indent_style(HORSTMANN)
        elif indent_style == 'K & R':
            apply_indent_style(K_AND_R)
        elif indent_style == 'Lisp':
            apply_indent_style(LISP)
        elif indent_style == 'Pico':
            apply_indent_style(PICO)
        elif indent_style == 'Ratliff':
            apply_indent_style(RATLIFF)
        elif indent_style == 'Whitesmiths':
            apply_indent_style(WHITESMITHS)

    def is_visible(self):
        PKG_SYNTAX = 'Packages/{}/.sublime/syntaxes/'.format(PKG_NAME)
        return self.view.settings().get('syntax').startswith(PKG_SYNTAX)
