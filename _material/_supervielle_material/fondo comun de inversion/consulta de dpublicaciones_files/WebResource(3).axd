//Navigation.js

//TODO: Poner estos mensajes en el diccionario.
var ERROR_NO_FILE_SELECTED = 'No se ha seleccionado ninguna fila';
var ERROR_NO_KEY = 'No se especifica la clave del registro';
/*
    Se definen tres objetos.
    UrlData         : Contiene los datos pasados por el querystring. (claves, acciones, etc)
    WindowFeatures  : Contiene las propiedades de la ventana a abrir (height, width, scroll, etc)
    Window          : Recibe un UrlData y un WindowFeatures y abre la ventana.
*/
 
/* =====================================================================
C   L   A   S   S   E   S
=====================================================================*/
function UrlData() {
///<summary>Clase que contiene los datos de una URL y su QueryString.</summary>
    this.REDIRECTURL        = 'frwLinkRedirector.aspx';
    this.MainAction         = ''; //Abre Grilla - Abre Mensaje - Abre Entidad - etc
    this.CodEntidad         = '';
    this.Claves             = '';
    this.TpAccion           = ''; //Agregar - Modificar - Eliminar - Recuperar - etc
    this.FormID             = ''; 
    this.Combo              = '';
    this.Modo               = '';
    this.EntOp              = '';
    this.ClavesAuxiliares   = new Array();  //this.ClavesAuxiliares['name'] = value;
    this.EncryptAjaxUrl     = '';
    this.OpenSameWindow     = false;

    function ConvertToQueryString( pKey , pValue ) {
        var pReturn = '';
        if (typeof (pValue) != 'undefined' && pValue != null && pValue != '') {
            pReturn += QSC_MEMBERSEP + pKey + QSC_KEYVALUEPAIRSEP + pValue;
        }
        return pReturn;
    };

    function ConvertClavesAuxiliaresToQueryString(pClavesAuxiliares, pEncryptAjaxUrl) {
        var pReturn = '';
        var pValue = '';
        
        if (typeof (pClavesAuxiliares) != 'undefined' && pClavesAuxiliares != null) {
            for (var pKey in pClavesAuxiliares) {
                if (typeof (pKey) != 'undefined' && pKey != null && pKey.length > 0 && typeof (pClavesAuxiliares[pKey]) != 'undefined' && pClavesAuxiliares[pKey] != null && pClavesAuxiliares[pKey].length > 0) {
                    pValue = pClavesAuxiliares[pKey];
                    if (typeof (pEncryptAjaxUrl) != 'undefined' && pEncryptAjaxUrl != null && pEncryptAjaxUrl != '') {
                        pValue = EncryptText(pValue, pEncryptAjaxUrl);
                    }
                    pReturn += QSC_MEMBERSEP + pKey + QSC_KEYVALUEPAIRSEP + pValue;
                }
            }                        
        }
        return pReturn;
    };
    
    this.KeyLength = function() {
        var pKeyCount = -1;
        if ((typeof (this.Claves) != 'undefined') && (this.Claves != null) && (this.Claves != ''))
        {
            pKeyCount = this.Claves.length;
        }
        return pKeyCount;
    };
    
    this.HasKeys = function() {
        return ( this.KeyLength() > 0 );
    };
        
    this.GetUrl = function() {
        ///<summary>Devuelve un string conteniendo la Url y el QueryString</summary>
        var pReturn = this.REDIRECTURL + QSC_INITIATOR;

        pReturn += ConvertToQueryString(QS_MAINACTION, this.MainAction);
        pReturn += ConvertToQueryString(QS_ENTIDAD, this.CodEntidad);
        pReturn += ConvertToQueryString(QS_KEYS, this.Claves);
        pReturn += ConvertToQueryString(QS_TPACCION, this.TpAccion);
        pReturn += ConvertToQueryString(QS_FORMID, this.FormID);
        pReturn += ConvertToQueryString(QS_COMBO, this.Combo);
        pReturn += ConvertToQueryString(QS_MODO, this.Modo);
        pReturn += ConvertToQueryString(QS_ENTOP, this.EntOp);
        pReturn += ConvertClavesAuxiliaresToQueryString(this.ClavesAuxiliares,this.EncryptAjaxUrl);

        return pReturn
    };
    this.Fill = function(pPage) {
        ///<summary>Llena las propiedades con los datos de una Url y un QueryString</summary>
        var pPageQS = pPage.split(QSC_INITIATOR);

        if (pPageQS.length > 0) {
            var pQS = pPageQS[pPageQS.length - 1].split(QSC_MEMBERSEP);               
            if (pQS.length > 0) {
                for (var pQSCount = 0; pQSCount < pQS.length; pQSCount++) {
                    var pQSKeyValue = pQS[pQSCount].split(QSC_KEYVALUEPAIRSEP);
                    if (pQSKeyValue.length == 2) {
                        var pQSKey = pQSKeyValue[0];
                        var pQSValue = pQSKeyValue[1];

                        switch (pQSKey.toUpperCase()) {
                            case QS_MAINACTION.toUpperCase():
                                this.MainAction = pQSValue;
                                break;
                            case QS_ENTIDAD.toUpperCase():
                                this.CodEntidad = pQSValue;
                                break;
                            case QS_KEYS.toUpperCase():
                                this.Claves = pQSValue;
                                break;
                            case QS_TPACCION.toUpperCase():
                                this.TpAccion = pQSValue;
                                break;
                            case QS_FORMID.toUpperCase():
                                this.FormID = pQSValue;
                                break;
                            case QS_COMBO.toUpperCase():
                                this.Combo = pQSValue;
                                break;
                            case QS_MODO.toUpperCase():
                                this.Modo = pQSValue;
                                break;
                            case QS_ENTOP.toUpperCase():
                                this.EntOp = pQSValue;
                                break;
                            default:
                                this.ClavesAuxiliares[pQSKey] = pQSValue;
                                break;
                        }
                    }
                }
            }
        }
    }  
};

function WindowFeatures() {
    ///<summary>Caracteristicas de la ventana.</summary>    
    this.Height      = -1;
    this.Width       = -1;
    this.Top         = -1;
    this.Left        = -1;
    this.Resizable   = '';
    this.ScrollBars  = '';
    this.Status      = '';
    this.Get = function() {
        ///<summary>Devuelve un string con los datos de las caracteristicas de la ventana.</summary>
        var pFeatures = '';
        if (this.Height >= 0) {
            pFeatures += 'height=' + this.Height + ',';
        }
        if (this.Width >= 0) {
            pFeatures += 'width=' + this.Width + ',';
        }
        if (this.Top >= 0) {
            pFeatures += 'top=' + this.Top + ',';
        }
        if (this.Left >= 0) {
            pFeatures += 'left=' + this.Left + ',';
        }
        if (this.ScrollBars == 'yes' || this.ScrollBars == 'no') {
            pFeatures += 'scrollbars=' + this.ScrollBars + ',';
        }
        if (this.Resizable == 'yes' || this.Resizable == 'no') {
            pFeatures += 'resizable=' + this.Resizable + ',';
        }
        if (this.Status == 'yes' || this.Status == 'no') {
            pFeatures += 'status=' + this.Status + ',';
        }
        
        return pFeatures;
    };
    
    this.Fill = function(pFeatures) {
        ///<summary>Llena las propiedades con los datos de las caracteristicas de la ventana.</summary>
        var parrFeatures = pFeatures.split(',');
        if(typeof(parrFeatures) != 'undefined' && parrFeatures.length > 0) {
            for(var pFeaturesCount = 0;pFeaturesCount < parrFeatures.lenght;pFeaturesCount++) {
                var pFeature = parrFeatures[0].split('=');
                if(pFeature.lenght == 2) {
                    var pKey = pFeature[0];
                    var pValue = pFeature[1];

                    switch(pKey.toUpperCase()) {
                        case 'Height'.toUpperCase():
                            this.Height = pValue;
                            break;
                        case 'Width'.toUpperCase():
                            this.Width = pValue;
                            break;
                        case 'Top'.toUpperCase():
                            this.Top = pValue;
                            break;
                        case 'Left'.toUpperCase():
                            this.Left = pValue;
                            break;
                        case 'ScrollBars'.toUpperCase():
                            this.ScrollBars = pValue;
                            break;
                        case 'Resizable'.toUpperCase():
                            this.Resizable = pValue;
                            break;
                        case 'Status'.toUpperCase():
                            this.Status = pValue;
                            break;
                    }
                }
            }  
        } 
    }
};

function Window(pUrlData) {
///<summary>Clase que encapsula los distintos metodos para abrir ventanas.</summary>
    this.Url    = pUrlData;
    this.Name   = '';
    
    this.Features = new WindowFeatures();
    
    this.OpenInTabMode = function() {
        return (this.Url.Modo == MOD_Tab && (this.Url.TpAccion == TPA_Agr || this.Url.TpAccion == TPA_Det || this.Url.TpAccion == TPA_Mod));
    };

    this.Open = function() {
        ///<summary>Abre una ventana.</summary>   
        var pWindow = null;
        if (this.OpenInTabMode()) {
            this.OpenTab();
        } else {
            if (this.OpenSameWindow) {
                pWindow = window.open(this.Url.GetUrl(), this.Name, this.Features.Get());
            } else {
                pWindow = window.open(this.Url.GetUrl(), '', this.Features.Get());
            }
        }
        return pWindow;
    };
    
    this.OpenCentered = function() {
        ///<summary>Abre una ventana centrada.</summary>   
        var pPositionX = 0;
        var pPositionY = 0;

        if (screen.width) {           
            pPositionX = (screen.width - parseInt(this.Features.Width)) / 2;
            pPositionY = (screen.height - parseInt(this.Features.Height)) / 2;
        }
        this.Features.Left = pPositionX;
        this.Features.Top = pPositionY;

        return this.Open();
    };

    this.OpenTab = function() {
        ///<summary>Abre un tab.</summary>
        if (document.parentWindow && document.parentWindow.parent && document.parentWindow.parent.createTab) {
            document.parentWindow.parent.createTab(this.Url.GetUrl(), this.Url.TpAccion);
        }
    }
    
    this.CloseTab = function()  {
        if (document.parentWindow && document.parentWindow.parent && document.parentWindow.parent.createTab) {                
            document.parentWindow.parent.getLinkToCloseTab();
        }
    }
}

/* =====================================================================
                    V   E   N   T   A   N   A   S.
   =====================================================================*/
function OpenWindowCentered(pPage, pName, pWidth, pHeight, pFeatures, pEncryptAjaxUrl) {
    ///<summary>Abre una ventana centrada.</summary>
    var pUrlData = new UrlData();   
    var pWindow = null;

        pUrlData.Fill(pPage);
        pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;

        pWindow = new Window(pUrlData);
        
        pWindow.Features.Fill(pFeatures);
        pWindow.Features.Width = pWidth;
        pWindow.Features.Height = pHeight;
        pWindow.Name = pName;

        return pWindow.OpenCentered();    
}

function OpenMessage(pKeys) {
    ///<summary>Abre una ventana.</summary>   
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();
    
        pUrlData.MainAction = MS_EXECACT;
        pUrlData.CodEntidad = MESS_ENT;
        pUrlData.Claves = pKeys;
        
        pWindowFeatures.Height = MESS_Height;
        pWindowFeatures.Width = MESS_Width;
        pWindowFeatures.Resizable = 'no';
        pWindowFeatures.ScrollBars = 'no';
        pWindowFeatures.Status = 'no';
        
    var pWindow = new Window(pUrlData);
        pWindow.Name = 'message';
        pWindow.Features = pWindowFeatures;

        return pWindow.OpenCentered();
}

function OpenGrid(pEntidad, pKeys, pModo, pWidth, pHeight, pClavesAuxiliares, pEncryptAjaxUrl) {
    ///<summary>Abre una grilla.</summary>   
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();

        pUrlData.MainAction = MS_OPENGRID;
        pUrlData.TpAccion = TPA_Det;
        pUrlData.CodEntidad = pEntidad;
        pUrlData.Claves = pKeys;
        pUrlData.Modo = pModo;
        pUrlData.ClavesAuxiliares = pClavesAuxiliares;
        pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;

        pWindowFeatures.Width = (pWidth) ? pWidth : 780;
        pWindowFeatures.Height = (pHeight) ? pHeight : 450;
        pWindowFeatures.Resizable = 'yes';
        pWindowFeatures.ScrollBars = 'no';
        pWindowFeatures.Status = 'no';
        
    var pWindow = new Window(pUrlData);
        pWindow.Name = "miwindow" + pEntidad;        
        pWindow.Features = pWindowFeatures;

        return pWindow.OpenCentered();
}

function OpenMessageText(pText) {
    ///<summary>Abrir mensaje con texto plano/texto en cadenas.resource.</summary>
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();
    
        pUrlData.MainAction = MS_EXECACT;
        pUrlData.CodEntidad = MESS_ENT;
        pUrlData.ClavesAuxiliares['MSG'] = pText;

        pWindowFeatures.Height = MESS_Height;
        pWindowFeatures.Width = MESS_Width;
        pWindowFeatures.Resizable = 'no';
        pWindowFeatures.ScrollBars = 'no';
        pWindowFeatures.Status = 'no';
        
    var pWindow = new Window(pUrlData);
        pWindow.Name = 'message';
        pWindow.Features = pWindowFeatures;

    return pWindow.OpenCentered();
}

function OpenConfigDesktop(pClavesAuxiliares, pEncryptAjaxUrl) {
    ///<summary>Abrir ventana de configuracion de menú.</summary>
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();
    
        pUrlData.MainAction = MS_CONFIGMENU;
        pUrlData.ClavesAuxiliares = pClavesAuxiliares;
        pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;
        
        pWindowFeatures.Height = 450;
        pWindowFeatures.Width = 750;
        pWindowFeatures.Resizable = 'yes';
        pWindowFeatures.ScrollBars = 'yes';
        pWindowFeatures.Status = 'no';
        
    var pWindow = new Window(pUrlData);
        pWindow.Name = 'CONFIG';
        pWindow.Features = pWindowFeatures;

    return pWindow.OpenCentered();    
}

function OpenFilterWnd(pEntidad, pFromGrid, pCombo, pClavesAuxiliares, pEncryptAjaxUrl) {
    ///<summary>Abrir ventana de configuracion de filtros</summary>
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();

        pUrlData.MainAction = (pFromGrid == -1 ? MS_OPENFILTERWND : MS_OPENFILTERWNDFROMDSKTP);

        pUrlData.CodEntidad = pEntidad;
        pUrlData.Combo = pCombo;
        pUrlData.ClavesAuxiliares = pClavesAuxiliares;
        pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;
        
        pWindowFeatures.Height = 350;
        pWindowFeatures.Width = 600;
        pWindowFeatures.Resizable = 'yes';
        pWindowFeatures.ScrollBars = 'no';
        pWindowFeatures.Status = 'no';
        
    var pWindow = new Window(pUrlData);
        pWindow.Name = 'find';
        pWindow.Features = pWindowFeatures;

    return pWindow.OpenCentered();  
}

function OpenEntidad(pUrlData, pWindowFeatures, pFromGrid) {
    ///<summary>Abre una entidad.</summary>
    var pWindow = new Window(pUrlData);    
    
    if(ValidateRequest(pUrlData,pFromGrid))
    {
        switch(pUrlData.TpAccion)
        {
            case TPA_Agr:
                pWindow.Name = 'subwindow';
                pWindowFeatures.Resizable = 'yes';
                pWindowFeatures.Status = 'no';
                break;
            case TPA_Anu:
            case TPA_Rec:
                pWindow.Name = 'messagewindow';
                pWindowFeatures.Width = MESS_Width;
                pWindowFeatures.Height = MESS_Height;
                pWindowFeatures.Resizable = 'no';                
                pWindowFeatures.ScrollBars = 'no';
                pWindowFeatures.Status = 'no';
                break;
            case TPA_Imp:
                pWindow.Name = 'messagewindow';
                pWindowFeatures.Resizable = 'yes';                
                pWindowFeatures.ScrollBars = 'yes';
                pWindowFeatures.Status = 'no';
                break;
            default:
                pWindow.Name = 'messagewindow';
                pWindowFeatures.Resizable = 'yes';                
                pWindowFeatures.ScrollBars = 'no';
                pWindowFeatures.Status = 'no';               
                break;
        }

        pWindow.Features = pWindowFeatures;
        pWindow.Url.MainAction = MS_EXECACT;
        pWindow.OpenCentered();
    }
}

//ejecutar acciones
function ExecEntTpAccion(pEntidad, pTpAccion, pKeys, pWidth, pHeight, pFromGrid, pFormID, pCombo, pModo, pEntidadToOpen, pClavesAuxiliares, pEncryptAjaxUrl) {
    ///<summary>Abre una entidad.</summary>   
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();
    
    pUrlData.CodEntidad = pEntidad;
    pUrlData.TpAccion = pTpAccion;
    pUrlData.Claves = pKeys;
    pUrlData.FormID = pFormID;
    pUrlData.Combo = pCombo;
    pUrlData.Modo = pModo;
    pUrlData.EntOp = pEntidadToOpen;
    pUrlData.ClavesAuxiliares = pClavesAuxiliares;
    pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;
    
    pWindowFeatures.Width = pWidth;
    pWindowFeatures.Height = pHeight;
    
    OpenEntidad(pUrlData,pWindowFeatures,pFromGrid);
}

function ExportData(pEntidad, pTpAccion, pKeys, pWidth, pHeight, pFromGrid, pFormID, pCombo, pModo, pEntidadToOpen, pEncryptAjaxUrl) {
    ///<summary>Abre una entidad.</summary>   
    var pUrlData = new UrlData();
    var pWindowFeatures = new WindowFeatures();
    var pGridData = ifraGrilla.GetGridData();

    pUrlData.CodEntidad = pEntidad;
    pUrlData.TpAccion = pTpAccion;
    //Se limpian las claves ya no son necesarias para la exportacion.
    //pUrlData.Claves = pKeys;
    pUrlData.Claves = "";
    pUrlData.FormID = pFormID;
    pUrlData.Combo = pCombo;
    pUrlData.Modo = pModo;
    pUrlData.EntOp = pEntidadToOpen;
    pUrlData.ClavesAuxiliares = { GridID: pGridData.GridID, SessionID: pGridData.SessionID };
    pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;

    pWindowFeatures.Width = pWidth;
    pWindowFeatures.Height = pHeight;

    OpenEntidad(pUrlData, pWindowFeatures, pFromGrid);
}

function CreateUrl(pMainAction, pCodEntidad, pKeys, pTpAccion, pFormID, pCombo, pModo, pEntOp,pClavesAuxiliares,pEncryptAjaxUrl) {
    ///<summary>Devuelve una URL.
    ///En caso de suministrar claves auxiliares se debe suministrar tambien una url
    ///</summary>    
    var pUrlData = new UrlData();
        pUrlData.MainAction = pMainAction;
        pUrlData.CodEntidad = pCodEntidad;
        pUrlData.Claves = pKeys;
        pUrlData.TpAccion = pTpAccion;
        pUrlData.FormID = pFormID;
        pUrlData.Combo = pCombo;
        pUrlData.Modo = pModo;
        pUrlData.EntOp = pEntOp;
        pUrlData.ClavesAuxiliares = pClavesAuxiliares;
        pUrlData.EncryptAjaxUrl = pEncryptAjaxUrl;
        
        return pUrlData.GetUrl();
}

function ValidateRequest(pUrlData,pFromGrid) {
    ///<summary>Valida que la entidad a abrir contega las keys necesarias.</summary>
    var pValid = true;
    
    if(pUrlData.KeyLength() <= 0)
    {
        switch(pUrlData.TpAccion) {
            case TPA_Agr:
            case TPA_Exp:
            case TPA_Imp:
                pValid = true;
            break;
            default:
                if (pFromGrid)
                {
                    OpenMessageText(ERROR_NO_FILE_SELECTED);
                } else {
                    OpenMessageText(ERROR_NO_KEY);
                }
                pValid = false;
            break;                    
        }
    }

    return pValid;
}

function ShowMenu(pControl, pMenuID) {
    pPos = getAbsoluteElementPosition(pControl);
    igmenu_showMenu(pMenuID, null, pPos.left, pPos.top + 20);
}

function ShowMenuWizard(pControl, pMenuID) {
    pPos = getRelativeElementPosition(pControl);
    igmenu_showMenu(pMenuID, null, pPos.left, pPos.top + 20);
}

function getRelativeElementPosition(pElement) {
    var pLeft = 0;
    var pTop = 0;
    var pElem = null;

    pElem = (document.all)?pElement:pElement.parentNode;
        
    if (pElem != null) {
        pLeft = pElem.offsetLeft;
        pTop = pElem.offsetTop;
    
        while (pElem.offsetParent) {
            pLeft += pElem.offsetParent.offsetLeft;
            pTop += pElem.offsetParent.offsetTop;

            if (pElem.offsetParent.scrollLeft) { 
                pLeft -= pElem.offsetParent.scrollLeft; 
            }

            if (pElem.offsetParent.scrollTop) { 
                pTop -= pElem.offsetParent.scrollTop; 
            }

            pElem = pElem.offsetParent;
        }
        
        // Add the top elem left offset and the windows left scroll and subtract the body's client left position.
        pLeft += pElem.offsetLeft + document.body.scrollLeft;  //- document.body.clientLeft;
        // Add the top elem topoffset and the windows topscroll and subtract the body's client top position.
        pTop += pElem.offsetTop + document.body.scrollTop; // - document.body.clientTop;
    }

    pLeft += 3;
    return { left: pLeft, top: pTop };
}

// Posición de un objeto
function getAbsoluteElementPosition(pElement) {
    var pPosY = 0;
    var pPosX = 0;
    
    if (typeof pElement == "string")
    {
        pElement = document.getElementById(pElement);
    }
    if (pElement)
    {
        while (pElement.offsetParent) {
            pPosX += pElement.offsetLeft;
            pPosY += pElement.offsetTop;
            pElement = pElement.offsetParent;
        }
        
        pPosX += window.document.body.offsetLeft;
        pPosY += window.document.body.offsetTop;
    }
    
    return { top: pPosY, left: pPosX };
}

// desplazar un control horizontalmente
function DesplazarControl(pLstID, pDesde, pHasta) {
    var pDiv = document.getElementById(pLstID);
    if (pDesde <= (pHasta - 20)) {
        pDesde += 20;
        setTimeout("DesplazarControl('" + pLstID + "'," + pDesde + "," + pHasta + ")", 10);
        pDiv.style.left = pDesde + "px";
    } else {
        pDiv.style.left = pHasta + "px";
    }
}

/* esconder un elemento */
function HideElement(pID) {
    document.getElementById(pID).style.display = 'none'
}

function CloseWindow() {
    window.open('', '_parent', '');
    self.close();
}

function CloseTab() {
    var pWindow = new Window();
    pWindow.CloseTab();
}

