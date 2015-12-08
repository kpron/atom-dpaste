AtomDpaste = require '../lib/atom-dpaste'

describe 'Package Activation', ->
  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('atom-dpaste')
  it 'should been active', ->
    expect(atom.packages.isPackageActive('atom-dpaste')).toBe true
  it "can read config of atom-dpaste", ->
    config = atom.config.get('atom-dpaste')
    expect(config.copy_paste_to_clipboard).toBe true
    expect(config.open_paste_in_browser).toBe false
    expect(config.api_url).toBe "dpaste.de"
    expect(config.api_path).toBe "/api/"
    expect(config.use_https).toBe true
