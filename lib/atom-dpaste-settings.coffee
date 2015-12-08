module.exports =
  config:
    api_url:
      type: "string"
      default: "dpaste.de"
      description: "Dpaste app API URL"
    api_path:
      type: "string"
      default: "/api/"
      description: "Pastebin's API path"
    use_https:
      type: "boolean"
      default: true
      description: "Use HTTPS transport for pastes"
    copy_paste_to_clipboard:
      type: "boolean"
      default: true
      description: "Copy the URL for the new paste to the clipboard"
    open_paste_in_browser:
      type: "boolean"
      default: false
      description: "Open the URL for the new paste in the default web browser"
