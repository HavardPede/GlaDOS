import css from "../css/app.css";
import { Socket } from "phoenix";
import "phoenix_html";
import LiveSocket from "phoenix_live_view";
import { adminInit } from "./admin.ts"
import { initCookieNotice } from "./cookie_notice"

window.onload = function () {

  let liveSocket = new LiveSocket("/live", Socket);
  liveSocket.connect();

  adminInit()
  initCookieNotice()

  const flatPickr = document.querySelector(".js-flatpickr")
  if (flatPickr) flatpickr(flatPickr, { enableTime: true, time_24hr: true })

  const accountIcon = document.getElementById("accountIcon");
  if (accountIcon) {
    const accountArrow = document.getElementById("accountArrow");

    accountIcon.addEventListener("click", function (_e) {
      toggleAccountTab();
    });
    accountArrow.addEventListener("click", function (_e) {
      toggleAccountTab();
    });
  }
};
