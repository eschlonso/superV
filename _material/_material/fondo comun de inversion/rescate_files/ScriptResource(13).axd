//NumericEditor.js

function WebNumericEdit1_KeyPress(oEdit, keyCode, oEvent) {
    if (keyCode != 44 && keyCode != 46)// coma and dot
        return;
    var separatorCode = oEdit.decimalSeparator.charCodeAt(0);
    oEvent.keyCode = separatorCode;
}
if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();