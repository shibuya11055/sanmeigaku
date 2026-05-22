import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "term", "meta", "keywords", "short", "detail", "advice"]

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

    const { term, meta, keywords, short, detail, advice } = event.params
    this.announcePanelOpen()

    this.termTarget.textContent = term
    this.metaTarget.textContent = meta
    this.keywordsTarget.textContent = keywords
    this.shortTarget.textContent = short
    this.detailTarget.textContent = detail
    this.adviceTarget.textContent = advice

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
