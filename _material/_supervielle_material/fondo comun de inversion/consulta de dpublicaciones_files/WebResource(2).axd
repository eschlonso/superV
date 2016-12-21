//Common.js

function EncryptText(pText, pAjaxUrl) {
    ///<summary>Encripta el texto pasado como parametro.</summary>
    var pUrl = pAjaxUrl + '?Text=' + pText;
    return $.ajax({ url: pUrl, async: false }).responseText;
}

function OnePostBackOnlyEnableDelay(btn) {
    window.setTimeout("OnePostBackOnlyEnable('" + btn + "')", 1000);
}

function OnePostBackOnlyEnable(btn) {
    var oButton = document.all ? document.all['' + btn + ''] : document.getElementById('' + btn + '');
    if (oButton) {
        if (typeof oButton.length != 'undefined')
            for (var i = 0; i < oButton.length; i++) {
                oButton[i].disabled = false;
            }
        else {
            try { oButton.disabled = false; } catch (ex) { };
        }
    }
}

function OnePostBackOnlyDisable(btn) {
    var oButton = document.all ? document.all['' + btn + ''] : document.getElementById('' + btn + '');
    if (oButton) {
        if (typeof oButton.length != 'undefined')
            for (var i = 0; i < oButton.length; i++) {
                oButton[i].disabled = true;
            }
        else {
            try { oButton.disabled = true; } catch (ex) { };
        }
    }
}

