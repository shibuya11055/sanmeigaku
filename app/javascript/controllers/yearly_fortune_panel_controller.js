import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "panel",
    "year",
    "stemAndBranch",
    "voidLabel",
    "summary",
    "majorStar",
    "majorKeywords",
    "keyPeople",
    "placePeople",
    "majorText",
    "subStar",
    "subPower",
    "subKeywords",
    "subText",
    "dayRelationship",
    "monthRelationship",
    "yearRelationship",
    "voidText",
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
    if (this.shouldIgnore(event)) return

    if (event.type === "keydown") {
      event.preventDefault()
    }

    const {
      year,
      stemAndBranch,
      voidLabel,
      summary,
      majorStar,
      majorKeywords,
      keyPeople,
      placePeople,
      majorText,
      subStar,
      subPower,
      subKeywords,
      subText,
      dayRelationship,
      monthRelationship,
      yearRelationship,
      voidText,
    } = event.params

    this.announcePanelOpen()

    this.yearTarget.textContent = year
    this.stemAndBranchTarget.textContent = stemAndBranch
    this.voidLabelTarget.textContent = voidLabel
    this.voidLabelTarget.classList.toggle("is-void", voidLabel === "天中殺年")
    this.summaryTarget.textContent = summary
    this.majorStarTarget.textContent = majorStar
    this.majorKeywordsTarget.textContent = majorKeywords
    this.keyPeopleTarget.textContent = keyPeople || "関係人物"
    this.placePeopleTarget.textContent = placePeople || "該当なし"
    this.majorTextTarget.textContent = majorText
    this.subStarTarget.textContent = subStar
    this.subPowerTarget.textContent = subPower
    this.subKeywordsTarget.textContent = subKeywords
    this.subTextTarget.textContent = subText
    this.dayRelationshipTarget.textContent = dayRelationship
    this.monthRelationshipTarget.textContent = monthRelationship
    this.yearRelationshipTarget.textContent = yearRelationship
    this.voidTextTarget.textContent = voidText

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

  shouldIgnore(event) {
    const interactiveTarget = event.target.closest(
      "button, a, input, select, textarea, [role='button']"
    )

    return Boolean(interactiveTarget && interactiveTarget !== event.currentTarget)
  }
}
