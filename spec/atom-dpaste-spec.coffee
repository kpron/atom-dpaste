AtomDpaste = require '../lib/atom-dpaste'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomDpaste", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('atom-dpaste')

  describe "when the atom-dpaste:upload event is triggered", ->
    it "can read config of atom-dpaste", ->

      runs ->
        config = atom.config.get('atom-dpaste')
        expect(config.copy_paste_to_clipboard).toBe true
        expect(config.open_paste_in_browser).toBe false
        expect(config.api_url).toBe "dpaste.de"
        expect(config.api_path).toBe "/api/"
        expect(config.use_https).toBe true
