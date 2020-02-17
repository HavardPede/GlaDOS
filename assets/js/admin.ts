function adminInit() {
  const switchInput: HTMLInputElement | null = document.querySelector(".js-switch")
  switchInput?.addEventListener("click", () => {
    const form: HTMLFormElement | null = switchInput.closest("form")
    form?.submit()
  })
}
export { adminInit }