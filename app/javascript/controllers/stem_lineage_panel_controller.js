import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "panel",
    "term",
    "meta",
    "match",
    "positions",
    "method",
    "focus",
    "reading",
    "shared",
    "questions"
  ]

  connect() {
    this.closeOnEscape = this.closeOnEscape.bind(this)
    this.closeOnPanelOpen = this.closeOnPanelOpen.bind(this)
    document.addEventListener("fortune-panel:open", this.closeOnPanelOpen)
  }

  disconnect() {
    document.removeEventListener("fortune-panel:open", this.closeOnPanelOpen)
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  open(event) {
    event.preventDefault()

    const {
      term,
      meta,
      match,
      positions,
      method,
      focus,
      reading,
      shared,
      questions
    } = event.params

    this.announcePanelOpen()
    this.termTarget.textContent = term
    this.metaTarget.textContent = meta
    this.matchTarget.textContent = match
    this.positionsTarget.textContent = positions
    this.methodTarget.textContent = method
    this.focusTarget.textContent = focus
    this.readingTarget.textContent = reading
    this.sharedTarget.textContent = shared
    this.questionsTarget.textContent = questions

    this.panelTarget.classList.add("is-open")
    this.panelTarget.setAttribute("aria-hidden", "false")
    document.addEventListener("keydown", this.closeOnEscape)
  }

  close() {
    this.panelTarget.classList.remove("is-open")
    this.panelTarget.setAttribute("aria-hidden", "true")
    document.removeEventListener("keydown", this.closeOnEscape)
  }

  closeOnEscape(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }

  closeOnPanelOpen(event) {
    if (event.detail.panel !== this.panelTarget) {
      this.close()
    }
  }

  announcePanelOpen() {
    document.dispatchEvent(
      new CustomEvent("fortune-panel:open", { detail: { panel: this.panelTarget } })
    )
  }
}
