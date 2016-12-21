//wccDataFmt.js

var ColId; 	//columnas a modificar el ancho
var HuboCambios = 0;
var ColAnt, CrtCountAnt, lastid;
var delay = 80;
var opa = 0; var sett;
ColAnt = -1;
CrtCountAnt = -1;

function GetGrid(pGridID) {
    if (typeof (pGridID) == 'undefined' || pGridID == null) {
        return document.getElementById(GRID);
    } else {
        return document.getElementById(pGridID);
    }
}
function GrabarAnchos(pHeaderCell) {
    if (HuboCambios == -1) {
        HuboCambios = 0;
        var txt = '';
        if (pHeaderCell != null) {
            txt = pHeaderCell.parentNode.CodEntColumna + ":" + pHeaderCell.style.posWidth + ";";
            CallServer('setwt' + txt, null);
        }
    }
}

function PonerFn(pGridID, lstID, Col, CrtCount, pPosition) {
    for (p = 1; p <= CrtCount; p++) {
        document.getElementById(lstID + '_lstBox_' + p).selectedIndex = DFGridarray[Col - 1][p - 1];
    }
    document.getElementById(lstID).style.top = pPosition;
    MostrarLista(pGridID, lstID, 0, 0);
    ColAnt = Col;
    CrtCountAnt = CrtCount;
}

function AsignarFnArray(lstID, fnSel) {
    for (p = 1; p <= CrtCountAnt; p++) {
        DFGridarray[ColAnt - 1][p - 1] = document.getElementById(lstID + '_lstBox_' + p).selectedIndex;
    }

    var retorno = '';
    for (p = 1; p <= DFGridarray.length; p++) {
        for (t = 1; t <= CrtCountAnt; t++) {
            if (t < CrtCountAnt)
                retorno += DFGridarray[p - 1][t - 1] + ":";
            else
                retorno += DFGridarray[p - 1][t - 1];

        }
        if (p < DFGridarray.length)
            retorno += ";";
    }
    document.getElementById(fnSel).value = retorno;
}

function GetCodAuditoriaRef(pFilaID) {
    var pCodAuditoriaRef = null;

    try {
        if (pFilaID != undefined) {
            pCodAuditoriaRef = document.getElementById(GRID + '_' + pFilaID).attributes.getNamedItem('CodAuditoriaRef').value;
        }
    } catch (e) { }
    return pCodAuditoriaRef;
}

function GetKeys(pGridID) {
    var a = new String()
    a = document.getElementById(GetKeyContainerFromGrid(pGridID)).value
    a = a.substring(7, a.length)
    return a;
}

function GetKey(pRowID) {
    var a = pRowID;
    //a = document.getElementById(GetKeyContainerFromGrid(pGridID)).value
    a = a.substring(7, a.length)
    return a;
}

function getElement(pElement) {
    return GetElementFromGrid(pElement);
}

var MenuHidden = 0;
var timerid = -1;

function ShowDFMenu(eventchild) {
    var menu = document.getElementById("df_menu");
    menu.style.left = document.body.scrollLeft + eventchild.clientX - eventchild.offsetX + 10
    menu.style.top = document.body.scrollTop + eventchild.clientY - eventchild.offsetY + 58
    HiddenMenu(0)
}

function HiddenMenu(hide) {
    var menu = document.getElementById("df_menu");
    if ((menu.style.display == '') || (hide == -1)) {
        menu.style.display = 'none'
        MenuHidden = -1;
    }
    else {
        menu.style.display = '';
        MenuHidden = 0;
    }
}

function HideLists(IDGrid, lstIDNoHide) {
    if (GetGrid(IDGrid) != null) {
        if (GetGrid(IDGrid).ShowCnf) {
            var lstalm = GetGrid(IDGrid).Listas;
            for (p = 0; p <= lstalm.length - 1; p++) {
                if (lstalm[p] != lstIDNoHide) OcultarLista(lstalm[p]);
            }
        }
    }
}

function ResizeLists(IDGrid, setHeight) {
    heightant = setHeight;
    if (GetGrid(IDGrid) != null) {
        var lstalm = GetGrid(IDGrid).Listas;
        if (lstalm != undefined) {
            for (p = 0; p <= lstalm.length - 1; p++) {
                setHeight = heightant;
                var _lst = document.getElementById(lstalm[p]);
                if (!_lst.anteriorHeight)
                    _lst.anteriorHeight = _lst.style.height.replace(/px/g, '');
                if (Number(setHeight) <= 40) setHeight = 40
                if (Number(setHeight) >= Number(_lst.anteriorHeight)) setHeight = _lst.anteriorHeight

                if (setHeight)
                    _lst.style.height = setHeight + 'px';
            }
        }
    }
}

function MostrarLista(IDGrid, lstID, hide, top) {
    var pDiv = document.getElementById(lstID);
    if (hide == -1)
    { HideLists(IDGrid, lstID); }

    pDiv.style.left = "-350px";
    pDiv.style.display = "inline";
    var posGrid = getAbsolutePosition(IDGrid)
    pDiv.style.top = top + "px";
    pDiv.style.left = "206px";
    delay = 80;
    opa = 0;
}

function OcultarLista(lstID) {
    var pDiv = document.getElementById(lstID);
    pDiv.style.left = "-350px";
    pDiv.style.display = "none";
}

function addEventsToCells(pGridID, colorMouseOver, selectionColor) {
    var tbl = GetGrid(pGridID);
    var tr = tbl.getElementsByTagName("tr");
    for (var i = 0; i < tr.length; i++) {
        tr[i].onclick = function () { grilla_click(pGridID, this.id, selectionColor) };
        tr[i].onmouseout = function () { grilla_selchange_out(pGridID, this.id, colorMouseOver, selectionColor) };
        tr[i].onmouseover = function () { grilla_selchange_in(pGridID, this.id, colorMouseOver, selectionColor) };
    }
    return;
}

function addEventsToCellsWithWizard(pGridID, colorMouseOver, selectionColor) {
    var tbl = GetGrid(pGridID);
    var tr = tbl.getElementsByTagName("tr");
    for (var i = 0; i < tr.length; i++) {
        tr[i].onclick = function () {
            grilla_click(pGridID, this.id, selectionColor);
            DrawWizardIframe(this.id);
        };
        tr[i].onmouseout = function () { grilla_selchange_out(pGridID, this.id, colorMouseOver, selectionColor) };
        tr[i].onmouseover = function () { grilla_selchange_in(pGridID, this.id, colorMouseOver, selectionColor) };
    }
    return;
}

function grilla_selchange_out(pGridID, pFilaID, colorMouseOver, selectionColor) { grilla_selchange(pGridID, pFilaID, 1, colorMouseOver, selectionColor) }
function grilla_selchange_in(pGridID, pFilaID, colorMouseOver, selectionColor) { grilla_selchange(pGridID, pFilaID, 0, colorMouseOver, selectionColor) }

function grilla_selchange(pGridID, pFilaID, mouseout, colorMouseOver, selectionColor) {
    if (pFilaID != "") {
        var celda = document.getElementById(pFilaID);
        if (celda != null)
            if (mouseout == 1) {
                celda.className = celda.className.replace(' ' + selectionColor, '');
                celda.className = celda.className.replace(' ' + colorMouseOver, '');
                grilla_paintselected(pGridID, selectionColor);
            } else {
                celda.className = celda.className + ' ' + colorMouseOver;
            }
    }
}

function GetKeyContainerFromGrid(pGridID) {
    if (GetGrid(pGridID) != null)
        return GetGrid(pGridID).keycontainer;
}

function GetElementFromGrid(pElement) { return document.getElementById(pElement); }

function grilla_click(pGridID, pFilaID, selectionColor) {
    HideLists(pGridID);

    if (GetGrid(pGridID) != null) {
        if (GetGrid(pGridID).ShowCnf) {
            if (document.getElementById(pGridID + '_configpanel_buttons').style.display == 'block') openConfigPanel(pGridID + '_configpanel_buttons');
        }
    }
    var ctrlkey = document.getElementById(GetKeyContainerFromGrid(pGridID));
    if (ctrlkey != null) {
        if (ctrlkey.value != "") {
            var celda = document.getElementById(ctrlkey.value);
            if (celda) {
                celda.className = celda.className.replace(' ' + selectionColor, '');
                //            celda.className = celda.className.replace(colorMouseOver, '');
            }
        }
        ctrlkey.value = pFilaID;
    }    
    grilla_paintselected(pGridID, selectionColor);
}

function quitar_seleccion(pGridID, selectionColor) {
    var ctrlkey = document.getElementById(GetKeyContainerFromGrid(pGridID));
    if (ctrlkey != null) {
        if (ctrlkey.value != "") {
            var celda = document.getElementById(ctrlkey.value)
            if (celda != null) celda.className = celda.className.replace(selectionColor, '');
        }
    }
}

function grilla_paintselected(pGridID, selectionColor) {
    var ctrlkey = document.getElementById(GetKeyContainerFromGrid(pGridID));
    if (ctrlkey != null) {
        if (ctrlkey.value != "") {
            var celda = document.getElementById(ctrlkey.value)
            if (celda != null && celda.className.indexOf(selectionColor) == -1) celda.className = celda.className + ' ' + selectionColor;
        }
    }
}

function SetGridSize(pGridID, setwidth, setHeight) {
    var divGrid = document.getElementById(pGridID + '_divcontainer');
    if (divGrid != null) {
        divGrid.style.width = setwidth;
        if (setHeight >= 50)
            divGrid.style.height = setHeight - 50;
    }
    ResizeLists(pGridID, setHeight)
}

// Posición de un objeto
function getAbsolutePosition(element) {
    if (typeof element == "string")
        element = document.getElementById(element)

    if (!element)
        return { top: 0, left: 0 };

    var y = 0;
    var x = 0;
    while (element.offsetParent) {
        x += element.offsetLeft;
        y += element.offsetTop;
        element = element.offsetParent;
    }
    x += window.document.body.offsetLeft
    y += window.document.body.offsetTop

    return { top: y, left: x };
}

function EsAnulado(pFilaID) {
    var a = 0;
    a = document.getElementById(GRID + '_' + pFilaID).EA;
    if (a != undefined)
        return a;
}

function mouse_event(obj, newClass) {
    obj.className = newClass;
}

function openConfigPanel(pConfigPanelID) {
    var cp = document.getElementById(pConfigPanelID).style;
    if (cp.display == 'none' || cp.display == '') {
        cp.display = 'block';
    }
    else {
        cp.display = 'none';
    }
}

/* :::::::::::::::::::::::::::::: Checks code ::::::::::::::::::::::::::::::: */
var CheckSelectedKeysCount = 0;

function CheckReceiveServerItem(pResult, pContext) {
    if (Number(pResult) > 0) {
        CheckSelectedKeysCount = Number(pResult);
    } else {
        OnePostBackOnlyEnableDelay('' + GRID + '_chk0' + '');
        CheckSelectedKeysCount = 0;
    }
}

function getCheckedPositions(pEnableDeletedRows) {
    var pKeys = null;
    var pNewKeys = getCheckedPositionsPage(null, pEnableDeletedRows);

    pKeys = new Array();

    for (var pNewKey in pNewKeys) {
        var pEncontrado = false;

        for (var pKey in pKeys) {
            if (pKeys[pKey] == pNewKeys[pNewKey]) {
                pEncontrado = true;
                break;
            }
        }

        if (!pEncontrado) {
            pKeys[pKeys.length] = pNewKeys[pNewKey];
        }
    }

    return pKeys;
}

function getCheckedPositionsPage(pIDGrid, pEnableDeletedRows) {
    var grid = GetGrid(GRID);
    var tr = grid.getElementsByTagName('tr');
    var arrKeys = new Array();

    var i = 0;
    for (var t = 0; t < tr.length; t++) {
        if (tr[t].id.indexOf(GRID + '_') != -1) {
            if (!tr[t].EA || pEnableDeletedRows) {
                if (tr[t].childNodes[0].childNodes[0].className == 'Checkyes') {
                    arrKeys[i] = tr[t].getAttributeNode('IDPosicion').value;
                    i++;
                }
            }
        }
    }
    return arrKeys;
}

function CheckInvertRows() {
    var span = document.getElementsByTagName('span');

    var skInvert = 'skInvert';
    for (var i = 0; i < span.length; i++) {
        if (CheckIsCell(span[i])) {
            var pClassName;
            if (span[i].className != "Checkna") {
                if (span[i].className == "Checkno") {
                    pClassName = "Checkyes";
                } else if (span[i].className == "Checkyes") {
                    pClassName = "Checkno";
                }

                var trnode = span[i].parentNode.parentNode;
                skInvert = skInvert + '@@@' + trnode.attributes.getNamedItem('IDPosicion').value + ";" + trnode.id + ';' + pClassName;
                span[i].className = pClassName;
            }
        }
    }
    CheckCallServerItem(skInvert, null);
}

function CheckInvertItem(obj) {
    if (obj.className == "Checkno") {
        CheckSetItemClass(obj, "Checkyes");
    } else if (obj.className == "Checkyes") {
        CheckSetItemClass(obj, "Checkno");
    }
}

function getSelectedItemsCount() {
    return $('#' + GRID + ' TBODY SPAN.Checkyes').length;
}

function CheckDeselectRows() {
    SetClassCheck("Checkno")
}

function SetClassCheck(pClassName) {
    var span = document.getElementsByTagName('span');
    for (var i = 0; i < span.length; i++) {
        if (CheckIsCell(span[i])) {
            CheckSetItemClass(span[i], pClassName);
        }
    }
}

function CheckSetItemClass(obj, pClassName) {
    var trnode = obj.parentNode.parentNode;
    CheckCallServerItem('skSet@@@' + trnode.attributes.getNamedItem('IDPosicion').value + '@@@' + trnode.id + '@@@' + pClassName, obj.id);
    obj.className = pClassName;
}

//dibuja los checks en todos los rows, verifica si el check ya está dibujado, antes de dibujarlo
function CheckRenderRows(pEnableDeletedRows) {
    //    SetClassCheck("Checkna");
    var cells = GetGrid(GRID).getElementsByTagName('td');
    GetElementFromGrid(GRID + '_EnableDeletedRows').checked = pEnableDeletedRows;
    var objItem = null;
    for (var i = 0; i < cells.length; i++) {
        if (cells[i].id == 'rndCheck') {
            if (!cells[i].parentNode.EA || pEnableDeletedRows == true) {
                if (!cells[i].childNodes.length) {
                    objItem = document.createElement("SPAN");

                    // Setup the check
                    objItem.id = GRID + '_chk' + i + 1; //el cero ya está usado
                    objItem.className = 'Checkno';
                    objItem.onclick = function () { CheckInvertItem(this); };
                    // Add the check to cell
                    cells[i].appendChild(objItem);
                }
            }
            else
                if (cells[i].childNodes[0] != undefined)
                    cells[i].childNodes[0].className = 'Checkna';
        }
    }
}

function CheckIsCell(obj) {
    return ((obj.className == 'Checkna' || obj.className == 'Checkyes' || obj.className == 'Checkno') && (obj.id != GRID + '_chk0') && (obj.id != null) && (obj.id != 'undefined') && (obj.id != ''));
}

//muestra columna check trabajando con los styles / reconfigura ModoCheck
function CheckShowColumn() {
    var colMC = GetElementFromGrid('MultiCheck').style; colMC.display = 'block'; colMC.visibility = 'visible';
    var hdrMC = GetElementFromGrid(GRID + '_chk0').style; hdrMC.display = 'block'; hdrMC.visibility = 'visible';

    var oColCheck = document.all ? document.all['colCheck'] : document.getElementById('colCheck');
    if (oColCheck.length != undefined) {
        for (var i = 0; i < oColCheck.length; i++) {
            oColCheck[i].style.display = 'block'; oColCheck[i].style.visibility = 'visible';
        }
    } else {
        oColCheck.style.display = 'block'; oColCheck.style.visibility = 'visible';
    }

    var oRndCheck = document.all ? document.all['rndCheck'] : document.getElementById('rndCheck');
    if (oRndCheck != undefined) { for (var i = 0; i < oRndCheck.length; i++) { oRndCheck[i].style.display = 'block'; oRndCheck[i].style.visibility = 'visible'; } }

    GetElementFromGrid(GRID + '_ModoCheck').checked = true;
}

//oculta columna check trabajando con los styles / reconfigura ModoCheck
function CheckHideColumn() {
    var oRndCheck = document.all ? document.all['rndCheck'] : document.getElementById('rndCheck');
    if (oRndCheck != undefined) { for (var i = 0; i < oRndCheck.length; i++) { oRndCheck[i].style.display = 'none'; oRndCheck[i].style.visibility = 'hidden'; } }
    var oColCheck = document.all ? document.all['colCheck'] : document.getElementById('colCheck');

    if (oColCheck != undefined) {
        if (oColCheck.length != undefined) {
            for (var i = 0; i < oColCheck.length; i++) {
                oColCheck[i].style.display = 'none'; oColCheck[i].style.visibility = 'hidden';
            }
        } else {
            oColCheck.style.display = 'none'; oColCheck.style.visibility = 'hidden';
        }
    }

    var hdrMC = GetElementFromGrid(GRID + '_chk0').style; hdrMC.display = 'none'; hdrMC.visibility = 'hidden';

    GetElementFromGrid(GRID + '_ModoCheck').checked = false;
}

$(document).ready(function () {
    if (!(typeof GRID === 'undefined')) {
        if (GRID != null) {
            if (GetElementFromGrid(GRID + '_ModoCheck').checked) {
                //si estoy en ModoCheck
                CheckRenderRows(GetElementFromGrid(GRID + '_EnableDeletedRows').checked); //dibujo los checks
                CheckShowColumn(); //cambio el style para mostrar la columna
            }
        }
    }
});

/* :::::::::::::::::::::::::::::: Table Resizing code ::::::::::::::::::::::::::::::: */
var sResizableElement = "TH";    // This MUST be upper case
var iMinResize = 8;
var iEdgeThreshold = 8;
var sVBarID = "VBar";
var oResizeTarget = null;
var iStartX = null;
var iEndX = null;
var iSizeX = null;

/* :::::::::: Helper Functions :::::::::: */
function TableResize_CreateVBar() {
    var objItem = document.getElementById(sVBarID);

    if (!objItem) {
        objItem = document.createElement("SPAN");

        objItem.id = sVBarID;
        objItem.style.position = "absolute";
        objItem.style.top = "0px";
        objItem.style.left = "0px";
        objItem.style.height = "0px";
        objItem.style.width = "2px";
        objItem.style.background = "silver";
        objItem.style.borderLeft = "1px solid black";
        objItem.style.display = "none";

        document.body.appendChild(objItem);
    }
}

window.attachEvent("onload", TableResize_CreateVBar);

function TableResize_GetOwnerHeader(objReference) {
    var oElement = objReference;

    while (oElement != null && oElement.tagName != null && oElement.tagName != "BODY") {
        if (oElement.tagName.toUpperCase() == sResizableElement) {
            return oElement;
        }
        oElement = oElement.parentElement;
    }
    // The TH wasn't found
    return null;
}

function TableResize_CleanUp() {
    var oVBar = document.getElementById(sVBarID);

    if (oVBar) {
        oVBar.runtimeStyle.display = "none";
    }

    iEndX = null;
    iSizeX = null;
    iStartX = null;
    oResizeTarget = null;
    oAdjacentCell = null;
    //Set initial values for var's of searchLastChild
    iSon = 1;
    foundChild = false;
    idToSearch = null;

    return true;
}

/* :::::::::: Main Functions :::::::::: */
function TableResize_OnMouseMove(objTable) {
    var objTH = TableResize_GetOwnerHeader(event.srcElement);

    if (!objTH)
        return;

    var oVBar = document.getElementById(sVBarID);

    if (!oVBar)
        return;

    if ((event.offsetX >= (objTH.offsetWidth - iEdgeThreshold))) {
        objTH.runtimeStyle.cursor = "col-resize";
    }
    else {
        if (objTH.style.cursor) {
            objTH.runtimeStyle.cursor = objTH.style.cursor;
        }
        else {
            objTH.runtimeStyle.cursor = "";
        }
    }
    if (oVBar.runtimeStyle.display == "inline") {
        oVBar.runtimeStyle.left = window.event.clientX + document.body.scrollLeft;
        document.selection.empty();
    }
    return true;
}

function TableResize_OnMouseDown(objTable) {
    var oTargetCell = event.srcElement;

    if (!oTargetCell)
        return;

    var oVBar = document.getElementById(sVBarID);

    if (!oVBar)
        return;

    if (oTargetCell.parentElement.tagName.toUpperCase() == sResizableElement) {
        oTargetCell = oTargetCell.parentElement;
    }

    if (oTargetCell.id.length==0)
        return;

    if (oTargetCell.runtimeStyle.cursor == "col-resize") {
        iStartX = event.screenX;
        oResizeTarget = oTargetCell;

        objTable.setAttribute("Resizing", "true");
        objTable.setCapture();

        oVBar.runtimeStyle.left = window.event.clientX + document.body.scrollLeft;
        oVBar.runtimeStyle.top = objTable.parentElement.offsetTop + objTable.offsetTop; ;
        oVBar.runtimeStyle.height = objTable.parentElement.clientHeight;
        oVBar.runtimeStyle.display = "inline";
    }
    return true;
}

function TableResize_OnMouseUp(objTable) {
    
    if (iStartX != null && oResizeTarget != null) {
        HuboCambios = -1;
        iEndX = event.screenX;
        iSizeX = iEndX - iStartX;
        objTable.setAttribute("Resizing", "false");

        var oTmpHeaderCell = oResizeTarget;
        if (oTmpHeaderCell.cantHijos > 0)
            oTmpHeaderCell = searchLastChild(oTmpHeaderCell, oTmpHeaderCell.cantHijos);

        var iResizeOldWidth = oTmpHeaderCell.scrollWidth;
        var oHeaderCell = oTmpHeaderCell.childNodes[0];
        if (oHeaderCell.id.length == 0)
            return;

        if (iResizeOldWidth + iSizeX > iMinResize) {
            oHeaderCell.style.posWidth = iResizeOldWidth + iSizeX;
        } else {
            oHeaderCell.style.posWidth = iMinResize;
        }
        //Resizeo la tabla
        objTable.style.posWidth = objTable.style.posWidth + iSizeX;
        //Resizeo el/los ancestros
        resizeParent(oHeaderCell.parentNode.id, oHeaderCell.style.posWidth);
        //Resizeo las columnas
        resizeColumn(oHeaderCell.id, oHeaderCell.style.posWidth);
    }
    TableResize_CleanUp();
    objTable.releaseCapture();
    GrabarAnchos(oHeaderCell)
    return true;
}

function resizeParent(pHeaderId, pWidth) {
    var iRep = pHeaderId.substring(1, 2);
    var idChild;
    if (iRep != 0) {
        var strChild = document.getElementById('c' + (iRep - 1) + pHeaderId.substring(2, pHeaderId.length - 2));
        if (strChild != null)
            idChild = strChild.cantHijos;
        else
            idChild = document.getElementById('c' + (iRep - 1) + pHeaderId.substring(2, pHeaderId.length - 3)).cantHijos;
    }

    var selCol = pHeaderId.substring(pHeaderId.lastIndexOf('_') + 1);

    if (iRep == 0) {
        document.getElementById(pHeaderId).childNodes[0].style.posWidth = pWidth;
    } else if (iRep != 0 && idChild == 1) {
        pHeaderId = pHeaderId.substring(2);
        while (iRep != 0) {
            if (selCol < 10)
                pHeaderId = pHeaderId.substring(0, pHeaderId.length - 2);
            else
                pHeaderId = pHeaderId.substring(0, pHeaderId.length - 3);

            iRep--;
            document.getElementById('c' + iRep + pHeaderId).childNodes[0].style.posWidth = pWidth;
        }
    } else if (iRep != 0 && idChild != 1) {
        var width = 0;
        var pH;
        if (selCol < 10) {
            pH = pHeaderId.substring(0, pHeaderId.length - 2);
            pHeaderId = pHeaderId.substring(2, pHeaderId.length - 2);
        } else {
            pH = pHeaderId.substring(0, pHeaderId.length - 3);
            pHeaderId = pHeaderId.substring(2, pHeaderId.length - 3);
        }
        iRep--;

        for (var j = 1; j <= idChild; j++) {
            width += document.getElementById(pH + '_' + j).childNodes[0].style.posWidth;
        }
        resizeParent('c' + iRep + pHeaderId, width);
    }
}

function resizeColumn(pHeaderId, pWidth) {
    var totalCell = document.getElementsByTagName('td');
    for (var h = 0; h < totalCell.length; h++) {
        if (totalCell[h].id == pHeaderId) {
            totalCell[h].childNodes[0].style.posWidth = pWidth;
        }
    }
}

var iSon = 1; var foundChild = false; var idToSearch = null;
var th = document.getElementsByTagName('th');

function searchLastChild(node, cantHijos) {
    var retSon = null;
    var auxSon = null;
    var iP = node.id.substring(1, 2);
    var str = node.id.substring(2);
    iP++;

    idToSearch = 'c' + iP + str + '_' + cantHijos;

    while (iSon < th.length || !foundChild) {
        auxSon = th[iSon];
        if (auxSon.id == idToSearch) {
            if (auxSon.cantHijos > 0) {
                retSon = searchLastChild(auxSon, auxSon.cantHijos)
            } else {
                retSon = auxSon;
                foundChild = true;
            }
        }
        iSon++;
    }
    return retSon
}

/*function ShowGrid() {
    document.getElementById(GRID).style.display = '';
    HideFrame();
}

function HideGrid() {
    document.getElementById(GRID).style.display = 'none';
}

function ShowFrame(pUrl) {
    HideGrid();

    document.getElementById('ifraAux').style.display = '';
    document.getElementById('ifraAux').src = pUrl;
}

function HideFrame() {
    document.getElementById('ifraAux').style.display = 'none';
}*/

function GetGridData() {
    var pGrid = GetGrid();

    return { GridID: pGrid.GridID, SessionID: pGrid.SessionID };
}