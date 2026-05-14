import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "term", "category", "short", "detail"]

  connect() {
    this.closeOnEscape = this.closeOnEscape.bind(this)
  }

  open(event) {
    const { term, category, categoryCss, short, detail } = event.params

    this.termTarget.textContent = term
    this.termTarget.className = `rel-panel-term rel ${categoryCss}`
    this.categoryTarget.textContent = category
    this.shortTarget.textContent = short
    this.detailTarget.textContent = detail

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
}
