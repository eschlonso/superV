//scrClientTimeOut.js

    setTimeout("LogOff()", 60000); 
    var tLogoff = 0; 

    function ResetTimeout(){tLogoff=0;}

    function LogOff() { 
        tLogoff += 1; 
        setTimeout("LogOff()",60000); 
        if (tLogoff==tTimeout)
        { window.open("frwClosedSession.aspx","_self"); }
        }
        
