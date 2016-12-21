////ControlExtended.js

function initExteded(obj, name, sID) {

    ///if (!(typeof (obj) == 'undefined')) { return false }
    //aplica a todos los controles que no hereden de Infragistic
    if (name == 'LabelControl' || name == 'CheckEditor' ||
        name == 'ComboEditor' || name == 'OptionEditor' ||
        name == 'DateEditor' || name == 'MultilineTextEditor' ||
        name == 'NumericEditor' || name == 'TextEditor' || name == 'Panel'
        ) {

        if (typeof (obj) == 'undefined') {return obj; }

        obj.RefreshState = function () { } //Base para todos.
        //:::::::::: FUNCIONES: getValue y setValue
        switch (name) {
            case 'LabelControl':
                obj.getValue = function () {
                    return this.text();
                }
                obj.setValue = function (value) {
                    this.text(value);
                    $(this.selector + '_val').val(value);
                }
                obj.getSerialize = function () {
                    return {
                        "value": this.getValue()
                    };
                }
                obj.setUnserialize = function (pObj) {
                    obj.eSetValue(pObj.value, pObj.stop);
                };
                obj.eSetValue = function (value, pStop) {
                    this.setValue(value);
                };
                break;
            case 'ComboEditor':
                obj.getValue = function () {
                    return null;
                }
                obj.getValue = function (parametro) {
                    return getParametroCombo(this.selector.replace(/#/g, ''), parametro);
                }
                obj.setValueArray = function (pParametro) {
                    return setArrayParametrosCombo(this.selector.replace(/#/g, ''), pParametro, true);
                }
                obj.setValue = function (pParametro, pvalor) {
                    return setParametroCombo(this.selector.replace(/#/g, ''), pParametro, pvalor, true);
                }
                obj.seleccionarPrimero = function () {
                    return SelectFirstParentChanged(this.selector.replace(/#/g, ''));
                }
                obj.blanquearCombo = function (pNoPropag) {
                    return SelectNoneWithComboID(this.selector.replace(/#/g, ''), pNoPropag);
                }
                obj.getSerialize = function () {
                    return {
                        "valueCodIn": GetCodInValue(this.selector.replace(/#/g, '')),
                        "valueCodOut": GetCodOutValue(this.selector.replace(/#/g, ''))
                    };
                }
                obj.setUnserialize = function (pObj) {
                    //SetCboPk(this.selector.replace(/#/g, ''), pObj.pk); No Se Usa
                    obj.eSetValue(pObj.value, pObj.stop);

                    if (StringToBool(pObj.SelP) && !StringToBool(pObj.bc))
                        this.seleccionarPrimero();

                    this.setEnabled(StringToBool(this.getKeyValue('e')));
                    if (StringToBool(pObj.bc)) this.blanquearCombo(pObj.stop);
                };
                obj.eSetValue = function (value, pStop) {
                    if (value != '') {
                        var pCbo = this;
                        $.each(value.split(KeyValueSeparator), function (index, ctrl) {
                            var pParam = ctrl.split(ValueSeparator);
                            if (pParam[0] != '') {
                                pCbo.setValue(pParam[0], pParam[1]);
                            }
                        });
                    } else { this.blanquearCombo(); }
                    if (!StringToBool(pStop)) {
                        //alert('raise Evento de change de combo');
                    };
                }
                break;
            case 'CheckEditor': case 'OptionEditor':
                obj.getValue = function () {
                    return this.is(':checked');
                }
                obj.setValue = function (value) {
                    this.attr('checked', value);
                }
                obj.getSerialize = function () {
                    return {};
                }
                obj.setUnserialize = function (pObj) {
                    obj.eSetValue(this.getKeyValue('ch'), pObj.stop);
                    this.setEnabled(StringToBool(this.getKeyValue('e')));
                };
                obj.eSetValue = function (value, pStop) {
                    var pVal = StringToBool(value);
                    if (this.getValue() != pVal) {
                        this.setValue(pVal);
                        if (!StringToBool(pStop)) { // Si tngo que propagar el evento...
                            this.trigger('click');
                            this.setValue(pVal);
                        };
                    }
                }
                obj.RefreshState = function (){this.setKeyValue('ch' , BoolToString(this.getValue()));};
                break;
            case 'NumericEditor': case 'TextEditor':
                obj.getSerialize = function () {
                    var a = {
                        "value": this.getText()
                    };
                    this.getValue();
                    return a;
                }
                obj.oldSetEnabled = obj.setEnabled;
                obj.oldSetVisible = obj.setVisible;                
                obj.setUnserialize = function (pObj) {
                    obj.eSetValue(pObj.value, pObj.stop);
                    this.oldSetEnabled(StringToBool(this.getKeyValue('e')));
                };
                obj.eSetValue = function (value, pStop) {
                    this.setText(value);
                    if (!StringToBool(pStop)) {
                        this.fireEvent(11, null); //Evento changeValue de IG.
                    };
                }
                break;
            case 'DateEditor':
                obj.close = function () {
                    $find(this.selector.replace(/#/g, '') + "_calExt").hide(); 
                }
                obj.getValue = function () {
                    if (this.val().indexOf("_") == -1)  //Si no está completa la fecha.
                        return this.val();
                    else
                        return '';
                }
                obj.setValue = function (value) {
                    this.val(value);
                }
                obj.getSerialize = function () {
                    return {};
                }
                obj.setUnserialize = function (pObj) {
                    obj.eSetValue(this.getKeyValue('t'), pObj.stop);
                    this.setEnabled(!StringToBool(this.getKeyValue('r')));
                };
                obj.eSetValue = function (value, pStop) {
                    this.setValue(value);
                    if (!StringToBool(pStop)) { // Si tngo que propagar el evento...
                        this.click();
                    };
                }
                obj.RefreshState = function (){this.setKeyValue('t' , this.getValue());};
                break;
            case 'Panel':
                obj.getValue = function () {
                    return this.getVisible();
                }
                obj.setValue = function (value) {
                    this.setVisible(value);
                    if (value) {
                        $(this.selector + '_val').val('-1');
                    } else { $(this.selector + '_val').val('0'); }
                }
                obj.getSerialize = function () {
                    return {
                        "visible": this.getValue()
                    };
                }
                obj.setUnserialize = function (pObj) {
                    obj.eSetValue(pObj.visible, pObj.stop);
                };
                obj.eSetValue = function (value, pStop) {
                    var pVal = StringToBool(value);
                    if (this.getVisible() != pVal) {
                        this.setValue(pVal);
                    }
                }
                break;
            default: // MultilineTextEditor
                obj.getValue = function () {
                    return this.val();
                }

                obj.setValue = function (value) {
                    this.val(value);
                }
        }

        //:::::::::: FUNCIONES: setEnabled y setVisible
        switch (name) {
            case 'ComboEditor':
                obj.setVisible = function (value) {
                    if (value) {
                        this.show();
                        this.ShowDisplay();
                    } else {
                        this.hide();
                        this.HideDisplay();
                    }
                    this.setKeyValue('v', BoolToString(value));
                }
                obj.setEnabled = function (value) {
                    if (value) {
                        EnableComboNoBlank(this.selector.replace(/#/g, ''));
                    } else {
                        DisableComboNoBlank(this.selector.replace(/#/g, ''));
                    }
                    this.setKeyValue('e', BoolToString(value));

                }
                obj.getEnabled = function () {
                    return cboGetEnabled(this.selector.replace(/#/g, ''));
                }
                obj.getVisible = function () {
                    return cboGetEnabled(this.selector.replace(/#/g, ''));
                }
                break;
            case 'DateEditor':
                obj.setEnabled = function (value) {
                    if (value) {
                        //this.removeAttr('disabled'); //no envia el control en los postback
                        this.removeAttr('disabled');
                        this.removeAttr('readonly');
                        this.remask();
                        $(this.selector + '_img').removeAttr('disabled');
                    } else {
                        this.unmask();
                        this.attr('disabled', 'disabled');
                        $(this.selector + '_img').attr('disabled', 'disabled');
                    };
                    this.setKeyValue('r', BoolToString(!value));
                }
                obj.setVisible = function (value) {
                    if (value) {
                        this.show();
                        $(this.selector + '_img').show();
                    } else {
                        this.hide();
                        $(this.selector + '_img').hide();
                    };
                    this.setKeyValue('v', BoolToString(value));
                }
                obj.getEnabled = function () {
                    return (this.is(':enabled') && !this.attr('readonly') && !this.attr('readOnly'));
                }
                obj.getVisible = function () {
                    return EsVisible(obj);
                }
                break;
            case 'NumericEditor': case 'TextEditor':
                obj.setEnabled = function (value) {
                    obj.oldSetEnabled(value);
                    this.setKeyValue('e', BoolToString(value));
                };

                obj.setVisible = function (value) {
                    obj.oldSetVisible(value);
                    this.setKeyValue('v', BoolToString(value));
                }
                break;
            case 'CheckEditor': case 'OptionEditor':
                obj.setEnabled = function (value) {
                    if (value) {
                        this.parent().removeAttr('disabled');
                        this.removeAttr('disabled');
                        this.removeAttr('readonly');
                        this.setKeyValue('e', BoolToString(true));
                    }
                    else {
                        this.attr('disabled', 'disabled');
                        this.setKeyValue('e', BoolToString(false));
                    }
                }
                obj.setVisible = function (value) {
                    if (value)
                        this.show();
                    else
                        this.hide();
                    
                    this.setKeyValue('v', BoolToString(value));
                }
                obj.getEnabled = function () {
                    return (this.is(':enabled') && !this.attr('readonly') && !this.attr('readOnly'));
                }
                obj.getVisible = function () {
                    return EsVisible(obj);
                }
                break;
            default:
                obj.setEnabled = function (value) {
                    if (value) {
                        this.removeAttr('disabled');
                        this.setKeyValue('e', BoolToString(true));
                    }
                    else
                        this.attr('disabled', 'disabled');

                    this.setKeyValue('e', BoolToString(false));
                }
                obj.setVisible = function (value) {
                    if (value)
                        this.show();
                    else
                        this.hide();
                }
                obj.getEnabled = function () {
                    return (this.is(':enabled') && !this.attr('readonly') && !this.attr('readOnly'));
                }
                obj.getVisible = function () {
                    return EsVisible(obj);
                }
                break;
        }
    }

    if (typeof (obj) == 'undefined') { return obj; }
    //aplica para todos los controles
    obj.isNullOrEmpty = function () {
        return (this.getValue() == '' || this.getValue() == null);
    }
    obj.sID = sID;

    obj.setKeyValue = function (pKey, pValue) {
        if (!(typeof(HiddenDic) == 'undefined'))
            HiddenDic.setKeyValue(this.sID, pKey, pValue);
    }

    obj.getKeyValue = function (pKey) {
        if (!(typeof(HiddenDic) == 'undefined'))
            return HiddenDic.getKeyValue(this.sID, pKey);
    }

    return obj;
}

function EsVisible(p) {
    return (p.css("display") != 'none');
}


function InitHiddenDictionary(pID) {
    var pObj = $('#' + pID);
    pObj.loadJSON = function () {
        this.JSON = Sys.Serialization.JavaScriptSerializer.deserialize(this.val());
    }
    pObj.loadJSON();

    pObj.saveJSON = function () {
        this.val(Sys.Serialization.JavaScriptSerializer.serialize(this.JSON));
    }
    pObj.oldVal = pObj.val;

    pObj.hasKey = function (pControlID, pKey) {
        return typeof (eval('this.JSON.' + pControlID)) != 'undefined' && typeof (eval('this.JSON.' + pControlID + '.' + pKey)) != 'undefined';
    }

    pObj.setKeyValue = function (pControlID, pKey, pValue) {
        if (this.hasKey(pControlID, pKey)) {
            eval('this.JSON.' + pControlID + '.' + pKey + ' = pValue;');
            this.saveJSON();
        }        
    }

    pObj.getKeyValue = function (pControlID, pKey) {
        if (this.hasKey(pControlID, pKey))
            return eval('this.JSON.' + pControlID + '.' + pKey);
        else
            return '';
    }
    return pObj;
}

function BoolToString(pval) {
    return (pval ? '-1' : '0');
}

function StringToBool(pval) {
    return (pval == -1 || pval == '1' || pval == 'true');
}

if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();