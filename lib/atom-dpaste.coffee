{CompositeDisposable} = require 'atom'
http = require 'http'
settings = require './atom-dpaste-settings'
path = require 'path'

module.exports = AtomDpaste =
  config: settings.config

  activate: (state) ->
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-dpaste:upload': () => @upload()

    @transport = @get_transport()

  # Returns an object with the text and title for the current active editor
  get_editor_data: ->
    editor = atom.workspace.getActivePane().getActiveEditor()
    selection = editor.getLastSelection()
    if path.extname(editor.getPath()) == ".coffee"
      syntax = "js"
    else if path.extname(editor.getPath()) == ".pp"
      syntax = "puppet"
    else if path.extname(editor.getPath()) == ".py"
      syntax = "python"
    else if path.extname(editor.getPath()) == ".yaml" or path.extname(editor.getPath()) == ".yml"
      syntax = "yaml"
    else
      syntax = "text"
    data =
      text: selection.getText()
      syntax: syntax
    return data

  # Returns the current config for atom-dpaste
  get_config: ->
    return atom.config.get('atom-dpaste')

  # Use HTTPS by default, else use HTTP
  get_transport: ->
      return require 'http'

  # Check config to decide whether to copy the URL to the clipboard
  finalize: (config, url) ->
    if config.copy_paste_to_clipboard is true
      atom.clipboard.write(url)

  upload: ->
    config = @get_config()
    data = @get_editor_data()
    query = @build_query(config, data)
    @api_request(config, query)
  # Build the Dpaste API query string
  build_query: (config, data) ->
    query = "content=#{encodeURIComponent data.text}" +
      "&lexer=#{encodeURIComponent data.syntax}" +
      "&format=url"


  api_request: (config, query) ->
    options =
      host: config.api_url
      path: config.api_path
      method: 'POST'
      headers:
        'Content-Type': 'application/x-www-form-urlencoded',

    resp = ""
    req = @transport.request options, (res) =>
      res.setEncoding "utf8"
      # Accumulate the response data
      res.on "data", (chunk) -> resp += chunk
      # On end, check for error, or call finalize with the response
      res.on "end", =>
        if resp.toLowerCase().indexOf("bad api request") >= 0
          alert "ERROR: " + resp
        else
          @finalize(config, resp)
    # Write the query to the Dpaste API
    req.write query
    req.end()
