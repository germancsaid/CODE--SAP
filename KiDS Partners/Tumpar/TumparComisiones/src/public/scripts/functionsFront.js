function modeDarkTheme(){
    document.getElementById("modeDarkTheme").href = "styles/darkStyles.css";
    document.getElementById("modeLightTheme").href = "";
    }

function modeLightTheme(){
    document.getElementById("modeDarkTheme").href = "";
    document.getElementById("modeLightTheme").href = "styles/generalStyles.css";
};