#!/usr/bin/env python
# coding: utf-8


import sublime
import sublime_plugin


PKG_NAME = __package__.split('.')[0]
settings = {}
SETTINGS_FILE = None


def status_msg(msg):
    sublime.status_message('{}: {}'.format(PKG_NAME, msg))


def load_settings(reload=False):

    global settings
    global SETTINGS_FILE

    SETTINGS_FILE = '{}.sublime-settings'.format(PKG_NAME)

    try:
        settings = sublime.load_settings(SETTINGS_FILE)
        settings.clear_on_change('reload')
        settings.add_on_change('reload', lambda: load_settings(reload=True))
    except Exception as e:
        print(e)

    if reload:
        status_msg('Reloaded settings on change.')


def plugin_loaded():

    load_settings()


class LslChangeSchemeCommand(sublime_plugin.WindowCommand):

    _is_checked = False

    def __init__(self, view):
        self._is_checked = settings.has('color_scheme')

    def run(self):
        global settings
        if self._is_checked:
            settings.erase('color_scheme')
        else:
            settings.set('color_scheme', 'Packages/LSL/.sublime/color-schemes/LSL.hidden-color-scheme')
        sublime.save_settings(SETTINGS_FILE)
        self._is_checked = not self._is_checked

    def is_checked(self):
        return self._is_checked
