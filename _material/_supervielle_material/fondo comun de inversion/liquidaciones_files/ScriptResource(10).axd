//DateEditor.js

function ValidateOnlyWorkingDays(pDate, pAJAXUrl, pParametersAndValues, pAllParametersMustContainValue) {
    var pIsWorkingDay = false;

    if (pAJAXUrl.length > 0) {
        pIsWorkingDay = IsWorkingDay(pDate, pAJAXUrl, pParametersAndValues, pAllParametersMustContainValue);
        if (!pIsWorkingDay) {
            OpenMessageText('Debe ingresar un día hábil.');
            $('#' + pDate).val('')
        }
    }
    return pIsWorkingDay;
}

//Devuelve la fecha final contando solo dias habiles.
function IsWorkingDay(pDate, pAJAXUrl, pParametersAndValues, pAllParametersMustContainValue) {
    var pIsWorkingDay = true;
    var pDateValue = ConvertStringToDate($('#' + pDate).val());
    if (typeof (pDateValue) != 'undefined' && pDateValue != null) {
        var pUrl = pAJAXUrl + '&Date=' + ConvertDateToString(pDateValue);

        if (pParametersAndValues != null && pParametersAndValues.constructor == Array && pParametersAndValues != undefined) {
            var tmpString = '';
            var paramValue;
            var pUrlLength = pUrl.length;
            if (pAllParametersMustContainValue && pParametersAndValues.length == 0) return true;
            for (var i = 0; i < pParametersAndValues.length; i++) {
                paramValue = eval(pParametersAndValues[i][1]);
                if (paramValue.length == 0 && pAllParametersMustContainValue) return true; //si alguno de los combos o valores fijos no esta seteado y tienen que estar todos seteados, cancela la llamada
                if (paramValue.length > 0) {
                    tmpString = '&' + pParametersAndValues[i][0] + '=' + paramValue;
                    pUrl += tmpString;
                }
            }
            if (pUrlLength == pUrl.length) return true; //no se agrego ningun parametro extra
        }


        var pWorkingDay = $.ajax({ url: pUrl, async: false }).responseText;
        pIsWorkingDay = (pWorkingDay == '1') ? true : false;
    }
    return pIsWorkingDay;
}

//TODO:FuncionesComunes
//Convierte un Date a un string en el formato definido en la aplicacion.
function ConvertDateToString(pDate) {
    if (pDate == null) return '';

    var pDateString = '';
    var pDay = pDate.getDate();
    var pMonth = pDate.getMonth();
    var pYear = pDate.getFullYear();

    switch (DATE_FORMAT) {
        case 'DayMonthYear':
            pDateString = ConvertDayMonthToString(pDay) + DATE_SEPARATOR + ConvertDayMonthToString(pMonth + 1) + DATE_SEPARATOR + pYear;
            break;
        case 'DayYearMonth':
            pDateString = ConvertDayMonthToString(pDay) + DATE_SEPARATOR + pYear + DATE_SEPARATOR + ConvertDayMonthToString(pMonth + 1);
            break;
        case 'MonthDayYear':
            pDateString = ConvertDayMonthToString(pMonth + 1) + DATE_SEPARATOR + ConvertDayMonthToString(pDay) + DATE_SEPARATOR + pYear;
            break;
        case 'MonthYearDay':
            pDateString = ConvertDayMonthToString(pMonth + 1) + DATE_SEPARATOR + pYear + DATE_SEPARATOR + ConvertDayMonthToString(pDay);
            break;
        case 'YearDayMonth':
            pDateString = pYear + DATE_SEPARATOR + ConvertDayMonthToString(pDay) + DATE_SEPARATOR + ConvertDayMonthToString(pMonth + 1);
            break;
        case 'YearMonthDay':
            pDateString = pYear + DATE_SEPARATOR + ConvertDayMonthToString(pMonth + 1) + DATE_SEPARATOR + ConvertDayMonthToString(pDay);
            break;
    }
    return pDateString;
}

//Convierte un string en un Date tomando en cuenta el formato de las fechas de la aplicacion.
function ConvertStringToDate(pDate) {
    var pArrFecha = null;
    var pDateTime = null;

    if (typeof (pDate) != 'undefined') {
        pArrFecha = pDate.split(DATE_SEPARATOR);

        if (pArrFecha.length == 3 && !isNaN(pArrFecha[0]) && !isNaN(pArrFecha[1]) && !isNaN(pArrFecha[2])) {
            //pDateTime = new Date(YEAR, MONTH - 1, DAY);
            //MONTH es un array de 0 a 11!
            switch (DATE_FORMAT) {
                case 'DayMonthYear':
                    pDateTime = new Date(pArrFecha[2], pArrFecha[1] - 1, pArrFecha[0]);
                    break;
                case 'DayYearMonth':
                    pDateTime = new Date(pArrFecha[1], pArrFecha[2] - 1, pArrFecha[0]);
                    break;
                case 'MonthDayYear':
                    pDateTime = new Date(pArrFecha[2], pArrFecha[0] - 1, pArrFecha[1]);
                    break;
                case 'MonthYearDay':
                    pDateTime = new Date(pArrFecha[1], pArrFecha[0] - 1, pArrFecha[2]);
                    break;
                case 'YearDayMonth':
                    pDateTime = new Date(pArrFecha[0], pArrFecha[2] - 1, pArrFecha[1]);
                    break;
                case 'YearMonthDay':
                    pDateTime = new Date(pArrFecha[0], pArrFecha[1] - 1, pArrFecha[2]);
                    break;
            }
        }
    }
    return pDateTime;
}

//Le agrega un 0 al comienzo a los dias y meses menores a 10.
function ConvertDayMonthToString(pDayMonthValue) {
    var pDayMonthValueString = '';

    if (pDayMonthValue < 10) {
        pDayMonthValueString = '0' + pDayMonthValue;
    } else {
        pDayMonthValueString = pDayMonthValue + '';
    }
    return pDayMonthValueString;
}

function AutoPostBack(pDateEditorID,pEventID) {
    __doPostBack(pDateEditorID, pEventID);
}
if(typeof(Sys)!=='undefined')Sys.Application.notifyScriptLoaded();