.dxeLoadingDiv
{
	background: White;
    opacity: 0.85;
    filter: alpha(opacity=85);
    cursor: wait;
}
.dxeLoadingPanel
{
	font: 9pt Tahoma;
	color: #303030;
}
.dxeLoadingPanel td.dx
{
	white-space: nowrap;
	text-align: center;
	padding: 12px 12px 12px 12px;
}

.dxeReadOnly 
{
    
}
.dxeBase
{
    font-family: Tahoma;
    font-size: 9pt;
}
/* -- ErrorFrame -- */
.dxeErrorCell, .dxeErrorCell td
{
    font-family: Tahoma;
    font-size: 9pt;
	color: Red;
}
.dxeErrorCell
{ 
	padding-left: 4px;
	padding-right:5px;
}
.dxeErrorFrameWithoutError {
    border: 1px solid Red;
}
.dxeErrorFrameWithoutError .dxeControlsCell {
    padding: 2px;
}

.dxeEditArea 
{
	font-family: Tahoma;
	font-size: 9pt;
	border: 1px solid #A0A0A0;
}
/* -- Buttons -- */
.dxeButtonEditButton, .dxeCalendarButton,
.dxeSpinIncButton, .dxeSpinDecButton,
.dxeSpinLargeIncButton, .dxeSpinLargeDecButton
{	
	vertical-align: middle;
	border: solid 1px #7f7f7f;
	cursor: pointer;
	cursor: hand;
} 
.dxeButtonEditButton, .dxeCalendarButton, .dxeButtonEditButton td.dx, .dxeCalendarButton td.dx,
.dxeSpinIncButton, .dxeSpinDecButton, .dxeSpinLargeIncButton, .dxeSpinLargeDecButton,
.dxeSpinIncButton td.dx, .dxeSpinDecButton td.dx, .dxeSpinLargeIncButton td.dx, .dxeSpinLargeDecButton td.dx
{	
    font-family: Tahoma;
    font-size: 11px;        
    font-weight: normal;
	text-align: center;
	white-space: nowrap;
} 
.dxeButtonEditButton,
.dxeSpinIncButton, .dxeSpinDecButton, .dxeSpinLargeIncButton, .dxeSpinLargeDecButton
{
    padding: 0px 2px 0px 3px;
	background-image: url('WebResource.axd?d=wD3Ba8eKQ0qWZHH_G5SbWVHLCSaphEyVxqf2nuUix5cjlm6hD1vbmsyJCFBG8sLracWs69lo73dWSEVuaeJ0nw9k2OL9iWe59w-taBw3zckDGqH6nixzD8BKX0xxmtzv9LiKEabPLJW8OjMFdvn_ELuTdkZjJ0HJs6h1FwlqZIXfmOWdBRLqA1ugXib-QGaWbJpskg2&t=636117930522046151');
    background-repeat: repeat-x;
    background-position: top;    
    background-color: #e6e6e6;
}
.dxeSpinIncButton
{
	background-image: url('WebResource.axd?d=nv4PP3uq2Ywa9vF0VM0Jij89nED-u4S8pB-uZ9V8tu7oYscI5mzqOmFKUwVjP8T3x0Ur7ldq_7heQUhIqRAkq-G8slOzo5Df2FTBSXN1jvUqnxEfN0LkdN-JsulcyUaA65lYD5bNQZT7nIFqdERHZwF_U_4ZFutxp5GQEz5qbxPK47x8mLJAH5q75pjCuG_yZs1L3Q2&t=636117930522046151');
    background-repeat: repeat-x;
    background-position: top;
	background-color: #F0F0F0;
}
.dxeSpinDecButton
{
	background-image: url('WebResource.axd?d=zlmZIthbysYlHqHBXdpOriSDgGeC7KD-T1slKhlIKOf3O0ZnPYAfrxp-SuzRKcQutx83nuROimvOEy9WgG5pJHAQPdFbdHsQjDYwrxQ-qtIn9Pe-CHE6MkIIgoLG3vzaaeIQ2HVU_3NwQhiaSf0yBHtXLXw-LyX3UxPXBLIO8XpeEvqWZEBGy1Z2fVFqHmoxo5IpkA2&t=636117930522046151');
    background-repeat: repeat-x;
    background-position: top;
	background-color: #E6E6E6;
}

.dxeButtonEditButton table.dxbebt,
.dxeSpinIncButton table.dxbebt, .dxeSpinDecButton table.dxbebt, 
.dxeSpinLargeIncButton table.dxbebt, .dxeSpinLargeDecButton table.dxbebt
{
	width: 10px;
}
.dxeCalendarButton      
{
	font-size: 9pt;
	background-image: url('WebResource.axd?d=fAd2ed_d4Y-76rvr-sju7UyxqidPkbYe212ppKGGCVjoqwGZ4Ex36-GH7ozK4ijmylY9asWAoUzqhhAuTB-PSPI-a0Z44HkZ1tEyzxTo2Nmu1Nv4Mjflh8tDsXB4MsuEahTCOjF68wkNdW03vIx8wiakltTQCI51n6BpLNpqllkvMZxrnHNPJiDZ0KmPczafvo4gEg2&t=636117930522046151');
    background-repeat: repeat-x;
    background-position: top;    
    background-color: #e5e5e5;
	padding: 4px 11px;
	padding-top: 3px;
	width: 32px;
}
.dxeCalendarButton td.dx
{
	font-size: 9pt;    
	text-align: center;
	white-space: nowrap;
}
.dxeCalendarButton table.dxbebt 
{
	width: 100%;
}

/* -- Pressed -- */
.dxeCalendarButtonPressed, .dxeButtonEditButtonPressed,
.dxeSpinIncButtonPressed, .dxeSpinDecButtonPressed, .dxeSpinLargeIncButtonPressed, 
.dxeSpinLargeDecButtonPressed
{
	background-image: none;
	background-color: #D5D5D5;
	border: Solid 1px #7F7F7F;	
}
/* -- Hover -- */
.dxeCalendarButtonHover, .dxeButtonEditButtonHover,
.dxeSpinIncButtonHover, .dxeSpinDecButtonHover, .dxeSpinLargeIncButtonHover, .dxeSpinLargeDecButtonHover
{
	background-image: url('WebResource.axd?d=8FzQyBDgywYbBPj-gXuDOgstHEKE7A7xDj6LHyOwqN9szWounOpt65gg4vM1A9_fztiYsLspq0YyAiaKTmCnay8Q5KwCXJ0jHlFpsdOayKKF-Sw1U9ffpkUAfJ5-HIAYVxOIDSTUiwX92AWXejvicMAOL6v6whe8j9CN9kRP01m3w8_dc1_XJawqILq_Ettf_EmUbbwhgeSxaLB7_1mnkQgS3Kg1&t=636117930522046151');
    background-repeat: repeat-x;
    background-position: top;
    background-color: #F2F2F2;
	border: Solid 1px #606060;
}
.dxeCalendarButtonHover
{
	background-image: url('WebResource.axd?d=5uocPk4Uo8m6wAuD218nXqQdKKwHbjYWvnAAHXkUMllgnMKWw1JlUM3kDJ2DQKmwEJ2hQN3xjVtH7d_vCKprujvi9ycUjbdunJSfsNHStcVVVs5mEr6UcH963ZUt-jMArEYtRKSgEESm56HpVEcpchVlkmtWhC-rSKLn338aR7NJtJRPQSzT-4tdfKy_oEdYIiChnA2&t=636117930522046151');
    background-repeat: repeat-x;
    background-position: top;    
}

.dxeButtonEdit
{
    background-color: white;
    border: solid 1px #9F9F9F;
    width: 170px;
}
.dxeButtonEdit .dxeEditArea, .dxeButtonEdit td.dxic
{
	width: 100%;
}
.dxeButtonEdit td.dxic
{
    padding: 0px 2px 0px 1px;
}
.dxeTextBox, .dxeMemo
{
    background-color: white;
    border: solid 1px #9f9f9f;
}
.dxeTextBox td.dxic
{
	padding: 1px 2px;
}
.dxeTextBox td.dxic
{
	width: 100%;
}
.dxeRadioButtonList
{
    border: Solid 1px #9F9F9F;
}
.dxeRadioButtonList, .dxeRadioButtonList table
{
    font-family: Tahoma;
    font-size: 9pt;    
}
.dxeRadioButtonList td.dxe
{
    padding: 6px 11px;
    padding-top: 7px;
}

/* -- Memo -- */
.dxeMemo
{
	padding-left: 3px;
}
.dxeMemoEditArea 
{
	font-family: Tahoma;
	font-size: 9pt;
}
.dxeMemo td
{
	width: 100%;
}

/* -- Hyperlink -- */
.dxeHyperlink
{
    font-family: Tahoma;
    font-size: 9pt;
    font-weight: normal;
    color: #0d45b7;        
}
a:hover.dxeHyperlink
{
    color: #5494ea;    
}
a:visited.dxeHyperlink
{
    color: #ab59a6;    
}

/* -- ListBox -- */
.dxeListBox
{
	background-color: white;
	border: solid 1px #A0A0A0;
    font-family: Tahoma;
    font-size: 9pt;
    width: 70px;
    height: 109px;
}
.dxeListBox div.dxlbd
{
	padding-top: 1px;    
    padding-bottom: 1px;
    height: 107px;
}
.dxeListBoxItem
{
	border-left: solid 1px white;    
    border-right: solid 1px white;    
    font-family: Tahoma;
    font-size: 9pt;
    padding: 3px 2px 4px 3px;
    white-space: nowrap;
    text-align: left;
    cursor: default;
    color: Black;
    font-weight: normal;
}

.dxeListBox td.dxeI 
{
    padding-right: 0px!important;
    border-right-width: 0px!important;
}
.dxeListBox td.dxeT
{
    width: 100%;    
    border-left-width: 0px!important;    
}
.dxeListBoxItemHover        /* inherits dxeListBoxItem */
{
    background-color: #cfcfcf;
}
.dxeListBoxItemSelected     /* inherits dxeListBoxItem */
{    
    color: White;
    background-color: #8d8d8d;
}

/* -- Calendar -- */
.dxeCalendar
{ 
    border: solid 1px #9f9f9f;
    background-color: White;
    color: Black;
    font-weight: normal;
    cursor: default;
}
.dxeCalendar td.dxMonthGrid 
{
    padding: 8px 20px;    
}
.dxeCalendar td.dxMonthGridWithWeekNumbers
{
    padding: 5px 20px 8px 8px;    
}
.dxeCalendarDayHeader
{
    font-family: Tahoma;
    font-size: 9pt;        
    padding: 2px 4px 5px;
    border-bottom: solid 1px #cfcfcf;
}
.dxeCalendarWeekNumber
{    
    font-family: Tahoma;
    font-size: 7pt;    
    text-align: right;    
    padding: 6px 8px 6px 4px;        
    color: #bfbfbf;
}
.dxeCalendarDay
{    
    font-family: Tahoma;
    font-size: 9pt;
    padding: 4px 6px;
    text-align: center;    
}
.dxeCalendarWeekend        /* inherits dxeCalendarDay */
{
    color: #c00000;
}
.dxeCalendarOtherMonth     /* inherits dxeCalendarDay */
{
    color: #888;
}
.dxeCalendarOutOfRange     /* inherits dxeCalendarDay */
{
    color: #d0d0d0;    
}
.dxeCalendarSelected       /* inherits dxeCalendarDay */
{
    color: White;
    background-color: #8d8d8d;
}
.dxeCalendarToday         /* inherits dxeCalendarDay */
{
    padding: 3px 3px 2px;
    border: solid 1px #c00000;    
}
.dxeCalendarHeader
{
    background-color: #dcdcdc;
    border: solid 1px #c9c9c9;    
    border-width: 1px 0;
    padding: 4px 7px;
}
.dxeCalendarHeader td.dxe
{
    font-family: Tahoma;
    font-size: 9pt;
    text-align: center;
	cursor: pointer;
	cursor: hand;
}
.dxeCalendarFooter 
{
    background-color: #ededed;
    padding: 8px 0px;    
    border-top: solid 1px #d6d6d6;
}
.dxeCalendarFastNav
{
    color: Black;
    background: White;
    border: solid 1px #9f9f9f;
    border-bottom: 0px;
    padding: 12px 8px;
}
.dxeCalendarFastNavMonthArea
{
    padding: 0px 9px;
}
.dxeCalendarFastNavYearArea
{    
}
.dxeCalendarFastNavFooter
{
    color: Black;
    background-color: #ededed;
    padding: 8px 0px;   
    border: solid 1px #9f9f9f;
    border-top: solid 1px #d6d6d6;
}
.dxeCalendarFastNavMonth, .dxeCalendarFastNavYear
{
    font: normal 9pt Tahoma;
    color: Black;
    padding: 3px 5px;
    text-align: center;
	cursor: pointer;
	cursor: hand;
}
.dxeCalendarFastNavMonth
{
	padding: 6px;
}
.dxeCalendarFastNavMonthSelected, .dxeCalendarFastNavYearSelected
{
    color: White;
    background: #8d8d8d;    
}
.dxeCalendarFastNavMonthHover, .dxeCalendarFastNavYearHover
{        
    color: Black;
    background: #e5e5e5;
    padding: 2px 4px;
    border: solid 1px #d6d6d6;
}
.dxeCalendarFastNavMonthHover
{
	padding: 5px;
}
/* Disabled */
.dxeDisabled, .dxeDisabled td.dxe
{
	color: #acacac;
	cursor: default;
}
a.dxeDisabled:hover
{
    color: #acacac;
}
.dxeButtonDisabled, .dxeButtonDisabled td.dxe
{
	border-color: #c3c3c3;
	color: #808080;
	cursor: default;
}
/* -- Button -- */
.dxbButton
{	
  	color: #000000;    
  	font-weight:normal;
	font-size: 9pt;
	font-family: Tahoma;				    
	vertical-align: middle;	 		
	border: solid 1px #7F7F7F;	
	background: #E0DFDF url('WebResource.axd?d=VlFBFRfk03WisYnQqxJn8Gk4796kZgU25YxsSNCABaOFHgxcOurwSMKjUKDYRp5eFhIXdcvmnaS_Qchd2WQ24W0jgVx-RL5hD3_v-ZnepQoQ2V7E61OMyjUGowNRbBkwaqGiJIa68pN1HwkEpTzU5TYjFVQQQtIu3OoZjfuR2_6DJsjDGBuYYp50rl-I6GFlEMtecA2&t=636117930522046151') top;
    background-repeat:repeat-x;
    padding: 1px 1px 1px 1px;
	cursor: pointer;
	cursor: hand;
}
.dxbButtonHover 
{
  	color: #000000;        
	background: #F2F2F2 url('WebResource.axd?d=wsZQGOfNffC4221UAb1qT0T4R_HTO1UYa2LfyRFY7meVNwvphMC3VYQX0E6IvCjmggkAeshrF6L6zk4eLAbdCijdf9yOboeMZg1g4eZQFRub3QcsMXNc0LHdj-uXcWdFyfNdxnXiTV-iN0zTU9BB-9fw4GR_Qm5gftc_hlmdF0PCR-ACfKnl2PGC-CUnhVvCyPM5yg2&t=636117930522046151') top;
    background-repeat: repeat-x;
	border: solid 1px #606060;
}
.dxbButtonChecked 
{
    color: #FFFFFF;
	background-image: none;
	background-color: #8D8D8D;
}
.dxbButtonPressed 
{
  	color: #000000;        
	background-image: none;
	background-color: #D5D5D5;
}
.dxbButton div.dxb
{    
    padding: 3px 8px 4px 8px;
	border: 0px;
}
.dxbButton div.dxbf
{     
    padding: 2px 7px 3px 7px;
	border: dotted 1px black;		
}
.dxbButton div.dxb table
{    
  	color: #000000;    
	font-size: 9pt;
	font-family: Tahoma;				    
}
.dxbButton div.dxb td.dxb
{    
    background-color: transparent!important;
    background-image: url('')!important;
    border-width: 0px!important;
    padding: 0px!important;
}
/* Disabled */
.dxbDisabled
{
    border-color: #c3c3c3;
	color: #808080;
	cursor: default;
}
.dxbDisabled td.dxb
{
	color: #808080;
}
/* -- FilterControl -- */
.dxfcTable
{	
	border-collapse: separate!important;		
}
.dxfcTable td.dxfc
{
	padding: 0px 0px 0px 3px;
	vertical-align: middle;
	font: 9pt Tahoma;
	color: Black;
}
a.dxfcPropertyName
{
	white-space: nowrap!important;
	color: Blue!important;
}
a.dxfcGroupType
{
	white-space: nowrap!important;
	padding: 0px 3px 0px 3px!important;
	color: Red!important;
}
a.dxfcOperation
{
	white-space: nowrap!important;
	color: Green!important;
}
a.dxfcValue
{
	white-space: nowrap!important;
	color: Gray!important;
}
.dxfcImageButton 
{
	cursor: pointer;
}

.dxfcLoadingDiv
{
	background: white;
	opacity: 0.01;
	filter: alpha(opacity=1);	
}
.dxfcLoadingPanel
{
	font: 9pt Tahoma;
	color: #303030;
	border: solid 1px #9F9F9F;
	background: white;	
}
.dxfcLoadingPanel td.dx
{
	white-space: nowrap;
	text-align: center;
	padding: 12px 12px 12px 12px;
}