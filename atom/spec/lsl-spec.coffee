describe 'LSL grammar', ->
  grammar = null
  [completionDelay, editor, editorView] = []

  beforeEach ->
    atom.config.set('autocomplete-plus.enableAutoActivation', true)
    completionDelay = 100
    atom.config.set('autocomplete-plus.autoActivationDelay', completionDelay)
    completionDelay += 100 # Rendering delay

    workspaceElement = atom.views.getView(atom.workspace)
    jasmine.attachToDOM(workspaceElement)

    snippetsMainModule = null
    autocompleteManager = null

    waitsForPromise ->
      Promise.all [
        atom.packages.activatePackage('language-lsl')

        atom.packages.activatePackage('autocomplete-plus').then (pack) ->
          autocompleteManager = pack.mainModule.getAutocompleteManager()

        atom.packages.activatePackage('snippets').then ({mainModule}) ->
          snippetsMainModule = mainModule
          snippetsMainModule.loaded = false
      ]

    waitsFor 'snippets provider to be registered', 1000, ->
      autocompleteManager?.providerManager.providers.length > 0

    waitsFor 'all snippets to load', 3000, ->
      snippetsMainModule.loaded

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.lsl')

  it 'parses the grammar', ->
    expect(grammar).toBeDefined()
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.lsl'

  describe 'when autocomplete-plus is enabled', ->
    it 'shows autocompletions when there are snippets available', ->
      runs ->
        expect(editorView.querySelector('.autocomplete-plus')).not.toExist()

        editor.moveToBottom()
        editor.insertText('D')
        editor.insertText('o')

        advanceClock(completionDelay)

      waitsFor 'autocomplete view to appear', 1000, ->
        editorView.querySelector('.autocomplete-plus span.word')

      runs ->
        expect(editorView.querySelector('.autocomplete-plus span.word')).toHaveText('do')
        expect(editorView.querySelector('.autocomplete-plus span.right-label')).toHaveText('do')

    it 'expands the snippet on confirm', ->
      runs ->
        expect(editorView.querySelector('.autocomplete-plus')).not.toExist()

        editor.moveToBottom()
        editor.insertText('D')
        editor.insertText('o')

        advanceClock(completionDelay)

      waitsFor 'autocomplete view to appear', 1000, ->
        editorView.querySelector('.autocomplete-plus')

      runs ->
        atom.commands.dispatch(editorView, 'autocomplete-plus:confirm')
        expect(editor.getText()).toContain '} while (true);'
