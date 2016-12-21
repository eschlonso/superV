//OptionEditor.js

function LabelBehavior(pControlID) {
    ///<summary>
    ///Funcion que se ejecuta cuando se hace click sobre el label relacionado a un Option.
    ///Checkea y descheckea el option.
    ///</summary>
    var pControl = document.getElementById(pControlID);
    pControl.checked = !pControl.checked;
}

if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();