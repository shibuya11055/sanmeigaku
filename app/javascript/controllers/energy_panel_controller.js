import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "panel",
    "term",
    "reading",
    "power",
    "period",
    "short",
    "basic",
    "periodHeading",
    "periodText",
  ]

  connect() {
    this.closeOnEscape = this.closeOnEscape.bind(this)
  }

  open(event) {
    const { term, reading, power, period, short, basic, periodText } = event.params

    this.termTarget.textContent = term
    this.readingTarget.textContent = `(${reading})`
    this.powerTarget.textContent = power
    this.periodTarget.textContent = period
    this.shortTarget.textContent = short
    this.basicTarget.textContent = basic
    this.periodHeadingTarget.textContent = period
    this.periodTextTarget.textContent = periodText

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
