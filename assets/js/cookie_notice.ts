import axios from "axios"

function initCookieNotice() {
  const closeCookieNotice = document.querySelector(".js-close_cookie_notice")
  closeCookieNotice?.addEventListener("click", () => {
    console.log("clicked")
    const cookieNotice: HTMLElement | null = document.querySelector(".js-cookie_notice")
    if (!cookieNotice) return

    cookieNotice.style.display = "none";
    saveChoiceInSession()
  })
}

function saveChoiceInSession() {
  axios.post("/api/dismiss_cookies");
}
export { initCookieNotice }