import os
import plistlib
import sublime
import sublime_plugin
from time import time
import webbrowser
import xml.etree.ElementTree as etree

Pref = None
settings = {}
KWDB = None
SETTINGS_FILE = None
INDENT_STYLE = None
INDENT_STYLE_ALLMAN = None
INDENT_STYLE_K_AND_R = None

if sublime.version().startswith('2'):
    plugin_loaded()

if 3070 <= int(sublime.version()):
    import mdpopups

def plugin_loaded():

    global Pref
    global settings
    global KWDB
    global SETTINGS_FILE
    global INDENT_STYLE
    global INDENT_STYLE_ALLMAN
    global INDENT_STYLE_K_AND_R

    SETTINGS_FILE = 'LSL.sublime-settings'
    INDENT_STYLE = os.path.join(sublime.packages_path(), 'User', 'LSL_indent_style.tmPreferences')
    INDENT_STYLE_ALLMAN = sublime.load_resource('Packages/LSL/metadata/LSL_indent_style.tmPreferences.allman')
    INDENT_STYLE_K_AND_R = sublime.load_resource('Packages/LSL/metadata/LSL_indent_style.tmPreferences.k_and_r')

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

    if not os.path.exists(INDENT_STYLE):
        with open(INDENT_STYLE, mode='w', newline='\n') as file:
            file.write(INDENT_STYLE_ALLMAN)

    kwdbAsString = sublime.load_resource('Packages/LSL/other/kwdb/kwdb.xml')
    KWDB = etree.fromstring(kwdbAsString)

class ChangeEditorSchemeCommand(sublime_plugin.WindowCommand):

    _is_checked = False

    def __init__(self, view):

        self._is_checked = settings.has('color_scheme')

    def run(self):

        if self._is_checked:
            settings.erase('color_scheme')
        else:
            settings.set('color_scheme', 'Packages/LSL/other/LSL.hidden-tmTheme')
        self._is_checked = not self._is_checked

        sublime.save_settings(SETTINGS_FILE)

    def is_checked(self):

        return self._is_checked

class ChangeStyleCommand(sublime_plugin.WindowCommand):

    _is_checked = False

    def __init__(self, view):

        if os.path.exists(INDENT_STYLE):
            pl = plistlib.readPlist(INDENT_STYLE)
            self._is_checked = (pl['name'] == 'Indent Style - K & R')

    def run(self):

        if self._is_checked:
            with open(INDENT_STYLE, mode='w', newline='\n') as file:
                file.write(INDENT_STYLE_ALLMAN)
        else:
            with open(INDENT_STYLE, mode='w', newline='\n') as file:
                file.write(INDENT_STYLE_K_AND_R)

        self._is_checked = not self._is_checked

    def is_checked(self):

        return self._is_checked

class LslCommand(sublime_plugin.EventListener):

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

        region = view.sel()[0].a
        scope  = view.scope_name(region)

        validScopes = []
        validScopes.append('source.lsl')

        validScope_Found = False

        for validScope in validScopes:
            if sublime.score_selector(scope, validScope) != 0:
                validScope_Found = True

        if validScope_Found == False:
            return

        viewSettings = view.settings()

        if viewSettings.get('is_widget'):
            return

        if not KWDB:
            return

        word = view.substr(view.word(region))
        try:
            tooltipRows = []
            for result in KWDB.findall(".//*[@name='" + word + "']"):
                if result.tag == 'param':
                    continue
                if result.tag == 'function' or result.tag == 'constant':
                    tooltipRows.append('### (%s) <a href="https://wiki.secondlife.com/w/index.php?title=Special:Search&go=Go&search=%s">%s</a>' % (result.get('type', 'void'), result.get('name'), result.get('name')))
                else:
                    tooltipRows.append('### <a href="https://wiki.secondlife.com/w/index.php?title=Special:Search&go=Go&search=%s">%s</a>' % (result.get('name'), result.get('name')))
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
                        tooltipRows.append('#### Parameters')
                        for param in result.iter('param'):
                            tooltipRows.append('* (%s) **%s**' % (param.get('type'), param.get('name')))
                if result.find('description').text is not None:
                    tooltipRows.append(' ')
                    tooltipRows.append('#### Description')
                    tooltipRows.append(' ')
                    tooltipRows.append('%s' % result.find('description').text.strip())
#               add version info
#               add grid info by splitting spaces and re-joining as markdown list
#          seperate entries by horizontal line

            if len(tooltipRows) == 0:
                return

            mdpopups.show_popup(view, '\n'.join(tooltipRows),
                flags=sublime.COOPERATE_WITH_AUTO_COMPLETE,
                location=-1, max_width=600, max_height=350,
                on_navigate=self.on_navigate
            )
            return

        except Exception as e:
            print(e)

        mdpopups.hide_popup(view)

    def on_navigate(self, link):

        webbrowser.open_new_tab(link)
