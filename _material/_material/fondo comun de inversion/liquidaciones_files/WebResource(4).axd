//scrMain.js

var _Accion = '', _Key = '', _Entidad = -1, _FormHeight = -1; _FormWidth = -1; _Modo = -1;

// esta funcion se usa desde varios lados
function ShowMenuAcc(pControl, pWithNew, pWithFind, pEntidad, pFormWidth, pFormHeight) {
    var pMenuAgr = igmenu_getItemById(_mnuAgregar).getElement();
    var pMenuBus = igmenu_getItemById(_mnuBuscar).getElement();
    if (pWithNew == -1)
        pMenuAgr.style.display = '';
    else
        pMenuAgr.style.display = 'none';
    if (pWithFind == -1)
        pMenuBus.style.display = '';
    else
        pMenuBus.style.display = 'none';
    ShowMenuAccMenu(pControl, pEntidad, pFormWidth, pFormHeight, _webMenuAccID)
}

// esta funcion se usa desde varios lados
function ShowMenuAccWizard(pControl, pWithNew, pWithFind, pEntidad, pFormWidth, pFormHeight) {
    var pMenuAgr = igmenu_getItemById(_mnuAgregar).getElement();
    var pMenuBus = igmenu_getItemById(_mnuBuscar).getElement();
    if (pWithNew == -1)
        pMenuAgr.style.display = '';
    else
        pMenuAgr.style.display = 'none';
    if (pWithFind == -1)
        pMenuBus.style.display = '';
    else
        pMenuBus.style.display = 'none';
    ShowMenuAccMenuWizard(pControl, pEntidad, pFormWidth, pFormHeight, _webMenuAccID)
}

function ShowMenuAccMenuWizard(pControl, pEntidad, pFormWidth, pFormHeight, pMenuID) {
    _Entidad = pEntidad;
    _FormHeight = pFormHeight;
    _FormWidth = pFormWidth;
    ShowMenuWizard(pControl, pMenuID)
}

function ShowMenuAccMenu(pControl, pEntidad, pFormWidth, pFormHeight, pMenuID) {
    _Entidad = pEntidad;
    _FormHeight = pFormHeight;
    _FormWidth = pFormWidth;
    ShowMenu(pControl, pMenuID)
}

function MnuItem_click(menuid, itemid) {
    var pId = igmenu_getItemById(itemid).getAccessKey();

    if (pId == "ADD")
        ListItem_ActionClick(_Entidad, TPA_Agr, _FormWidth, _FormHeight)
    else if (pId == "FIND")
        ListItem_OnClick(_Entidad, -1)
    else if (pId == "CONFIGMENU")
        OpenConfigDesktop();
    else if (pId == "RESTGRID")
        MenuEntidad_CallBack("RESTGRID", _Entidad);
    else if (pId == "ADDFAV")
        MenuEntidad_CallBack("ADDFAV", _Entidad);
    else if (pId == "DELFAV")
        MenuEntidad_CallBack("DELFAV", _Entidad);
}

function ListItem_OnClick(Entidad, Buscar, TieneGrilla, formWidth, formHeight) {
    RefreshWarp(_warpAsyncUltOp, 5000);


    if (Buscar == 0 && TieneGrilla == -1) {
        OpenGrid(Entidad);
    } else if (TieneGrilla == 0) {
        OpenGrid(Entidad, null, null, formWidth, formHeight);
    } else {
        OpenFilterWnd(Entidad, 0);
    }
}

function ListItem_ActionClick(Entidad, TpAccion, formWidth, formHeight) {
    RefreshWarp(_warpAsyncUltOp, 5000);

    if (TpAccion == TPA_Agr) //agregar
    //(Entidad, TpAccion, Keys, formWidth, formHeight, FromGrid )
        ExecEntTpAccion(Entidad, TpAccion, null, formWidth, formHeight, false);
    else
        OpenGrid(Entidad);
}

function RefreshWarp(id, dur) {
    var warp = ig$(id);
    if (!warp)
        return;
    //          warp.setTimer(dur);
    warp.refresh();
}

//se ejecuta cuando ocurre algún error en las llamadas al servidor (CallBack).
//el mensaje y contexto se especifica en el servidor
function CallBack_Error(mensaje, contexto) {
    OpenMessageText(mensaje);
}

function MenuEntidad_CallBackReturn(Action) {
    if (Action == "ADDFAV" || Action == "DELFAV")
        RefreshWarp(_warpAsyncFav);
    else
        OpenMessageText(Action);
}

function ShowMenuEntidad(pControl, pEntidad, pWithGrid, pMenuID) {
    var pTieneGrilla = igmenu_getItemById(_mnuGrilla).getElement();
    if (pWithGrid == -1)
        pTieneGrilla.style.display = '';
    else
        pTieneGrilla.style.display = 'none';
    _Entidad = pEntidad;
    ShowMenu(pControl, pMenuID)
}

function WizardMenuEntidad_CallBackReturn(Action) {
    if (Action == "DEL")
        RefreshWarp(_warpAsyncFav);
    else {
        cadena = Action.split(",");
        ExecEntTpAccion(cadena[0], cadena[1], cadena[2], cadena[3], cadena[4], cadena[5], cadena[6])
    }
}

function WizardMnuItem_click(menuid, itemid) {
    var pId = igmenu_getItemById(itemid).getAccessKey();

    if (pId == "DEL") {
        var arg = 'DEL' + '&' + _Key;
        //WizardMenuEntidad_CallBack(arg, _Entidad);
        ExecEntTpAccion(_Entidad, _AccionDel, _Key, _FormWidth, _FormHeight, _Key, '')
    }
    else
        if (pId == "MOD") {
            var arg = 'MOD' + '&' + _Key;
            ExecEntTpAccion(_Entidad, _AccionMod, _Key, _FormWidth, _FormHeight, _Key, '', '', _Modo)
            //WizardMenuEntidad_CallBack(arg, _Entidad);
        }
        else
            if (pId == "DET") {
                var arg = 'MOD' + '&' + _Key;
                ExecEntTpAccion(_Entidad, _AccionDet, _Key, _FormWidth, _FormHeight, _Key, '', '', _Modo)
            }
            else
                if (pId == "REC") {
                    ExecEntTpAccion(_Entidad, _AccionRec, _Key, _FormWidth, _FormHeight, _Key, '')
                }
}

function WizardShowMenuEntidad2(pControl, pKey, pMenuID) {
    _Key = pKey;
    //_CodMoneda = pMoneda;
    ShowMenu(pControl, pMenuID)
}

function WizardShowMenuEntidad(pControl, pWithDet, pWithMod, pWithDel, pWithUnDel, pEntidad, pKey, pFormWidth, pFormHeight, pMenuID, pModo) {
    var pMenuDet = igmenu_getItemById(_mnuDetallar).getElement();
    var pMenuMod = igmenu_getItemById(_mnuModificar).getElement();
    var pMenuDel = igmenu_getItemById(_mnuEliminar).getElement();
    var pMenuUnDel = igmenu_getItemById(_mnuRecuperar).getElement();
    _Key = pKey;
    _Entidad = pEntidad;
    _FormHeight = pFormHeight;
    _Modo = pModo;
    _FormWidth = pFormWidth;
    //_Accion = pAccion;
    if (pWithDet == -1)
        pMenuDet.style.display = '';
    else
        pMenuDet.style.display = 'none';
    if (pWithMod == -1)
        pMenuMod.style.display = '';
    else
        pMenuMod.style.display = 'none';
    if (pWithDel == -1)
        pMenuDel.style.display = '';
    else
        pMenuDel.style.display = 'none';
    if (pWithUnDel == -1)
        pMenuUnDel.style.display = '';
    else
        pMenuUnDel.style.display = 'none';
    ShowMenu(pControl, pMenuID)
}

function SelectCheckBox(objList, op) {
    var chkBoxList = document.getElementById(objList);
    var chkBoxCount = chkBoxList.getElementsByTagName("input");
    for (var i = 0; i < chkBoxCount.length; i++) {
        if (op == '1') {
            if (chkBoxCount[i].checked == false) {
                chkBoxCount[i].checked = true;
            } else {
                chkBoxCount[i].checked = false;
            }
        }
        if (op == '2') {
            chkBoxCount[i].checked = false;
        }
        if (op == '3') {
            chkBoxCount[i].checked = true;
        }
    }

    //chkBox.checked = true;
    return true;
}

