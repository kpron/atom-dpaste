{CompositeDisposable} = require 'atom'
http = require 'http'
https = require 'https'
settings = require './atom-dpaste-settings'
shell = require 'shell'
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
    extname = path.extname(editor.getPath())
    if extname == ".coffee" or extname == ".js"
      syntax = "js"
    else if extname == ".pp"
      syntax = "puppet"
    else if extname == ".py"
      syntax = "python"
    else if extname == ".yaml" or extname == ".yml"
      syntax = "yaml"
    else if extname == ".css"
      syntax = "css"
    else if extname == ".html" or extname == ".htm"
      syntax = "html"
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
    if @get_config().use_https is true
      return require 'https'
    else
      return require 'http'

  # Check config to decide whether to copy the URL to the clipboard
  finalize: (config, url) ->
    if config.copy_paste_to_clipboard is true
      atom.clipboard.write(url)
    if config.open_paste_in_browser is true
      shell.openExternal url

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
