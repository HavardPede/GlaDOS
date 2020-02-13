function adminInit() {
  const switchInput: HTMLInputElement | null = document.querySelector(".js-switch")
  console.log(switchInput)
  switchInput?.addEventListener("click", () => {
    console.log("clicked")
    const form: HTMLFormElement | null = switchInput.closest("form")
    console.log(form)
    form?.submit()
  })
}
export { adminInit }