#!/usr/bin/env python
# coding: utf-8


import builtins
import functools
import importlib
import sys
import types
import os

from contextlib import contextmanager

import sublime
import sublime_plugin


PKG_NAME = __package__.split('.')[0]


def reload_plugin():
    main = importlib.import_module(PKG_NAME + '.' + PKG_NAME)
    modules = {
        name: module for name, module in sys.modules.items()
        if name.startswith(PKG_NAME + '.')
    }
    try:
        reload_modules(main, modules)
    except Exception as e:
        reload_modules(main, modules, perform_reload=False)
        raise
    finally:
        ensure_loaded(main, modules)


def ensure_loaded(main, modules):
    missing_modules = {
        name: module for name, module in modules.items()
        if name not in sys.modules
    }
    if missing_modules:
        for name, module in missing_modules:
            sys.modules[name] = modules
        main = sys.modules[PKG_NAME + '.' + PKG_NAME]
        sublime_plugin.reload_plugin(main.__name__)


def reload_modules(main, modules, perform_reload=True):

    if perform_reload:
        sublime_plugin.unload_module(main)
    module_names = [main.__name__] + sorted(
        name for name in modules
        if name != main.__name__
    )
    loaded_modules = dict(sys.modules)
    for name in loaded_modules:
        if name in modules:
            del sys.modules[name]

    stack_meter = StackMeter()

    @FilteringImportHook.when(condition=lambda name: name in modules)
    def module_reloader(name):

        module = modules[name]
        sys.modules[name] = module
        if perform_reload:
            with stack_meter:
                try:
                    return module.__loader__.load_module(name)
                except Exception as e:
                    if name in sys.modules:
                        del sys.modules[name]
                    raise
        else:
            return module

    with intercepting_imports(module_reloader), \
            importing_fromlist_aggressively(modules):
        sublime_plugin.reload_plugin(main.__name__)
        for name in module_names:
            importlib.import_module(name)


@contextmanager
def importing_fromlist_aggressively(modules):

    orig___import__ = builtins.__import__

    @functools.wraps(orig___import__)
    def __import__(name, globals=None, locals=None, fromlist=(), level=0):
        module = orig___import__(name, globals, locals, fromlist, level)
        if fromlist and module.__name__ in modules:
            if '*' in fromlist:
                fromlist = list(fromlist)
                fromlist.remove('*')
                fromlist.extend(getattr(module, '__all__', []))
            for x in fromlist:
                if isinstance(getattr(module, x, None), types.ModuleType):
                    from_name = '{}.{}'.format(module.__name__, x)
                    if from_name in modules:
                        importlib.import_module(from_name)
        return module

    builtins.__import__ = __import__

    try:
        yield
    finally:
        builtins.__import__ = orig___import__


@contextmanager
def intercepting_imports(hook):

    sys.meta_path.insert(0, hook)

    try:
        yield hook
    finally:
        if hook in sys.meta_path:
            sys.meta_path.remove(hook)


class StackMeter():

    def __init__(self, depth=0):
        super().__init__()
        self.depth = depth

    def __enter__(self):
        depth = self.depth
        self.depth += 1
        return depth

    def __exit__(self, *exec_info):
        self.depth -= 1


class FilteringImportHook:

    def __init__(self, condition, load_module):
        super().__init__()
        self.condition = condition
        self.load_module = load_module

    @classmethod
    def when(cls, condition):
        return lambda load_module: cls(condition, load_module)

    def find_module(self, name, path=None):
        if self.condition(name):
            return self


class LslReloadListener(sublime_plugin.EventListener):

    def on_post_save(self, view):
        file_path = view.file_name()
        if not file_path.endswith('.py'):
            return
        file_base = os.path.basename(file_path)
        if os.sep == '\\':
            file_path = file_path.replace('\\', '/')
        file_res = 'Packages' + file_path[
            file_path.find('/' + PKG_NAME)
        ]
        if file_res in sublime.find_resources(file_base):
            reload_plugin()


class LslReloadCommand(sublime_plugin.ApplicationCommand):

    def run(self):
        reload_plugin()
