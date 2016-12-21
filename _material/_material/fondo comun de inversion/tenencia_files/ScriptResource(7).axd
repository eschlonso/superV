//BasePage.js
var cantCallBacks = 0;
var pLlamadasPendientes = 0
var alertaCallBacks = false;
var pSiguienteCallBack;
var pColaCallBack = new Array();
var pPrevSerData = '';
setInterval('cantCallBacks = 0;', 15000);

function showCallBackErrorMessage(pMensaje) {
    //$.jGrowl(pMensaje.replace(/\+/g, ' '), { header: 'Atención' });
    alert("Atención:\n" + pMensaje.replace(/\+/g, ' '));
    pLlamadasPendientes--;
}

function EscoCallBack(pID, pEvent) {
    CallBackPilaAdd(pID, pEvent);
    CallBackSiCorresponde(false);
}

function ResponseEscoCallBack(r) {
    var Procesando = false;

    if (pLlamadasPendientes > 0) {
        Procesando = true;
        pLlamadasPendientes--;
    }

    if (Procesando) {
        var jSonObj = Sys.Serialization.JavaScriptSerializer.deserialize(r);
        HiddenDic.val(jSonObj.state);
        HiddenDic.loadJSON()
        if (document.getElementById('CallBackInfo')) $('#CallBackInfo').val($('#CallBackInfo').val() + '\n Recibido: \n' + r + '\n \n');
        $.each(jSonObj.controls, function (index, ctrl) {
            eval(index + '.setUnserialize(ctrl);');
        });  //Vuelvo a los controles
        eval(jSonObj.script);
    }

    CallBackSiCorresponde(false);
}

function SendEscoCallBack(pID, pEvent) {
    if (cantCallBacks > 30) {
        if (!alertaCallBacks) {
            alert('Se detectó una redundancia cíclica en los eventos.'); //La cantidad de callback excede lo normal
            pLlamadasPendientes--;
            alertaCallBacks = true;
        }
        cantCallBacks = 0;
    } else {
        pLlamadasPendientes++;
        cantCallBacks++;
        var _C = { "id": pID, "eventName": pEvent, "controls": {} };   //el array de controles

        $.each(EscoAjaxControls, function (index, ctrl) {
            ctrl.RefreshState();
            eval('_C.controls.' + ctrl.sID + ' = ctrl.getSerialize()');
        });
        if (HiddenDic) {
            _C.state = HiddenDic.val();
        }
        var pSerData = Sys.Serialization.JavaScriptSerializer.serialize(_C);
        if (pSerData != pPrevSerData) {
            if (document.getElementById('CallBackInfo')) $('#CallBackInfo').val($('#CallBackInfo').val() + '\n Enviando: \n' + pSerData + '\n \n');
            pPrevSerData = pSerData;
            setTimeout('pPrevSerData = \'\';', 200);
            RaiseEscoCallBack(pSerData);
        } else {
            pLlamadasPendientes--;
        }
    }
}

//Agrego
function CallBackPilaAdd(pID, pEvent) {
    pColaCallBack.push({ Id: pID, Event: pEvent });
}

//Traigo el ultimo
function CallBackPilaGet() {
    return pColaCallBack.shift();
}

function CallBackSiCorresponde(pEsPorTimeOut) {
    $.each(EscoAjaxControls, function (index, ctrl) {
        ctrl.RefreshState();
    });
    if (pEsPorTimeOut && pLlamadasPendientes > 0) {
        alert('No se recibió respuesta del servidor');
    }

    if (pLlamadasPendientes == 0) {
        clearTimeout(pSiguienteCallBack);
        var nextCallBackToSend = CallBackPilaGet();
        if (nextCallBackToSend != undefined) {
            SendEscoCallBack(nextCallBackToSend.Id, nextCallBackToSend.Event);
            pSiguienteCallBack = setTimeout('CallBackSiCorresponde(true);', 15000);
        }
    }
}



if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();