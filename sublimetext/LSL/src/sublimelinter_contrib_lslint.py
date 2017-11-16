#!/usr/bin/env python
# coding: utf-8

#  Copyright © 2017 XenHat
#  MIT License
#  https://github.com/XenHat/SublimeLinter-contrib-lslint
#
#   Slightly modified version of:
#       https://github.com/XenHat/SublimeLinter-contrib-lslint/blob/f29d19c/linter.py
#       https://github.com/XenHat/SublimeLinter-contrib-lslint/compare/f29d19c...master
#   Changes:
#       - SublimeLinter auto-installer
#       - Reload on package_control.events.post_upgrade
#       - Use mcpp binaries from local subfolder of this package

import os
import platform
import re
import sublime

from collections import namedtuple
from SublimeLinter.lint import Linter, util


PKG_NAME = __package__.split('.')[0]
PKGCTRL_SETTINGS = 'Package Control.sublime-settings'
SUBLINTER_PKG = 'SublimeLinter'


def plugin_loaded():

    try:
        from package_control import events
        pc_settings = sublime.load_settings(PKGCTRL_SETTINGS)
        sublinter_installed = bool(SUBLINTER_PKG in set(
            pc_settings.get('installed_packages', [])))
        if events.install(PKG_NAME) and not sublinter_installed:
            sublime.active_window().run_command('advanced_install_package',
                                                {'packages': SUBLINTER_PKG})
    except ImportError as e:
        print('ERROR: {}'.format(e))
    else:
        was_upgraded = events.post_upgrade(PKG_NAME)
    finally:
        if was_upgraded:
            ensure_reload()


def ensure_reload():

    start_upgrade_msg = 'Do not close Sublime Text, upgrading {}'\
                        .format(PKG_NAME)
    finish_upgrade_msg = '{} upgrade finished.'.format(PKG_NAME)
    active_view = sublime.active_window().active_view()
    active_view.set_status('lsl-upgrade', start_upgrade_msg)

    def erase_status():
        active_view.erase_status('lsl-upgrade')

    def reload():
        sublime.run_command('lsl-reload')
        active_view.set_status('lsl-upgrade', finish_upgrade_msg)
        sublime.set_timeout(erase_status, 2000)

    sublime.set_timeout_async(reload, 5000)


def get_binary_name(binary_name=None):

    if binary_name is None:
        raise

    return binary_name + ('.exe' if os.name == 'nt' else '')


def get_lslint_path(cmd=None):

    if cmd is None:
        return None

    subl_platform = sublime.platform()
    LSLINT_BINARY_NAME = get_binary_name(cmd)

    LSLINT_BINARY_PATH = get_full_path(LSLINT_BINARY_NAME)
    if LSLINT_BINARY_PATH is not None:
        try:
            if os.access(LSLINT_BINARY_PATH, os.F_OK):
                return LSLINT_BINARY_PATH
        except Exception as e:
            print('ERROR: {}'.format(e))

    BASE_PATH = os.path.join(sublime.packages_path(), 'LSL', 'bin', 'lslint')
    if subl_platform == 'windows':
        subl_platform = subl_platform\
            if platform.release() == 'XP'\
            else subl_platform + platform.architecture()[0][:-3]
    try:
        LSLINT_BINARY_PATH = os.path.join(BASE_PATH,
                                          subl_platform,
                                          LSLINT_BINARY_NAME)
        if os.access(LSLINT_BINARY_PATH, os.F_OK):
            return LSLINT_BINARY_PATH
    except Exception as e:
        print('ERROR: {}'.format(e))

    return None


def get_mcpp_path():

    MCPP_BINARY_NAME = get_binary_name('mcpp')
    MCPP_BINARY_PATH = get_full_path(MCPP_BINARY_NAME)

    if MCPP_BINARY_PATH is not None:
        try:
            if os.access(MCPP_BINARY_PATH, os.F_OK):
                return MCPP_BINARY_PATH
        except Exception as e:
            print('ERROR: {}'.format(e))

    BASE_PATH = os.path.join(sublime.packages_path(), 'LSL', 'bin', 'mcpp')
    try:
        subl_plat = sublime.platform()
        if subl_plat == 'windows':
            MCPP_BINARY_PATH = os.path.join(BASE_PATH,
                                            'windows',
                                            MCPP_BINARY_NAME)
        else:
            MCPP_BINARY_PATH = os.path.join(BASE_PATH,
                                            subl_plat,
                                            'bin',
                                            MCPP_BINARY_NAME)
        if os.access(MCPP_BINARY_PATH, os.F_OK):
            return MCPP_BINARY_PATH
    except Exception as e:
        print('ERROR: {}'.format(e))

    return None


def get_full_path(program):

    def is_exe(fpath):
        return os.path.isfile(fpath) and os.access(fpath, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ['PATH'].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

    return None


def get_last_offset(tuples_list, inlined_line):

    result = 0
    line = 0
    filename = '"<stdin>"'

    for this_tuple in tuples_list:
        if int(this_tuple.mcpp_in_line) >= inlined_line - 1:
            break
        line += 1
        result = this_tuple.mcpp_in_line - this_tuple.orig_line + 2
        filename = this_tuple.file

    return (result, filename)


def get_last_stdin(tuples_list, inlined_line):

    result = -1

    for index in range(len(tuples_list)):
        this_tuple = tuples_list[index]
        if int(this_tuple.mcpp_in_line) >= inlined_line - 1:
            break
        if this_tuple.file == '"<stdin>"':
            result = index

    return result


def get_last_line(tuples_list, inlined_line):

    result = 0
    line = 0

    for this_tuple in tuples_list:
        if int(this_tuple.mcpp_in_line) > inlined_line + 2:
            break
        if this_tuple.file != '"<stdin"':
            result = line
        line += 1

    return result


def get_auto_padding(number):

    number = int(number)
    padding = ''
    if (number < 1000):
        padding += ' '
    if (number < 100):
        padding += ' '
    if (number < 10):
        padding += ' '

    return str(number) + padding


class Lslint(Linter):

    syntax = ('lsl')
    executable = 'lslint'
    version_args = '--version'
    version_re = r'(?P<version>\d+\.\d+\.\d+)'
    version_requirement = '>= 1.0.7'
    regex = r'''(?xi)
        (?:(?P<warning> WARN)|(?P<error>ERROR))\:\:\s
        \(\s*(?P<line>\d+),\s*(?P<col>\d+)\)\:\s
        (?P<message>.*)
    '''
    multiline = True
    line_col_base = (1, 1)
    tempfile_suffix = 'lsl'
    error_stream = util.STREAM_BOTH
    selectors = {}
    word_re = None
    # defaults = {}
    inline_settings = None
    inline_overrides = None
    comment_re = None

    @classmethod
    def cmd(self):
        return [self.executable_path, '-i', '-m', '-w', '-z']

    @classmethod
    def which(cls, cmd):
        lslint_binary_path = get_lslint_path(cmd)
        if lslint_binary_path is not None:
            return lslint_binary_path
        return cmd

    @classmethod
    def run(self, cmd, code):
        mcpp_path = get_mcpp_path()
        if mcpp_path is not None:
            opt = '-W0'
            mcpp_output = Linter.communicate(self, (mcpp_path, opt), code)
            lines = mcpp_output.splitlines(False)
            line_number = 0
            OutputTuple = namedtuple('OutputTuple', 'mcpp_in_line\
                                                     orig_line\
                                                     file')
            preproc_bank = []
            for line in lines:
                if line.startswith('#line'):
                    message = line.split(' ')
                    preproc_bank.append(OutputTuple(mcpp_in_line=line_number,
                                                    orig_line=int(message[1]),
                                                    file=message[2]))
                line_number += 1
            code = mcpp_output
        linter_result = Linter.communicate(self, cmd, code)
        if mcpp_path is not None:
            linter_output_lines = linter_result.splitlines(False)
            fixed_output_lines = []
            p = re.compile('^\s*(ERROR|\sWARN)\:\:\s\(\s*(\d*)\.*$')
            for iter_line in linter_output_lines:
                if not iter_line.startswith('TOTAL::'):
                    tokens = iter_line.split(',')
                    match = p.match(tokens[0])
                    number = int(match.group(2))
                    result = get_last_offset(preproc_bank, number)
                    offset = result[0]
                    tokminoff = str(number - int(offset))
                    new_line = re.sub(str(number), tokminoff, iter_line)
                    if result[1] != '"<stdin>"':
                        index = get_last_stdin(preproc_bank, number)
                        new_number = preproc_bank[index + 1].mcpp_in_line + 1
                        offset = get_last_offset(preproc_bank, new_number)[0]
                        tokminoff = str(new_number - int(offset))
                        token_match = match.group(1)
                        new_line = '{0}:: ({1:>3},  1): in file {2}: {3}'\
                            .format(token_match,
                                    tokminoff,
                                    result[1],
                                    new_line)
                    fixed_output_lines.append(new_line)
                    continue
                else:
                    fixed_output_lines.append(iter_line)
            linter_result = ''.join(str(x) + '\n' for x in fixed_output_lines)

        return linter_result
