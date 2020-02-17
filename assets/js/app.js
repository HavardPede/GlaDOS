import css from "../css/app.css";
import { Socket } from "phoenix";
import "phoenix_html";
import LiveSocket from "phoenix_live_view";
import { adminInit } from "./admin.ts"

let liveSocket = new LiveSocket("/live", Socket);
liveSocket.connect();

window.onload = function () {
  this.console.log("started")
  adminInit()
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

  function toggleAccountTab() {
    const accountTab = document.getElementById("accountTab");
    const accountArrow = document.getElementById("accountArrow");
    if (!accountTab) return
    if (
      (accountTab.style.display === "none" ||
        accountTab.style.display === "")
    ) {
      accountTab.style.display = "block";
    } else {
      accountArrow.classList.add("rotatedImage");
      setTimeout(function () {
        (accountTab.style.display = "none"),
          accountArrow.classList.remove("rotatedImage");
      }, 100);
    }
  }
};
