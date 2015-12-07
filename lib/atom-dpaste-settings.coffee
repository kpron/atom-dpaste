module.exports =
  config:
    api_url:
      type: "string"
      default: "Example: dpaste.de"
      description: "Dpaste app API URL"
    api_path:
      type: "string"
      default: "Example: /api/"
      description: "Pastebin's API path"
    copy_paste_to_clipboard:
      type: "boolean"
      default: false
      description: "Copy the URL for the new paste to the clipboard"
