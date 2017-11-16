#!/usr/bin/env python
# coding: utf-8


import sublime
import sublime_plugin

import json
import mdpopups
import webbrowser


PKG_NAME = __package__.split('.')[0]
SL_WIKI = None
TOOLTIP_DATA = None


def plugin_loaded():

    global SL_WIKI
    global TOOLTIP_DATA

    SL_WIKI = 'https://wiki.secondlife.com/w/index.php?title=Special:Search&go=Go&search='

    try:
        TOOLTIP_FOLDER = 'Packages/{}/.sublime/other/tooltips'.format(PKG_NAME)
        TOOLTIP_DATA = json.loads(sublime.load_resource('{}/constant_float.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/constant_integer.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/constant_integer_boolean.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/constant_rotation.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/constant_string.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/constant_vector.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/control_conditional.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/control_flow.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/control_loop.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/event.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/function.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/keyword.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/state.json'.format(TOOLTIP_FOLDER)))
        TOOLTIP_DATA += json.loads(sublime.load_resource('{}/storage_type.json'.format(TOOLTIP_FOLDER)))
    except Exception as e:
        print(e)


class Lsl(sublime_plugin.EventListener):

    def on_navigate(self, link):
        webbrowser.open_new_tab(link)

    def on_hide(self, view):
        mdpopups.hide_popup(view)

    def on_hover(self, view, point, hover_zone):

        if view.settings().get('is_widget'):
            return

        if not view.settings().get('show_definitions'):
            return

        if hover_zone != sublime.HOVER_TEXT:
            return

        if not view.score_selector(point, 'source.lsl'):
            return

        word = view.substr(view.word(point))

        if not word:
            return

        if TOOLTIP_DATA is None:
            return

        try:
            tooltipRows = []
            for result in TOOLTIP_DATA:
                if result.get('name', None) == word:
                    if 'type' in result or result['name'].startswith('ll'):
                        return_value = '(' + result['type'] + ') ' if 'type' in result else ''
                        if 'params' in result:
                            paramsCache = []
                            for param in result['params']:
                                if 'default' in param:
                                    paramsCache.append('<a href="{}{}">{}</a> {} (Default: {})'.format(SL_WIKI, param['type'], param['type'], param['name'], param['default']))
                                else:
                                    paramsCache.append('<a href="{}{}">{}</a> {}'.format(SL_WIKI, param['type'], param['type'], param['name']))
                            params = '(' + ', '.join(paramsCache) + ')'
                        else:
                            params = ''
                        has_value = ' = {}'.format(str(result['value'])) if 'value' in result else ''
                        tooltipRows.append('{}<a href="{}{}">{}</a>{}{}'.format(return_value, SL_WIKI, result['name'], result['name'], params, has_value))
                    else:
                        tooltipRows.append('<a href="{}{}">{}</a>'.format(SL_WIKI, result['name'], result['name']))
                    if 'description' in result:
                        tooltipRows.append(' ')
                        if 'en_US' in result['description']:
                            tooltipRows.append('{}'.format(result['description']['en_US']))
                    tooltipRows.append(' ')
                    if 'version' in result:
                        tooltipRows.append('* SL server version: {}'.format(result['version']))
                    if 'status' in result:
                        tooltipRows.append('* Status: {}'.format(result['status']))
                    if 'delay' in result:
                        tooltipRows.append('* [Delay](https://wiki.secondlife.com/wiki/LSL_Delay): {}'.format(str(result['delay'])))
                    if 'energy' in result:
                        tooltipRows.append('* Energy: {}'.format(str(result['energy'])))
                    tooltipRows.append(' ')
                    if 'related' in result:
                        tooltipRows.append(' ')
                        tooltipRows.append('---')
                        tooltipRows.append(' ')
                        tooltipRows.append('Related:')
                        tooltipRows.append(' ')
                        if 'constants' in result['related']:
                            tooltipRows.append('* Constants: ' + ', '.join(str('<a href="{}{}">{}</a>'.format(SL_WIKI, related, related)) for related in result['related']['constants']))
                        if 'events' in result['related']:
                            tooltipRows.append('* Events: ' + ', '.join(str('<a href="{}{}">{}</a>'.format(SL_WIKI, related, related)) for related in result['related']['events']))
                        if 'functions' in result['related']:
                            tooltipRows.append('* Functions: ' + ', '.join(str('<a href="{}{}">{}</a>'.format(SL_WIKI, related, related)) for related in result['related']['functions']))
                    if 'usage' in result:
                        tooltipRows.append(' ')
                        tooltipRows.append('---')
                        for usage_example in result['usage']:
                            tooltipRows.append(' ')
                            tooltipRows.append('```lsl')
                            tooltipRows.append('{}'.format(usage_example))
                            tooltipRows.append('```')
                    if 'snippets' in result:
                        tooltipRows.append(' ')
                        tooltipRows.append('---')
                        for snippet in result['snippets']:
                            tooltipRows.append(' ')
                            tooltipRows.append('```lsl')
                            tooltipRows.append('{}'.format(snippet))
                            tooltipRows.append('```')
            if 0 < len(tooltipRows):
                tooltipText = mdpopups.format_frontmatter({'allow_code_wrap': True})
                tooltipText += '\n'
                tooltipText += '\n'.join(tooltipRows)
                mdpopups.show_popup(view,
                                    tooltipText,
                                    flags=(sublime.COOPERATE_WITH_AUTO_COMPLETE | sublime.HIDE_ON_MOUSE_MOVE_AWAY),
                                    location=point,
                                    wrapper_class='lsl',
                                    max_width=640,
                                    max_height=480,
                                    on_navigate=self.on_navigate,
                                    on_hide=self.on_hide(view))
                return
            # mdpopups.color_box for vectors? or mdpopups.tint with BB logo?
        except Exception as e:
            print(e)

        mdpopups.hide_popup(view)
