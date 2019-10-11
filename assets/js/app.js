import css from "../css/app.css"

window.onload = function () {

    const accountIcon = document.getElementById("accountIcon");
    if (accountIcon) {

        const accountTab = document.getElementById("accountTab");
        const accountArrow = document.getElementById("accountArrow");


        accountIcon.addEventListener("click", function (_e) {
            toggleAccountTab();
        })
        accountArrow.addEventListener("click", function (_e) {
            toggleAccountTab();
        })
    }

    function toggleAccountTab() {
        console.log(accountTab.style.display)
        if (accountTab.style.display === "none" || accountTab.style.display === "") {
            accountTab.style.display = "block";
        } else {
            accountArrow.classList.add("rotatedImage")
            setTimeout(function () {
                accountTab.style.display = "none",
                    accountArrow.classList.remove("rotatedImage")
            }, 100)
        }
    }
}