import os
import plistlib
import re
import shutil
import stat
import sublime
import sublime_plugin
import sys
from time import time
import webbrowser
import xml.etree.ElementTree as etree

import mdpopups

Pref = None
settings = {}
kwdb = None
SETTINGS_FILE = None
INDENT_STYLE = None
INDENT_STYLE_ALLMAN = None
INDENT_STYLE_K_AND_R = None

if sublime.version().startswith('2'):
    plugin_loaded()

def plugin_loaded():
    global Pref
    global settings
    global kwdb
    global SETTINGS_FILE
    global INDENT_STYLE
    global INDENT_STYLE_ALLMAN
    global INDENT_STYLE_K_AND_R

    SETTINGS_FILE = 'LSL.sublime-settings'
    INDENT_STYLE = 'LSL_indent_style.tmPreferences'
    INDENT_STYLE_ALLMAN = 'LSL_indent_style.tmPreferences.allman'
    INDENT_STYLE_K_AND_R = 'LSL_indent_style.tmPreferences.k_and_r'

    class Pref:
        def load(self):
            Pref.next_run_time = time() + 0.0009 * 400

    try:
        settings = sublime.load_settings(SETTINGS_FILE)
    except Exception as e:
        print(e)

    Pref = Pref()
    Pref.load()

    settings.add_on_change('reload', lambda:Pref.load())

    binaryPath = os.path.join(sublime.packages_path(), 'LSL', 'bin', 'lslint', 'osx', 'lslint')
    os.chmod(binaryPath, stat.S_IRUSR|stat.S_IWUSR|stat.S_IXUSR|stat.S_IRGRP|stat.S_IXGRP|stat.S_IROTH|stat.S_IXOTH)
    binaryPath = os.path.join(sublime.packages_path(), 'LSL', 'bin', 'lslint', 'linux', 'lslint')
    os.chmod(binaryPath, stat.S_IRUSR|stat.S_IWUSR|stat.S_IXUSR|stat.S_IRGRP|stat.S_IXGRP|stat.S_IROTH|stat.S_IXOTH)

    srcdir = os.path.join(sublime.packages_path(), 'LSL', 'metadata')
    destdir = os.path.join(sublime.packages_path(), 'User')
    destfile = os.path.join(destdir, INDENT_STYLE)
    if not os.path.exists(destfile):
        shutil.copyfile(os.path.join(srcdir, INDENT_STYLE_ALLMAN), destfile)

    kwdb_elementtree = etree.parse(os.path.join(sublime.packages_path(), 'LSL', 'other', 'kwdb', 'kwdb.xml'))
    kwdb = kwdb_elementtree.getroot()

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

    _is_checked = False

    def __init__(self, view):
        srcdir = os.path.join(sublime.packages_path(), 'LSL', 'metadata')
        destdir = os.path.join(sublime.packages_path(), 'User')
        destfile = os.path.join(destdir, INDENT_STYLE)
        if os.path.exists(destfile):
            pl = plistlib.readPlist(destfile)
            self._is_checked = (pl['name'] == 'Indent Style - K & R')

    def run(self):
        srcdir = os.path.join(sublime.packages_path(), 'LSL', 'metadata')
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

class LslCommand(sublime_plugin.EventListener):

    global cache

    region_row = []
    lang = None

    def on_activated(self, view):
        if 3070 <= int(sublime.version()):
            self.run(view)

    def on_modified(self, view):
        if 3070 <= int(sublime.version()):
            self.run(view)

    def on_selection_modified(self, view):
        if 3070 <= int(sublime.version()):
            self.run(view)

    def run(self, view):
        timeout_ms = 400
        Pref.next_run_time = time() + 0.0009 * timeout_ms
        sublime.set_timeout(lambda:self.run_after_delay(view), timeout_ms)

    def run_after_delay(self, view):
        if Pref.next_run_time <= time():
            self.show_tooltip(view)

    def show_tooltip(self, view):
        global region_row, lang

        view_settings = view.settings()
        if view_settings.get('is_widget'):
            return

        for region in view.sel():
            region_row, region_col = view.rowcol(region.begin())

            if region_row != view_settings.get('tooltips_row', -1):
                view_settings.set('tooltips_row', region_row)
            else:
                return

            lang = self.getLang(view)
            if lang != 'LSL':
                return

            if kwdb:
                word = view.substr(view.word(view.sel()[0]))
                try:
                    for result in kwdb.findall(".//*[@name='" + word + "']"):
                        if result.tag != 'param':
                            tooltipRows = []
                            if result.tag == 'function' or result.tag == 'constant':
                                tooltipRows.append('## (%s) <a href="https://wiki.secondlife.com/w/index.php?title=Special:Search&go=Go&search=%s">%s</a>' % (result.get('type', 'void'), result.get('name'), result.get('name')))
                            else:
                                tooltipRows.append('## <a href="https://wiki.secondlife.com/w/index.php?title=Special:Search&go=Go&search=%s">%s</a>' % (result.get('name'), result.get('name')))
                            if result.tag == 'constant':
                                tooltipRows.append(' ')
                                tooltipRows.append('**Value**: %s' % str(result.get('value')))
                            if result.get('status', None) is not None and result.get('status', 'normal') != 'normal':
                                tooltipRows.append(' ')
                                tooltipRows.append('<body style="color:#fff;background-color:#820124;">**Status**: %s</body>' % result.get('status', 'normal'))
                            if result.get('delay', None) is not None:
                                tooltipRows.append(' ')
                                tooltipRows.append('**Delay**: %s' % str(result.get('delay')))
                            if result.get('energy', None) is not None:
                                tooltipRows.append(' ')
                                tooltipRows.append('**Energy**: %s' % str(result.get('energy')))
                            if result.tag == 'function' or result.tag == 'event':
                                if result.findall('./param') != []:
                                    tooltipRows.append(' ')
                                    tooltipRows.append('### Parameters')
                                    for param in result.iter('param'):
                                        tooltipRows.append('* (%s) **%s**' % (param.get('type'), param.get('name')))
                            if result.find('description').text is not None:
                                tooltipRows.append(' ')
                                tooltipRows.append('### Description')
                                tooltipRows.append(' ')
                                tooltipRows.append('%s' % result.find('description').text.strip())
#                           add version info
#                           add grid info by splitting spaces and re-joining as markdown list

                            mdpopups.show_popup(view, '\n'.join(tooltipRows),
                                flags=sublime.COOPERATE_WITH_AUTO_COMPLETE,
                                location=-1, max_width=600, max_height=350,
                                on_navigate=self.on_navigate
                            )
                            return
                except Exception as e:
                    print(e)

            mdpopups.hide_popup(view)

    def getLang(self, view):
        scope = view.scope_name(view.sel()[0].b)
        return re.match('.*/(.*?).(?:tmLanguage|sublime-syntax)', view.settings().get('syntax')).group(1)

    def on_navigate(self, link):
        webbrowser.open_new_tab(link)
