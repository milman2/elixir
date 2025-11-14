// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

import hljs from "highlight.js"

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/elixir_gist"
import topbar from "../vendor/topbar"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

function updateLineNumbers(value) {
  const lineNumberText = document.querySelector("#line-numbers")
  if (!lineNumberText) return

  const lines = value.split("\n")

  const numbers = lines.map((_, index) => index + 1).join("\n") + "\n"

  lineNumberText.value = numbers
};

let Hooks = {}
Hooks.HighlightJS = {
  mounted() {
    let name = this.el.getAttribute("data-name");
    let codeBlock = this.el.querySelector("pre code");
    if (name && codeBlock) {
      codeBlock.className = codeBlock.className.replace(/language-\S+/g, "");
      codeBlock.classList.add(`language-${this.getSyntaxType(name)}`);
      trimmed = this.trimCodeBlock(codeBlock)
      hljs.highlightElement(trimmed);
      updateLineNumbers(trimmed.textContent)
    }
  },
  getSyntaxType(name) {
    let extension = name.split(".").pop();
    switch (extension) {
      case "txt":
        return "text";
      case "json":
        return "json";
      case "html":
        return "html";
      case "heex":
        return "html";
      case "js":
        return "javascript";
      default:
        return "elixir";
    }
  },
  trimCodeBlock(codeBlock) {
    const lines = codeBlock.textContent.split("\n")
    if (lines.length > 2) {
      lines.shift()
      lines.pop()
    }
    codeBlock.textContent = lines.join("\n")
    return codeBlock
  },
}

Hooks.UpdateLineNumbers = {
  mounted() {
    const lineNumberText = document.querySelector("#line-numbers")

    this.el.addEventListener("input", () => {
      updateLineNumbers(this.el.value)
    })

    this.el.addEventListener("scroll", () => {
      lineNumberText.scrollTop = this.el.scrollTop
    })

    this.el.addEventListener("keydown", (e) => {
      if (e.key == "Tab") {
        e.preventDefault();
        var start = this.el.selectionStart;
        var end = this.el.selectionEnd;
        this.el.value = this.el.value.substring(0, start) + "\t" + this.el.value.substring(end);
        this.el.selectionStart = this.el.selectionEnd = start + 1;
      }
    })

    this.handleEvent("clear-textareas", () => {
      this.el.value = ""
      lineNumberText.value = "1\n"
    })

    updateLineNumbers(this.el.value)
  },
  updated() {
  },
  destroyed() {    
  },
}

Hooks.CopyToClipboard = {
  mounted() {
    this.el.addEventListener("click", e => {
      const textToCopy = this.el.getAttribute("data-clipboard-gist");
      if (textToCopy) {
        navigator.clipboard.writeText(textToCopy).then(() => {
          console.log("Gist copied to clipboard")
        }).catch(err => {
          console.error("Failed to copy text", err)
        })
      }      
    })
  },
}

const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks, ...Hooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

