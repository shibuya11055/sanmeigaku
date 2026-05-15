import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "panel",
    "term",
    "reading",
    "structure",
    "stars",
    "short",
    "detail",
    "yinYangHeading",
    "yinYangDetail",
  ]

  connect() {
    this.closeOnEscape = this.closeOnEscape.bind(this)
  }

  open(event) {
    const { term, reading, structure, stars, short, detail, yinYang, yinYangDetail } = event.params

    this.termTarget.textContent = term
    this.readingTarget.textContent = reading ? `(${reading})` : ""
    this.structureTarget.textContent = structure
    this.starsTarget.textContent = stars
    this.shortTarget.textContent = short
    this.detailTarget.textContent = detail
    this.yinYangHeadingTarget.textContent = yinYang || "陰陽分類"
    this.yinYangDetailTarget.textContent = yinYangDetail || ""

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
