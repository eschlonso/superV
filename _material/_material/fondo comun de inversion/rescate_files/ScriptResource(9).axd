//ComboEditor.js

var ShowTimer = null;
var TextTimer = null;
var MensajeEstructuraNoCreada = 'La estructura no fue creada. Verifique que exista y que la conexión haya sido asignada al combo';
var KeyValueSeparator = '@@';
var ValueSeparator = '==';
var CallBackHeadClick = 'HEAD';
var CallBackHeadReturn = 'HEADRETURN';
var CallBackShowRecords = 'SRCH';
var CallBackSelectFirst = 'SEL1';
var CallBackMoreRows = 'ADDR';
var CallBackMenuClick = 'MEN';
var pFirstOpen = true;

/*========================================================================================
*  Funciones comunes del combo.
*========================================================================================*/
function getIDFromClientID(pClientID) {
    var pCombo = document.getElementById(pClientID + ServerID_Prefix);
    var pComboID = '';

    if (typeof (pCombo) != 'undefined' && pCombo != null) {
        pComboID = pCombo.value;
    }
    return pComboID;
}

function getParametroCbo(cboid, parametro) {
    // a esta función se le puede pasar un combo y un nombre de parámetro y retorna su valor
    var outValue = GetCodOutValue(cboid);
    var parametros = outValue.split(KeyValueSeparator);
    var Valor = '';
    for (x in parametros) {
        if (parametros[x].indexOf(parametro + ValueSeparator) != -1) {
            Valor = parametros[x].replace(parametro + ValueSeparator, '');
        }
    }
    return Valor;
}

function getParametroCombo(cboid, parametro) {
    var Valor = '';

    if (getParametroCbo(cboid, parametro) != '')
        return getParametroCbo(cboid, parametro);
    else {
        var outValue = GetNonCodOutValue(cboid);
        var parametros = outValue.split(KeyValueSeparator);
        for (x in parametros) {
            if (parametros[x].indexOf(parametro + ValueSeparator) != -1) {
                Valor = parametros[x].replace(parametro + ValueSeparator, '');
            }
        }
        return Valor;
    }
}

function GetState(cboId) {
    return document.getElementById(cboId + State_Prefix);
}

function ValidateInput(evt) {
    var pValidInput = true;
    var pKey = 0;

    if (evt != null) {
        if (evt.charCode) {
            pKey = evt.charCode;
        } else {
            pKey = evt.keyCode;
        }

        if (pKey != 0) {
            if (pKey == 27) {
                //'ESC: Cierra el combo.
                CloseCombo(cboId);
                pValidInput = false;
            } else {
                if ((pKey < 32 && pKey != 8) || (pKey > 32 && pKey < 46)) {
                    //'Keys Omitidas: Ver referencia al final del procedimiento.
                    pValidInput = false;
                }
            }
        }
    } else {
        pValidInput = false;
    }
    return pValidInput;
}

function IsModoFlt(pComboID) {
    var pState = GetState(pComboID);
    var pValues = '';
    var pModoFiltro = 1;
    var pProperties = null;

    if (typeof (pState) != 'undefined' && pState != null) {
        pValues = pState.value;
        pProperties = pValues.split(KeyValueSeparator);

        if (pProperties.length >= 2) {
            pModoFiltro = parseInt(pProperties[1]);
        }
    }

    return pModoFiltro;
}

function CallBackErrorCbo(result, context) {
    OpenMessageText(result);
}

function ComboOverSetClass(pCombo, pClassName) {
    if (typeof (pCombo) != 'undefined' && pCombo != null) {
        pCombo.className = pClassName;
    }
}

function GetCodOutValue(pComboID) {
    var pCodOutVal = '';
    var pCodOutID = pComboID + CodOut_Prefix;
    var pCodOut = document.getElementById(pCodOutID);

    if (typeof (pCodOut) != 'undefined' && pCodOut != null) {
        pCodOutVal = pCodOut.value;
    } else {
        OpenMessageText('El combo ' + pComboID + ' no pudo ser encontrado');
        pCodOutVal = '';
    }
    return pCodOutVal.replace(/&nbsp;/g, '');
}

function GetNonCodOutValue(pComboID) {
    var pNonCodOutVal = '';
    var pNonCodOutID = pComboID + NonCodOut_Prefix;
    var pNonCodOut = document.getElementById(pNonCodOutID);

    if (typeof (pNonCodOut) != 'undefined' && pNonCodOut != null) {
        pNonCodOutVal = pNonCodOut.value;
    } else {
        OpenMessageText('El combo ' + pComboID + ' no pudo ser encontrado');
        pNonCodOutVal = '';
    }
    return pNonCodOutVal.replace(/&nbsp;/g, '');
}

function GetCodInValue(pComboID) {
    var pCodInVal = '';
    var pCodInID = pComboID + CodIn_Prefix;
    var pCodIn = document.getElementById(pCodInID);

    if (typeof (pCodIn) != 'undefined' && pCodIn != null) {
        pCodInVal = pCodIn.value;
    } else {
        OpenMessageText('El combo ' + pComboID + ' no pudo ser encontrado');
        pCodInVal = '';
    }
    return pCodInVal.replace(/&nbsp;/g, '');
}

function GetCboPk(pComboID) {
    return document.getElementById(pComboID + CodPK_Prefix).value;
}

function SetCboPk(pComboID, pVal) {
    document.getElementById(pComboID + CodPK_Prefix).value = pVal;
}


function CopyToChild(pID, pCodIn, pPadre) {
    var pControl = document.getElementById(pID);
    var pPosition = -1;
    var pCod = '';
    var pControlValue = '';
    var pCodNew = pCodIn;
    var pValues = null;
    var pValPadre = null;
    var pCodPadre = '';
    var pPosPadre = -1;
    var pBorrarPadre = -1;

    if (typeof (pControl) != 'undefined' && pControl != null) {
        pControlValue = pControl.value;
        pValues = pControlValue.split(KeyValueSeparator);
        if (typeof (pPadre) != 'undefined' && pPadre != null) {
            pValPadre = pPadre.defaultValue.split(KeyValueSeparator)
            //recorro el hijo    
            for (var pValueCount1 = 1; pValueCount1 < pValues.length; pValueCount1++) {
                pPosition = pValues[pValueCount1].indexOf(ValueSeparator);
                if (pPosition != -1) {
                    pBorrarPadre = -1;
                    pCod = pValues[pValueCount1].substring(0, pPosition + 2);
                    // busco los campos filtros en el padre que se borraron
                    for (var pValPadreCount = 1; pValPadreCount < pValPadre.length; pValPadreCount++) {
                        pPosPadre = pValPadre[pValPadreCount].indexOf(ValueSeparator);
                        pCodPadre = pValPadre[pValPadreCount].substring(0, pPosPadre + 2);
                        if ((pCod == pCodPadre) && (pCodPadre != 'Anulado==')) { pBorrarPadre = 1; }
                    }
                    if ((pCodNew.indexOf(pCod) == -1) && (pBorrarPadre == -1)) {
                        pCodNew = pCodNew + KeyValueSeparator + pValues[pValueCount1];
                    } else {
                        pCodNew = pCodNew + KeyValueSeparator + pCod + '-1'
                    }
                }
            }
        } else {
            for (var pValueCount2 = 1; pValueCount2 < pValues.length; pValueCount2++) {
                pPosition = pValues[pValueCount2].indexOf(ValueSeparator);
                if (pPosition != -1) {
                    pCod = pValues[pValueCount2].substring(0, pPosition + 2);
                    // El campo viejo no fue reemplazado, entonces lo vuelvo a poner
                    if (pCodNew.indexOf(pCod) == -1) {
                        pCodNew = pCodNew + KeyValueSeparator + pValues[pValueCount2];
                    }
                }
            }
        }
        pControl.value = pCodNew;
        pControl.onchange();
    }
}

function EnableButtonCombo(pComboID) {
    var pButtonID = pComboID + ButtonOpen_Prefix;
    $('input[name=' + pButtonID + ']').attr('src', OpenComboGif);
    $('input[name=' + pButtonID + ']').removeAttr('disabled');
    $('input[name=' + pButtonID + ']').css('cursor', 'pointer');
}

function DisableButtonCombo(pComboID) {
    var pButtonID = pComboID + ButtonOpen_Prefix;
    $('input[name=' + pButtonID + ']').attr('src', OpenComboDisabledGif);
    $('input[name=' + pButtonID + ']').attr('disabled', 'disabled');
    $('input[name=' + pButtonID + ']').css('cursor', 'none');
}

function AutoCloseCombo() {
    CloseCombo('');
}

function SetAutoCloseCombo() {
    ShowTimer = window.setTimeout("AutoCloseCombo();", 1500);
}

function CancelAutoCloseCombo() {
    clearTimeout(ShowTimer);
}

/*------------------------------------------------------------------------------
Click en el combo. Abre la ventana de modificación.
------------------------------------------------------------------------------*/
function ComboHeaderClick(pComboID) {
    var pCodOut = document.getElementById(pComboID + CodOut_Prefix);
    var pArguments = '';

    if (typeof (pCodOut) != 'undefined' && pCodOut != null) {
        pArguments = CallBackHeadClick + ParameterSeparator + pCodOut.value;

        CallServerHead(pArguments, pComboID);
    }
}

function ComboHeaderClickCallBack(pResult, pContext) {
    if (typeof (pResult) != null && pResult != null) {
        var pCadena = pResult.split(",");
        if (pCadena.length >= 7) {
            ExecEntTpAccion(pCadena[0], pCadena[1], pCadena[2], pCadena[3], pCadena[4], pCadena[5], pCadena[7], pContext, pCadena[7], pCadena[6]);
        }
    }
}

function RowHeaderCboChangeReturn(pComboID, pKey) {
    var pCodOut = document.getElementById(pComboID + CodOut_Prefix);
    var pArguments = '';

    if (typeof (pCodOut) != 'undefined' && pCodOut != null) {
        pArguments = CallBackHeadReturn + ParameterSeparator + pCodOut.value;
        CallServerHeadCboChange(pArguments, pComboID);
    }
}


/*------------------------------------------------------------------------------
More rows.
------------------------------------------------------------------------------*/
function MoreRowsCbo() {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pCombo = null;
    var pCodIn = null;
    var pComboID = '';
    var pText = '';
    var pArguments = '';
    var pRowsToShow = -1

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        pCombo = igedit_getById(pComboID + Combo_Prefix);

        if (typeof (pCombo) != 'undefined' && pComboID != null) {
            pText = pCombo.getText();
            pCodIn = document.getElementById(pComboID + CodIn_Prefix);

            SetMoreRowsShowed(pComboID);
            pRowsToShow = GetActualRowsShowed(pComboID);

            if (typeof (pCodIn) != 'undefined' && pCodIn != null) {
                pArguments = CallBackMoreRows + ParameterSeparator + pRowsToShow.toString() + ParameterSeparator + pText + ParameterSeparator + pCodIn.value;
                CallServerCbo(pArguments, pComboID);
            }
        }
    }
}

function SetMoreRowsShowed(pComboID) {
    var pState = GetState(pComboID);
    var pValues = pState.value;
    var pProperties = pValues.split(KeyValueSeparator);
    var pRows = parseInt(pProperties[0]) + pRowsToAdd;

    if (typeof (pState) != 'undefined' && pState != null) {
        pValues = pState.value;
        pProperties = pValues.split(KeyValueSeparator);
        if (pProperties.length >= 2) {
            pRows = parseInt(pProperties[0]) + pRowsToAdd;
            pState.value = pRows.toString() + KeyValueSeparator + pProperties[1];
        }
    }
}
/*------------------------------------------------------------------------------
Seleccionar primero.
------------------------------------------------------------------------------*/
function CallBackResSel1(pResult, pContext, pFromCallBack) {
    var pComboID = pContext.replace(/\$/g, '_'); //para poder reemplazar en todas las apariciones se necesita la regex, ID 26320
    var pGrid = document.getElementById(GridContainer);
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pRowID = pComboID + Grid_Prefix + '_0';


    if (typeof (pGrid) != 'undefined' && pGrid != null &&
       typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pGrid.innerHTML = pResult;
        pCurrentCombo.value = pComboID;
        ComboRowClick(pRowID, pComboID + Grid_Prefix, true);
    }
}
/*------------------------------------------------------------------------------
Menu click.
------------------------------------------------------------------------------*/
function getDivMenu(pWidth, pHeight, pComboID) {
    var pFrameMenu = document.getElementById('DivMenu');
    var pCodOut = document.getElementById(pComboID + CodOut_Prefix);
    var pBody = document.body;
    var pDREspacioAlto = -1;
    var pDREspacioAncho = -1;
    var pLeft = 10;
    var pTop = 10;
    var pArguments = '';

    if (typeof (pCodOut) != 'undefined' && pCodOut != null) {
        try {
            pTop = pBody.scrollTop + event.clientY - event.offsetY;
        } catch (ex) {
            pTop = (pBody.offsetHeight * 1 - pBody.clientWidth) + 'px';
        }

        try {
            pLeft = pBody.scrollLeft + event.clientX - event.offsetX;
        } catch (ex) {
            pLeft = 10;
        }

        pDREspacioAlto = Number(pTop) + Number(pHeight.replace(/px/g, ''));
        pDREspacioAncho = Number(pLeft) + Number(pWidth.replace(/px/g, ''));

        if (pDREspacioAlto > pBody.clientHeight) {
            pTop = pBody.clientHeight - Number(pHeight.replace(/px/g, '')) - 5;
        }

        if (pDREspacioAncho > pBody.clientWidth) {
            pLeft = pBody.clientWidth - Number(pWidth.replace(/px/g, '')) - 5;
        }

        if (pTop < 0) {
            pTop = '0px';
        }
        if (pLeft < 0) {
            pLeft = '0px';
        }

        pFrameMenu.style.top = pTop;
        pFrameMenu.style.left = pLeft;
        pFrameMenu.style.width = pWidth;
        pFrameMenu.style.height = pHeight;
        pFrameMenu.style.zIndex = 1008;
        //pFrameMenu.style.display = 'block';
        window.setTimeout(hideDivMenu, 3000);

        pArguments = CallBackMenuClick + ParameterSeparator + pCodOut.value;
        CallServerDiv(pArguments, pComboID);
    }
}
/*------------------------------------------------------------------------------
Click en el combo. Abre la ventana de modificación.
------------------------------------------------------------------------------*/
function SelectFirstParentChanged(pComboID) {
    var pCodIn = document.getElementById(pComboID + CodIn_Prefix);
    var pArguments = '';

    if (typeof (pCodIn) != 'undefined' && pCodIn != null) {
        pArguments = CallBackSelectFirst + ParameterSeparator + pCodIn.value;
        CallServerSel1(pArguments, pComboID);
    }
}
/*------------------------------------------------------------------------------
Muestra la grilla del combo.
------------------------------------------------------------------------------*/
function ShowRecords(pComboID, pWidth, pHeight, evt) {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pTableDisplay = null;
    var pTableSearch = null;
    var pCurrentComboID = '';
    var pState = '';
    var pCombo = '';
    var pCodIn = '';
    var pTable = '';
    var pArguments = '';
    var pPosition = null;
    var pComboWidth = 0;
    var pComboHeight = 0;
    var pComboTop = 0;
    var pComboLeft = 0;
    var pIsOpenCombo = false;

    clearTimeout(ShowTimer);
    clearTimeout(TextTimer);

    if (ValidateInput(evt)) {
        if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
            if (pCurrentCombo.value != pComboID) {
                CloseCombo(pCurrentCombo.value);
                pCurrentCombo.value = pComboID;
            }

            pState = GetState(pComboID);

            if (typeof (pState) != 'undefined' && pState != null) {
                pCombo = igedit_getById(pComboID + Combo_Prefix);
                pCodIn = document.getElementById(pComboID + CodIn_Prefix);
                pTable = document.getElementById(DropDownContainer);
                pTableDisplay = getAbsoluteElementPosition(document.getElementById(pComboID + TblDisplay_Prefix));
                pTableSearch = getAbsoluteElementPosition(document.getElementById(pComboID + TblSearch_Prefix));

                if (typeof (pTable) != 'undefined' && pTable != null &&
                     typeof (pCombo) != 'undefined' && pCombo != null &&
                     typeof (pTableDisplay) != 'undefined' && pTableDisplay != null &&
                     typeof (pTableSearch) != 'undefined' && pTableSearch != null &&
                     typeof (pCodIn) != 'undefined' && pCodIn != null) {

                    if (pTableDisplay.left > pTableSearch.left || pTableDisplay.top > pTableSearch.top) {
                        pPosition = pTableDisplay;
                    } else {
                        pPosition = pTableSearch;
                    }

                    pComboWidth = parseInt(pWidth);
                    pComboHeight = parseInt(pHeight);
                    pComboTop = 0;
                    pComboLeft = pPosition.left;

                    pAlto = pPosition.top + pDropDownOffset + pComboHeight;
                    if (pPosition.top < pComboHeight) {
                        pComboTop = pPosition.top + pDropDownOffset;
                        pResto = document.body.offsetHeight - pPosition.top;

                        if (pResto <= pComboHeight + pDropDownOffset) {
                            if (pResto >= BotonCboHeight) {
                                pComboHeight = pResto - BotonCboHeight;
                            } else {
                                pComboHeight = 0;
                            }
                        }
                    } else {
                        if (pAlto < document.body.offsetHeight) {
                            pComboTop = pPosition.top + pDropDownOffset;
                        }
                        else {
                            pComboTop = pPosition.top - parseInt(pHeight);
                        }
                    }
                    //}

                    // pTable.style.position = 'absolute';
                    pTable.style.top = pComboTop + 'px'
                    pTable.style.left = pComboLeft + 'px'
                    pTable.style.height = pComboHeight + 'px';
                    pTable.style.zIndex = 5000;
                    pTable.style.width = pComboWidth + 'px';

                    DisableButtonCombo(pComboID);
                    pIsOpenCombo = ((evt.charCode == 0 | typeof evt.charCode == "undefined") && (evt.keyCode == 0));
                    ShowSearch(evt);
                    pArguments = CallBackShowRecords + ParameterSeparator + pCombo.getText() + ParameterSeparator + pCodIn.value;
                    pFirstOpen = false;
                    HideDisplay();

                    if (pIsOpenCombo) {
                        // Si el usuario pide ver la grilla se muestra sin delay
                        CallServerCbo(pArguments, pComboID);
                    } else {
                        // 'Si la grilla se muestra porque el usuario escribe, entonces se incluye un delay para esperar que el usuario termine de escribir
                        SetShowRecords(pArguments, pComboID);
                    }
                } else {
                    OpenMessageText(MensajeEstructuraNoCreada);
                }
            } else {
                OpenMessageText(MensajeEstructuraNoCreada);
            }
        }
    }
    return false;
}

function ShowDisplay() {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pTableDisplayID = '';
    var pTableDisplay = '';

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        pTableDisplayID = pComboID + TblDisplay_Prefix;
        pTableDisplay = document.getElementById(pTableDisplayID);

        pTableDisplay.style.display = 'inline-block';
    }
}

function HideDisplay() {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pTableDisplayID = '';
    var pTableDisplay = '';

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        pTableDisplayID = pComboID + TblDisplay_Prefix;
        pTableDisplay = document.getElementById(pTableDisplayID);

        pTableDisplay.style.display = 'none';
    }
}

function ShowSearch(evt) {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pTableSearchID = '';
    var pTableSearch = '';
    var pCombo = null;

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        pTableSearchID = pComboID + TblSearch_Prefix;
        pTableSearch = document.getElementById(pTableSearchID);

        if (document.all) {
            pTableSearch.style.display = 'inline';
        } else {
            pTableSearch.style.display = 'inline-block';
        }

        if (pFirstOpen) {
            pCombo = igedit_getById(pComboID + Combo_Prefix);
            var pText = GetDisplayText();
            if ((pText == null) || (pText == '') || (pText == 'undefined')) {
                if (evt.keyCode) {
                    pText = String.fromCharCode(evt.keyCode);
                }
            }
            pCombo.setText(pText);
        }
    }
}

function HideSearch() {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pTableSearchID = '';
    var pTableSearch = '';

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        pTableSearchID = pComboID + TblSearch_Prefix;
        pTableSearch = document.getElementById(pTableSearchID);

        pTableSearch.style.display = 'none';
    }
}

function GetDisplayText() {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pTableDisplayID = '';
    var pTableDisplay = '';
    var pText = '';

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        pTableDisplayID = pComboID + TblDisplay_Prefix;
        pTableDisplay = document.getElementById(pTableDisplayID);

        pText = pTableDisplay.rows[0].cells[0].innerHTML;
    }
    return pText;
}

/*------------------------------------------------------------------------------
Eventos sobre la grilla del combo.
------------------------------------------------------------------------------*/
function ComboRowClick(pRowID, pGridID, pFromCallBack) {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pCodOutID = '';
    var pNonCodOutID = '';
    var pTableDisplayID = '';

    var pCodOut = null;
    var pNonCodOut = null;
    var pstrCodOut = '';
    var pstrNonCodOut = '';
    var pModoFiltro = false;

    var pCombo = null;
    var pTableDisplay = null;
    var pRow = null;
    var pRowDest = null;
    var pFooterRow = null;
    var pText = '';

    var pProcesado = 0;
    var pVisibleCellCount = 0;

    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;
        if (!pGridID) {
            pGridID = pComboID + Grid_Prefix;
        }

        pCodOutID = pComboID + CodOut_Prefix;
        pNonCodOutID = pComboID + NonCodOut_Prefix;
        pTableDisplayID = pComboID + TblDisplay_Prefix;
        pCodOut = document.getElementById(pCodOutID);
        pNonCodOut = document.getElementById(pNonCodOutID);
        pModoFiltro = IsModoFlt(pComboID);
        pTableDisplay = document.getElementById(pTableDisplayID);

        if (typeof (pTableDisplay) != 'undefined' && pTableDisplay != null) {

            pRow = document.getElementById(pRowID);
            pRowDest = pTableDisplay.rows[0];
            pFooterRow = document.getElementById(pGridID).rows[document.getElementById(pGridID).rows.length - 1];

            // Armo la descripcion para mostrar en el texto del combo y los codigos para pasar a otros combos.
            if (typeof (pRow) != 'undefined' && pRow != null) {

                if (typeof (pFooterRow) != 'undefined' && pFooterRow != null) {
                    for (var pCellCount = 0; pCellCount < pRow.cells.length; pCellCount++) {
                        if (pRow.cells[pCellCount].style.display != 'none') {
                            pstrNonCodOut += KeyValueSeparator + pFooterRow.cells[pCellCount].innerHTML + ValueSeparator + pRow.cells[pCellCount].innerHTML;
                            //o dibujo en la tabla o dejo el text con los datos de la fila elegida porque esta en modo filtro
                            if (pModoFiltro == 0) {
                                if (typeof (pRowDest) != 'undefined' && pRowDest != null) {
                                    //TODO:Acá escribe el reesultado de la seleccion
                                    pRowDest.cells[pVisibleCellCount].innerHTML = pRow.cells[pCellCount].innerHTML;
                                    pRowDest.cells[pVisibleCellCount].title = pFooterRow.cells[pCellCount].innerHTML + ':' + pRow.cells[pCellCount].innerHTML;
                                    pRowDest.cells[pVisibleCellCount].click = CloseCombo(pComboID);
                                }
                            } else {
                                if (pProcesado == 0) {
                                    pCombo = igedit_getById(pComboID + Combo_Prefix);
                                    pText = pRow.cells[pCellCount].innerText;
                                    pCombo.setText(pText);
                                    pProcesado = -1;
                                }
                            }
                            pVisibleCellCount++;
                        } else {
                            pstrCodOut += KeyValueSeparator + pFooterRow.cells[pCellCount].innerHTML + ValueSeparator + pRow.cells[pCellCount].innerHTML;
                        }
                    }
                }

                if (pCodOut.value != pstrCodOut) {
                    pCodOut.value = pstrCodOut;
                    pNonCodOut.value = pstrNonCodOut;
                    if (pCodOut.onchange) {
                        pCodOut.onchange();
                    }
                }

                CloseCombo(pComboID);

                if (pModoFiltro == 0) {
                    pCombo = igedit_getById(pComboID + Combo_Prefix);
                    pCombo.setText(GetDisplayText());
                    _Validator = document.getElementById(pNonCodOutID + '_rfv');
                    if (_Validator != null) {
                        ValidatorValidate(_Validator);
                    }
                }

            } else {
                if (pModoFiltro == 0) {
                    SelectNoneWithComboID(pComboID);
                }
            }
            if (!pFromCallBack) SetActiveTextByComboID(pComboID, false);
        }
    }
}

function ComboRowMouseMove(pRowID) {
    var pRow = document.getElementById(pRowID)
    if (typeof (pRow) != 'undefined' && pRow != null) {
        pRow.className = 'ec_ComboEditor_Grid_Row_Over';
    }
}

function ComboRowMouseOut(pRowID) {
    var pRow = document.getElementById(pRowID)
    if (typeof (pRow) != 'undefined' && pRow != null) {
        pRow.className = 'ec_ComboEditor_Grid_Row';
    }
}


/*------------------------------------------------------------------------------
Acciones
------------------------------------------------------------------------------*/
function ComboSelectNone() {
    var pCombo = document.getElementById(CurrentComboID);
    var pComboID = '';
    var pNonCodOutId = '';

    if (typeof (pCombo) != 'undefined' && pCombo != null) {
        pComboID = pCombo.value;
        pNonCodOutId = pComboID + NonCodOut_Prefix;

        SelectNoneWithComboID(pComboID);
        _Validator = document.getElementById(pNonCodOutId + '_rfv');

        if (typeof (_Validator) != 'undefined' && _Validator != null) {
            ValidatorValidate(_Validator);
        }
    }
}

function SelectNoneWithComboID(pComboID, pNoOnChange) {
    var pCodOutID = pComboID + CodOut_Prefix;
    var pNonCodOutID = pComboID + NonCodOut_Prefix;
    var pCodOut = document.getElementById(pCodOutID);
    var pNonCodOut = document.getElementById(pNonCodOutID);
    var pCombo = igedit_getById(pComboID + Combo_Prefix);

    if (typeof (pCombo) != 'undefined' && pCombo != null &&
        typeof (pCodOut) != 'undefined' && pCodOut != null &&
        typeof (pNonCodOut) != 'undefined' && pNonCodOut != null) {
        pCombo.setText('');
        pNonCodOut.value = '';

        if (pCodOut.value != '') {
            pCodOut.defaultValue = pCodOut.value;
            pCodOut.value = '';

            if (pCodOut.onchange && !(pNoOnChange == true || pNoOnChange == '-1')) {
                pCodOut.onchange();
            }
        }

        CloseCombo(pComboID);
        SetActiveTextByComboID(pComboID, true);
    }
}

function CloseCombo(pComboID) {
    var pCombo = null;
    var pTable = null;
    var pTableDisplay = null;
    var pTableSearch = null;
    var pCodOut = null;
    var pTableDisplayID = '';
    var pTableSearchID = '';
    var pText = '';
    var pCodOutID = '';
    var pDisplay = '';
    var pModoFiltro = 1;

    clearTimeout(ShowTimer);

    if (pComboID == '') {
        pCombo = document.getElementById(CurrentComboID);
        if (typeof (pCombo) != 'undefined' && pCombo != null) {
            pComboID = pCombo.value;
        }
    }

    if (pComboID != '') {
        pTableDisplayID = pComboID + TblDisplay_Prefix;
        pTableSearchID = pComboID + TblSearch_Prefix;
        pCodOutID = pComboID + CodOut_Prefix;
        var enabled = cboGetEnabled(pComboID.replace(/\$/g, '_')); //para poder reemplazar en todas las apariciones se necesita la regex, ID 26320

        pTableDisplay = document.getElementById(pTableDisplayID);
        pTableSearch = document.getElementById(pTableSearchID);
        pTable = document.getElementById(DropDownContainer);
        pCodOut = document.getElementById(pCodOutID);

        if (typeof (pTable) != 'undefined' && pTable != null) {
            pTable.style.display = 'none';

            if (typeof (pTableDisplay) != 'undefined' && pTableDisplay != null &&
                typeof (pCodOut) != 'undefined' && pCodOut != null &&
                typeof (pTableSearch) != 'undefined' && pTableSearch != null
            ) {
                pText = pCodOut.value;
                pModoFiltro = IsModoFlt(pComboID);

                if (document.all) {
                    pDisplay = 'inline';
                } else {
                    pDisplay = 'inline-block';
                }

                if (pText == '' || pModoFiltro == 1) {
                    pTableDisplay.style.display = 'none';
                    pTableSearch.style.display = pDisplay;
                } else {
                    pTableDisplay.style.display = pDisplay;
                    pTableSearch.style.display = 'none';
                }
                if (enabled) { EnableButtonCombo(pComboID); }
            } else {
                if (enabled) { EnableButtonCombo(pComboID); }
            }
        }
    }
}

function SetActiveTextByComboID(pComboID, pEnabled) {
    var pTableDisplayID = pComboID + TblDisplay_Prefix;
    var pTextBoxID = TextIG_Prefix + pComboID + Text_Prefix;
    var pTextBox = document.getElementById(pTextBoxID);
    var pTableDisplay = document.getElementById(pTableDisplayID);
    var pRowDest = null;

    if (pEnabled) {
        if (typeof (pTextBox) != 'undefined' && pTextBox != null) {
            if (typeof pTextBox.setActive === "undefined")
                pTextBox.focus();
            else
                pTextBox.setActive();
        }
    } else {
        if (typeof (pTableDisplay) != 'undefined' && pTableDisplay != null) {
            pRowDest = pTableDisplay.rows[0];

            if (typeof (pRowDest) != 'undefined' && pRowDest != null) {
                if (typeof pRowDest.cells[0].setActive === "undefined")
                    pRowDest.cells[0].focus();
                else
                    pRowDest.cells[0].setActive();

            }
        }
    }
}

function ShowFirstRecord(pComboID, pWidth, pHeight, evt) {
    var pKey = 0;
    var pCombo = null;
    var pText = '';
    var pRowID = -1
    var pCurrentCombo = null;
    var pCurrentComboID = '';

    if (evt.charCode) {
        pKey = evt.charCode;
    }
    else {
        pKey = evt.keyCode;
    }
    if (pKey != 0) {
        if (pKey == 27 || pKey == 9) {// + pCrLf 'ESC: Cierra el combo.

            pCombo = igedit_getById(pComboID + Combo_Prefix);

            if (typeof (pCombo) != 'undefined' && pCombo != null) {
                pText = pCombo.getText();
                if (pText != '') {
                    pRowID = pComboID + Grid_Prefix + '_0';

                    pCurrentCombo = document.getElementById(CurrentComboID);
                    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
                        pCurrentComboID = pCurrentCombo.value;
                        if (pCurrentComboID.value != pComboID) {
                            CloseCombo(pCurrentComboID);
                            pCurrentComboID.value = pComboID;
                        }
                    }
                    ComboRowClick(pRowID, pComboID + Grid_Prefix,false);
                }
            }
        }
    }
}

function SetShowRecords(arg, context) {
    var pDelay = pSearchDelay;
    TextTimer = window.setTimeout("CallServerCbo('" + arg + "','" + context + "');", pDelay);
}

function GetActualRowsShowed(pComboID) {
    var pState = GetState(pComboID)
    var pValues = '';
    var pProperties = null;
    var pReturn = -1;

    if (typeof (pState) != 'undefined' && pState != null) {
        pValues = pState.value;
        pProperties = pValues.split(KeyValueSeparator);

        if (pProperties.length > 0) {
            pReturn = parseInt(pProperties[0]);
        }
    }
    return pReturn;
}

function CallBackResGrid(result, context) {
    var pTable = document.getElementById(DropDownContainer);
    var pGrid = document.getElementById(GridContainer);
    var pResult = '';
    var pButton = '';

    if (typeof (pTable) != 'undefined' && pTable != null) {
        if (pTable.style.display != '') {
            pTable.style.display = '';
        }
    }

    if (typeof (pGrid) != 'undefined' && pGrid != null) {
        pGrid.innerHTML = result;
    }

    if (result.indexOf('HIDEBUTTONS') > 0) {
        pResult = result.substr(result.indexOf('HIDEBUTTONS') + 15, (result.length - 15) - (result.indexOf('HIDEBUTTONS') + 15));
        if (pResult.length > 0) {
            pButton = document.getElementById(pResult);

            if (typeof (pButton) != 'undefined' && pButton != null) {
                pButton.style.display = 'none';
            }
        }
    } else {
        if (result.indexOf('SHOWBUTTONS') > 0) {
            pResult = result.substr(result.indexOf('SHOWBUTTONS') + 15, (result.length - 15) - (result.indexOf('SHOWBUTTONS') + 15));
            if (pResult.length > 0) {
                pButton = document.getElementById(pResult);

                if (typeof (pButton) != 'undefined' && pButton != null) {
                    pButton.style.display = '';
                }
            }
        }
    }
}

function CallBackResDiv(result, context) {
    var pDiv = document.getElementById('DivMenu');

    if (typeof (pDiv) != 'undefined' && pDiv != null) {
        pDiv.innerHTML = result
        pDiv.style.display = '';
    }
}

function CallBackResHeadCboChange(pResult, pContext) {
    var pDescripcion = pResult.split('_')
    var pComboID = pContext.replace(/\$/g, '_'); //para poder reemplazar en todas las apariciones se necesita la regex, ID 26320
    var pNonCodOutID = pComboID + NonCodOut_Prefix;
    var pTableDisplayID = pComboID + TblDisplay_Prefix;
    var pFilaDest = document.getElementById(pTableDisplayID).rows[0];
    var pModoFiltro = IsModoFlt(pComboID);
    var pPrimerDescr = true;
    var pCombo = null;
    var pText = '';
    var Fila;

    // Armo la descripcion para mostrar en el texto del combo y los codigos para pasar a otros combos.
    //Fila = document.getElementById(rowId);
    if (pDescripcion) {
        for (var pDescripcionCount = 0; pDescripcionCount < pDescripcion.length; pDescripcionCount++) {

            //noncodOutString += KeyValueSeparator + FilaDest.cells[c].title.split(':')[0] + ValueSeparator + obj[c];
            //o dibujo en la tabla o dejo el text con los datos de la fila elegida porque esta en modo filtro
            if (pModoFiltro == 0) {
                pFilaDest.cells[pDescripcionCount].innerHTML = pDescripcion[pDescripcionCount];
            }

            if (pPrimerDescr) {
                pCombo = igedit_getById(pComboID + Combo_Prefix);
                pText = pDescripcion[pDescripcionCount];
                pCombo.setText(pText);
                pPrimerDescr = false;
            }
        }

        CloseCombo(pComboID);
        if (pModoFiltro == 0) {
            _Validator = document.getElementById(pNonCodOutID + '_rfv');
            if (_Validator != null) {
                ValidatorValidate(_Validator);
            }
        }
    } else {
        if (pModoFiltro == 0) {
            SelectNoneWithComboID(pComboID);
        }
    }
}



////////////////////////////////
// No tienen referencias
////////////////////////////////
function OpenCombo(pComboID, pWidth, pHeight, evt) {
    var pTableDisplay = null;
    var pTableSearch = null;
    var pTableDisplayID = pComboID + TblDisplay_Prefix;
    var pTableSearchID = pComboID + TblSearch_Prefix;

    pTableDisplay = document.getElementById(pTableDisplayID);
    pTableSearch = document.getElementById(pTableSearchID);

    if (typeof (pTableDisplay) != 'undefined' && pTableDisplay != null &&
        typeof (pTableSearch) != 'undefined' && pTableSearch != null) {
        pTableDisplay.style.display = 'none';

        if (document.all) {
            pTableSearch.style.display = 'inline';
        } else {
            pTableSearch.style.display = 'inline-block';
        }
        ShowRecords(pComboID, pWidth, pHeight, evt);
    }
}
function webCboValorParam(pComboID, pCodParam) {
    var pStringToParse = '';
    var pValue = '';

    pStringToParse = GetCodOutValue(pComboID); // 'Se busca en los códigos.
    pValue = ComboSearchString(pStringToParse, pCodParam);
    if (pValue == '-1') {
        pStringToParse = GetNonCodOutValue(pComboID); // 'Se busca en las descripciones.
        pValue = ComboSearchString(pStringToParse, pCodParam);
        if (pValue == '-1') {
            pValue = ''
        }
    }
    return pValue;
}

function ComboSearchString(pStringToParse, pCodParam) {
    var pKey = '';
    var pValue = '-1';
    var pLength = pCodParam.length;
    var pValues = pStringToParse.split(KeyValueSeparator);
    var pCodParamUpperCase = pCodParam.toUpperCase();

    if (typeof (pValues) != 'undefined' && pValues != null) {
        for (var pContadorValues = 0; pContadorValues < pValues.length; pContadorValues++) {
            pKey = pValues[pContadorValues];
            if (pKey.substr(0, pLength).toUpperCase() == pCodParamUpperCase) {
                pValue = pKey.substr(pLength + 2);
                break;
            }
        }
    }
    return pValue;
}

function ComboRowClick_Flt(pRowID) {
    var pCurrentCombo = document.getElementById(CurrentComboID);
    var pCombo = null;
    var pRow = null;
    var pComboID = '';
    var pText = '';


    if (typeof (pCurrentCombo) != 'undefined' && pCurrentCombo != null) {
        pComboID = pCurrentCombo.value;

        // Armo la descripcion para mostrar en el texto del combo.
        pRow = document.getElementById(pRowID);
        if (typeof (pRow) != 'undefined' && pRow != null) {

            for (var pCellCount = 0; pCellCount < pRow.cells.length; pCellCount++) {

                if (pRow.cells[pCellCount].style.display != 'none') {
                    pCombo = igedit_getById(pComboID + Combo_Prefix);

                    if (typeof (pCombo) != 'undefined' && pCombo != null) {
                        pText = pRow.cells[pCellCount].innerText;
                        pCombo.setText(pText);
                        OpenMessageText(pText);
                        break;
                    }
                }
            }
        }
        if (pCombo.elem.onchange) {
            pCombo.elem.onchange();
        }
        CloseCombo(pComboID);
    }
}

function UpdateValue() {

}

function EnableCombo(pComboID) {
    SelectNoneWithComboID(pComboID);
    EnableComboNoBlank(pComboID);
}

function EnableComboNoBlank(pComboID) {
    EnableButtonCombo(pComboID);
    var cbo = igedit_getById(pComboID + Combo_Prefix);
    cbo.setEnabled(true);
    $('#' + pComboID + TblDisplay_Prefix).removeAttr('disabled');
}

function DisableCombo(pComboID) {
    SelectNoneWithComboID(pComboID);
    DisableComboNoBlank(pComboID);
}

function DisableComboNoBlank(pComboID) {
    DisableButtonCombo(pComboID);
    var cbo = igedit_getById(pComboID + Combo_Prefix);
    cbo.setEnabled(false);
    $('#' + pComboID + TblDisplay_Prefix).attr('disabled', 'disabled');
}


///////////////////////////////////SET VALUE DEL COMBO////////////////////////////////
function setArrayParametrosCombo(pComboID, pParamentro, pNoOnChange) {//le paso un array de parametros para que luego haga la consulta
    for (var item in pParamentro) {
        setParametroCombo(pComboID, pParamentro[item][0], pParamentro[item][1]);
    }
    if (!pNoOnChange) {
        raiseOnChange(pComboID);
    }
}

function raiseOnChange(pComboID) {
    var pControl = document.getElementById(pComboID + CodIn_Prefix);
    if (typeof (pControl) != 'undefined' && pControl != null) {
        pControl.onchange();
    }
}

function setParametroCombo(pComboID, pParametro, pValor, pNoOnChange) {//seteandole los valores carga los parametros en el combo
    var pControl = document.getElementById(pComboID + CodIn_Prefix);
    var pPosition = -1;
    var pCod = '';
    var pControlValue = '';
    var pCodNew = KeyValueSeparator + pParametro + ValueSeparator + pValor;
    var pValues = null;

    if (typeof (pControl) != 'undefined' && pControl != null) {
        pControlValue = pControl.value;
        pValues = pControlValue.split(KeyValueSeparator);
        //Carga los parametros que le viene de los child y compara con lo que les agrego
        for (var pValueCount = 1; pValueCount < pValues.length; pValueCount++) {
            pPosition = pValues[pValueCount].indexOf(ValueSeparator);
            if (pPosition != -1) {
                pCod = pValues[pValueCount].substring(0, pPosition + 2);
                // El campo viejo no fue reemplazado, entonces lo vuelvo a poner
                if (pCodNew.indexOf(pCod) == -1) {
                    pCodNew = pCodNew + KeyValueSeparator + pValues[pValueCount];
                }
            }
        }
        pControl.value = pCodNew;
        if (!pNoOnChange) {
            raiseOnChange(pComboID);
        }
    }
} ////////////FIN////////////////

function cboGetEnabled(pComboId) {
    var pCboObj = igedit_getById(pComboId + Combo_Prefix);
    if (pCboObj) {
        return igedit_getById(pComboId + Combo_Prefix).getEnabled();
    }
}

function cboGetVisible(pComboId) {
    var pCboObj = igedit_getById(pComboId + Combo_Prefix);
    if (pCboObj) {
        return igedit_getById(pComboId + Combo_Prefix).getVisible();
    }
}
if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();