import os
import plistlib
import shutil
import stat
import sublime
import sublime_plugin

settings = None
SETTINGS_FILE = None
INDENT_STYLE = None
INDENT_STYLE_ALLMAN = None
INDENT_STYLE_K_AND_R = None

def chmod_lslint():
    binaryPath = os.path.join(sublime.packages_path(), 'LSL/bin/lslint/osx/lslint')
    os.chmod(binaryPath, stat.S_IRUSR|stat.S_IWUSR|stat.S_IXUSR|stat.S_IRGRP|stat.S_IXGRP|stat.S_IROTH|stat.S_IXOTH)
    binaryPath = os.path.join(sublime.packages_path(), 'LSL/bin/lslint/linux/lslint')
    os.chmod(binaryPath, stat.S_IRUSR|stat.S_IWUSR|stat.S_IXUSR|stat.S_IRGRP|stat.S_IXGRP|stat.S_IROTH|stat.S_IXOTH)

def set_default_lsl_indent_style():
    srcdir = os.path.join(sublime.packages_path(), 'LSL/metadata')
    destdir = os.path.join(sublime.packages_path(), 'User')
    destfile = os.path.join(destdir, INDENT_STYLE)
    if not os.path.exists(destfile):
        shutil.copyfile(os.path.join(srcdir, INDENT_STYLE_ALLMAN), destfile)

if sublime.version().startswith('2'):
    plugin_loaded()

def plugin_loaded():
    global settings
    global SETTINGS_FILE
    global INDENT_STYLE
    global INDENT_STYLE_ALLMAN
    global INDENT_STYLE_K_AND_R

    SETTINGS_FILE = 'LSL.sublime-settings'
    settings = sublime.load_settings(SETTINGS_FILE)
    INDENT_STYLE = 'LSL_indent_style.tmPreferences'
    INDENT_STYLE_ALLMAN = 'LSL_indent_style.tmPreferences.allman'
    INDENT_STYLE_K_AND_R = 'LSL_indent_style.tmPreferences.k_and_r'

    chmod_lslint()
    set_default_lsl_indent_style()

class ChangeEditorSchemeCommand(sublime_plugin.WindowCommand):
    _is_checked = False

    def __init__(self, view):
        self._is_checked = settings.has('color_scheme')

    def run(self):
        if self._is_checked:
            settings.erase('color_scheme')
            self._is_checked = False
        else:
            settings.set('color_scheme', 'Packages/LSL/other/LSL.hidden-tmTheme')
            self._is_checked = True
        sublime.save_settings(SETTINGS_FILE)

    def is_checked(self):
        return self._is_checked

class ChangeStyleCommand(sublime_plugin.WindowCommand):
    '''
        Changing the indent style is only being done via the
        *.tmPreferences files, not via the LSL.sublime-settings file.
    '''

    _is_checked = False

    def __init__(self, view):
        srcdir = os.path.join(sublime.packages_path(), 'LSL/metadata')
        destdir = os.path.join(sublime.packages_path(), 'User')
        destfile = os.path.join(destdir, INDENT_STYLE)
        if os.path.exists(destfile):
            pl = plistlib.readPlist(destfile)
            self._is_checked = (pl['name'] == 'Indent Style - K & R')

    def run(self):
        srcdir = os.path.join(sublime.packages_path(), 'LSL/metadata')
        destdir = os.path.join(sublime.packages_path(), 'User')
        destfile = os.path.join(destdir, INDENT_STYLE)
        if self._is_checked:
            shutil.copyfile(os.path.join(srcdir, INDENT_STYLE_ALLMAN), destfile)
            self._is_checked = False
        else:
            shutil.copyfile(os.path.join(srcdir, INDENT_STYLE_K_AND_R), destfile)
            self._is_checked = True

    def is_checked(self):
        return self._is_checked
