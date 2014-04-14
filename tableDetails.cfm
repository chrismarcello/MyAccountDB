<cfset tableID = Request.cTableFunctions.getTableID(tableName="#tableName#") />
<cfset theClient = Request.clients.getTheClient(clientID=#tableID.clientID#) />
<cfset session.clientID = #theClient.clientID# />
<cfset session.tableID = #tableID.tableID# />
<cfset dataColumns = Request.dbTables.getTableColumns(tableName=#tableName#) />
<cfset getSQL = Request.cTableFunctions.getTableSQL(tableID="#tableID.tableID#") />
<cfset colCount = 0 />
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />

        <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame
        Remove this if you use the .htaccess -->
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<cfheader
	name="x-powered-by"
	value="#Server.ColdFusion.ProductVersion#"
	/>
<cfheader name="Cache-Control" value="no-cache">
<cfheader name="Expires" value="0">

	
<link href="assets/images/favicon.ico" rel="shortcut icon">
		<title>Table Details: <cfoutput>#tableName#</cfoutput></title>
<link href="assets/lib/jQueryUI/1.10.1/themes/cupertino/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<link href="assets/lib/jQueryPluggins/jquery-layout/1.3.0/layout-default-latest.css" rel="stylesheet" type="text/css" />
<link href="//cdnjs.cloudflare.com/ajax/libs/datatables/1.9.4/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css">
<link type="text/css" rel="stylesheet" href="assets/lib/jQueryPluggins/jqGrid/4.5.2/css/ui.jqgrid.css" />
<script src="assets/lib/jQuery/jquery-1.10.1.min.js" type="text/javascript"></script>
<script src="assets/lib/jQueryUI/1.10.1/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-layout/1.3.0/jquery.layout-latest.min.js"></script>

<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-layout/1.3.0/jquery.layout.resizeTabLayout-1.3.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-layout/1.3.0/jquery.layout.resizePaneAccordions-1.2.min.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-json/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="assets/lib/jQueryUI/1.10.1/Super-Theme-Switcher/jquery.themeswitcher.min.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/datatables/1.9.4/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jqGrid/4.5.2/js/i18n/grid.locale-en.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jqGrid/4.5.2/js/jquery.jqGrid.min.js"></script>



<style>
  .ui-tooltip, .arrow:after {
    background: black;
    border: 2px solid white;
  }
  .ui-tooltip {
    padding: 10px 20px;
    color: white;
    border-radius: 20px;
    font: bold 14px "Helvetica Neue", Sans-Serif;
    text-transform: uppercase;
    box-shadow: 0 0 7px black;
  }
  .arrow {
    width: 70px;
    height: 16px;
    overflow: hidden;
    position: absolute;
    left: 50%;
    margin-left: -35px;
    bottom: -16px;
  }
  .arrow.top {
    top: -16px;
    bottom: auto;
  }
  .arrow.left {
    left: 20%;
  }
  .arrow:after {
    content: "";
    position: absolute;
    left: 20px;
    top: -20px;
    width: 25px;
    height: 25px;
    box-shadow: 6px 5px 9px -9px black;
    -webkit-transform: rotate(45deg);
    -moz-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    -o-transform: rotate(45deg);
    tranform: rotate(45deg);
  }
  .arrow.top:after {
    bottom: -20px;
    top: auto;
  }
  
  .image_container{
                width:675px;
                height:35px;
                padding:5px;              
                background-color:#f7f7f7;
                border:1px solid #ccc;
                -moz-box-shadow: 0 1px 3px #777;
                -webkit-box-shadow: 0 1px 3px #777;
                margin: 0 auto;
            }           
            .transparent{
                opacity: 1.0;
            }
            ul.toolbar{
                position:relative;
                width:670px;
                height:32px;
                margin:0px;
                padding:0px;
                background-color:#fff;
                border-bottom:2px solid #ccc;
                list-style-type:none;				
            }
            ul.toolbar li{
                display:inline;                            
            }
            ul.toolbar li div, .navigation div{ 
                float:left;
                cursor:pointer;
                width:70px;
                height:32px;
                opacity: 0.6;
            }		
            ul.toolbar li div:hover, .navigation div:hover{                
                opacity: 1.0;
            }
			 ul.toolbar li a, .navigation a{ 
                float:left;
                cursor:pointer;
                width:70px;
                height:32px;
                opacity: 0.6;
            }		
            ul.toolbar li a:hover, .navigation a:hover{                
                opacity: 1.0;
            }
			div.import{
                background:#fff url(http://10.40.3.136/CDN/Icons/large/text_imports.png) no-repeat center center;
            }
            a.runSQL{
                background:#fff url(http://10.40.3.136/CDN/Icons/large/remote_sql.png) no-repeat center center;
            }
            div.createTable{
                background:#fff url(http://10.40.3.136/CDN/Icons/large/table_lightning.png) no-repeat center center;
            }
			div.tableDelete{
                background:#fff url(http://10.40.3.136/CDN/Icons/large/table_delete.png) no-repeat center center;
            }
			div.tableExportText{
                background:#fff url(http://10.40.3.136/CDN/Icons/large/text_exports.png) no-repeat center center;
            }
			div.tableExportExcel{
                background:#fff url(http://10.40.3.136/CDN/Icons/large/table_excel.png) no-repeat center center;
            }
  </style>
<script type="text/javascript">
	
	
	$(function(){
	var importFile = function() {
		var dataString = $("#importThisFile").serialize();
			
		//alert(dataString);
		var importStatus = $("#importStatus");
		
	
	//First, do a statuc message
        importStatus.html('<div align="center"><img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');

		
	$.ajax({
	type: "get",
	url: "com/dbTables.cfc?method=importFile",
	data: dataString,
	cache: false,
	dataType: "html",
	success: function(msg){
		
		if (msg == '') {
			$("#importStatus").html("Sorry, an error has occurred and the file was not created.");
		}
		else {
			$("#importStatus").html("The data file has been imported.");
			$(".message").show();
			$(".message").fadeOut(25000);
			$("#accountGrid").trigger("reloadGrid",[{page:1}]);
		}
	
  }
 }) 

$( this ).dialog( "close" );
		
	}
	var cancel = function() {
		$( this ).dialog( "close" );
	}
	var dataFileDialogOpts = {
		buttons: {
		"OK": importFile,
		"Cancel": cancel
		},
		autoOpen: false,
		height: 550,
		width: 850,
		modal: true,
		show: {
		effect: "blind",
		duration: 1000
		},
		hide: {
		effect: "explode",
		duration: 1000
		}
	};
	
	$("#importTheFile").dialog(dataFileDialogOpts);
	$( "#fileImport" ).click(function(){
		$( "#importTheFile" ).dialog( "open" );
		
	});
});	

$(function(){
	var exportFile = function() {
		var dataString = $("#exportThisFile").serialize();
			
		//alert(dataString);
		var importStatus = $("#importStatus");
		
	
	//First, do a statuc message
        importStatus.html('<div align="center"><img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');

		

	$.ajax({
	type: "get",
	url: "com/dbTables.cfc?method=exportTable",
	data: dataString,
	cache: false,
	dataType: "html",
	success: function(msg){
		
		if (msg == '') {
			$("#importStatus").html("Sorry, an error has occurred and the file was not created.");
		}
		else {
			$("#importStatus").html("The data file has been imported.");
			$(".message").show();
			$(".message").fadeOut(25000);
			$("#accountGrid").trigger("reloadGrid",[{page:1}]);
		}
	
  }
 }) 


$( this ).dialog( "close" );
		
	}
	var cancel = function() {
		$( this ).dialog( "close" );
	}
	var exportFileDialogOpts = {
		buttons: {
		"OK": exportFile,
		"Cancel": cancel
		},
		autoOpen: false,
		height: 550,
		width: 850,
		modal: true,
		show: {
		effect: "blind",
		duration: 1000
		},
		hide: {
		effect: "explode",
		duration: 1000
		}
	};
	
	$("#exportTheFile").dialog(exportFileDialogOpts);
	$( "#exportText" ).click(function(){
		$( "#exportTheFile" ).dialog( "open" );
		
	});
});	

//Run SQL Functions
$(document).ready(function(){
$( "#sqlScriptRun" ).click(function(){
    url = $(this).attr("href");
    dialog_box = $('<div id="sql_div" style="display:hidden"></div>').appendTo('body');
    // load remote content
    dialog_box.load(url,{},function() {
        dialog_box.dialog({
            close: function(){
                $("#sql_div").remove();
            },
            modal: true,
        buttons: {
		"OK": function(){
               
		
		var dataString = $("#runSQLFORM").serialize();
			
		//alert(dataString);
		var sqlStatus = $("#sqlStatus");
		
	
	//First, do a statuc message
        sqlStatus.html('<div align="center"><img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');

		
	$.ajax({
	type: "get",
	url: "com/clientTableFunctions.cfc?method=runSQL",
	data: dataString,
	cache: false,
	dataType: "html",
	success: function(msg){
		
		
			$("#sqlStatus").html("The SQL Script has been completed.");
			$(".message").show();
			$(".message").fadeOut(25000);
			$("#accountGrid").trigger("reloadGrid",[{page:1}]);
		
	
  }
 }) 
 			 $("#sql_div").remove();
            },
		"Cancel": function(){
                $("#sql_div").remove();
            }
		},
		height: 550,
		width: 850,
		modal: true,
		show: {
		effect: "blind",
		duration: 1000
		},
		hide: {
		effect: "explode",
		duration: 1000
		}
        });
    });
    return false;
});


});

	
	$(document).ready(function() {
   
   $('body').layout({
		//	reference only - these options are NOT required because 'true' is the default
			closable:					true	// pane can open & close
		,	resizable:					true	// when open, pane can be resized 
		,	slidable:					true	// when closed, pane can 'slide' open over other panes - closes on mouse-out
		,	livePaneResizing:			true

		//	some resizing/toggling settings
		,	north__slidable:			false	// OVERRIDE the pane-default of 'slidable=true'
		,	north__togglerLength_closed: '100%'	// toggle-button is full-width of resizer-bar
		,	north__spacing_closed:		20		// big resizer-bar when open (zero height)
		,	south__resizable:			true	// OVERRIDE the pane-default of 'resizable=true'
		,	south__spacing_open:		0		// no resizer-bar when open (zero height)
		,	south__spacing_closed:		20		// big resizer-bar when open (zero height)

		//	some pane-size settings
		,	west__minSize:				100
		,	north__size:				100
		//,	north__minSize:				200
		,	north__maxSize:				250 // 50% of layout width
		,	center__minWidth:			100
		,	south__size:				100

		//	some pane animation settings
		,	west__animatePaneSizing:	false
		,	west__fxSpeed_size:			"fast"	// 'fast' animation when resizing west-pane
		,	west__fxSpeed_open:			1000	// 1-second animation when opening west-pane
		,	west__fxSettings_open:		{ easing: "easeOutBounce" } // 'bounce' effect when opening
		,	west__fxName_close:			"none"	// NO animation when closing west-pane

		//	enable showOverflow on west-pane so CSS popups will overlap north pane
		,	west__showOverflowOnHover:	true

		//	enable state management
		,	stateManagement__enabled:	true // automatic cookie load & save enabled by default

	});
   
	var tableName = '<cfoutput>#tableName#</cfoutput>';
	
	jQuery("#accountGrid").jqGrid({
		datatype: function(postdata7) {
        jQuery.ajax({
           url: 'com/accounts.cfc',
			data: $.extend(true, {}, postdata7, {tableName: tableName}),
			method:'POST',
			dataType:"json",
			complete: function(jsondata7,stat7)

			{ if(stat7=="success") {

			var thegrid7 = jQuery("#accountGrid")[0];

		thegrid7.addJSONData(eval("("+jsondata7.responseText+")"))

			}

		}

	});

}
		,
	
		width:950,
		height: 375,
		loadui: 'block',
		altRows: true,
		deepempty: true,
		//caption: "<cfoutput>#tableName#</cfoutput>",
		pager:'#accountPager',
		toppager: true,
		//pagerpos:'left',
		
		//toolbar:[true,"top"],
		
		rowNum:50,
		rowList:[10,20,30,40,50,100,200,500],
		viewrecords: true,
		rownumbers: false,
		//loadonce: true,
		gridview: true,
		rownumWidth: 40,
		sortname: 'AccountNumber',
		sortorder: 'asc',
		
		colModel: [
			<cfoutput>
				<cfloop query="dataColumns">
					<cfset colCount = #colCount# + 1 />
						<cfif colCount EQ dataColumns.RecordCount>
					{name:'#dataColumns.columnName#', hidden:false, key: true, label: '#dataColumns.columnName#'}
								<cfelse>	
					{name:'#dataColumns.columnName#', hidden:false, key: true, label: '#dataColumns.columnName#'},			
						</cfif>
				</cfloop>
			</cfoutput>
			
			
		],
		
		prmNames:{page:"pageIndex",sort:"sortCol",order:"sortDir",rows:"pageSize"},
		postData:{method:"getTableData",returnFormat:"JSON"},
		jsonReader: {
			id: "AccountNumber", // function(obj){return $.inArray("ID",obj.data.COLUMNS);}, *not yet, but I'm working on it*
			root: "data.DATA",
			page: "pageIndex",
			total: "pageCount",
			records: "recordCount",
			cell:""
		},
	});
	
	
	jQuery("#accountGrid").jqGrid('navGrid','#accountPager', {edit:false,add:false,del:false}, {}, {}, {}, {multipleSearch:false, multipleGroup:false, showQuery: false,
	sopt: ['eq','cn','bw','ew','ne','lt','le','gt','ge']
	
	} );
	
	jQuery("#accountInfoGrid").jqGrid({
		datatype: function(postdata2) {
        jQuery.ajax({
           url: 'com/accounts.cfc',
			data: $.extend(true, {}, postdata2, {tableName: tableName}),
			method:'POST',
			dataType:"json",
			complete: function(jsondata2,stat2)

			{ if(stat2=="success") {

			var thegrid2 = jQuery("#accountInfoGrid")[0];

		thegrid2.addJSONData(eval("("+jsondata2.responseText+")"))

			}

		}

	});

}
		,
	
		width:950,
		height: 450,
		loadui: 'block',
		altRows: true,
		deepempty: true,
		//caption: "<cfoutput>#tableName#</cfoutput>",
		pager:'#accountInfoPager',
		toppager: true,
		//pagerpos:'left',
		
		//toolbar:[true,"top"],
		
		rowNum:10,
		rowList:[10,20,30,40,50],
		viewrecords: true,
		rownumbers: true,
		//loadonce: true,
		gridview: true,
		rownumWidth: 40,
		sortname: 'columnPosition',
		sortorder: 'asc',
		
		colModel: [
			
						
					{name:'tableLineID', hidden:true, key: true},
					{name:'columnPosition', hidden:false, key: true, label: 'Position'},
					{name:'columnName', hidden:false, key: true, label: 'Field Name'},
					{name:'columnType', hidden:false, key: true, label: 'Data Type'},
					{name:'columnLength', hidden:false, key: true, label: 'Column Length'},	
					{name:'defaultValue', hidden:false, key: true, label: 'Default Value'},	
					{name:'autoIncrement', hidden:false, key: true, label: 'Auto Increment'}	
		],
		
		prmNames:{page:"pageIndex",sort:"sortCol",order:"sortDir",rows:"pageSize"},
		postData:{method:"getTableDetails",returnFormat:"JSON"},
		jsonReader: {
			id: "tableLineID", // function(obj){return $.inArray("ID",obj.data.COLUMNS);}, *not yet, but I'm working on it*
			root: "data.DATA",
			page: "pageIndex",
			total: "pageCount",
			records: "recordCount",
			cell:""
		},
	});
	
	
	jQuery("#accountInfoGrid").jqGrid('navGrid','#accountInfoPager', {edit:false,add:false,del:false}, {}, {}, {}, {multipleSearch:false, multipleGroup:false, showQuery: false,
	sopt: ['eq','cn','bw','ew','ne','lt','le','gt','ge']
	
	} );
	
$(function() {
    $( document ).tooltip({
      position: {
        my: "center bottom-20",
        at: "center top",
        using: function( position, feedback ) {
          $( this ).css( position );
          $( "<div>" )
            .addClass( "arrow" )
            .addClass( feedback.vertical )
            .addClass( feedback.horizontal )
            .appendTo( this );
        }
      }
    });
  });
			
});	

//Tab Script
$(function() {
 	$( "#tabs" ).tabs();
	
 });	
 //File Reader
$(document).ready(function(){
$('#dataFile').bind("change keyup", zipcode_check);
});
function zipcode_check(){
var showFiles = $("#showFiles");		
var fileReader = $("select#dataFile").val();

		
	
	//First, do a statuc message
        showFiles.html('<div align="center"><img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');

 $( "#showFiles" ).load( "ajaxPages/readFile.cfm", { dataFile: fileReader } );
}

$(document).ready(function () {
	$("#addSql").click(function () {
	
		var statusSQL = $("#statusSQL");
		var theSQL = $("textarea[name=sql]").val();
		
		var dataString = 'sql=' + encodeURIComponent(theSQL) + '&tableId=' + <cfoutput>#session.tableID#</cfoutput>;
		
		//alert(dataString);
		
		//First, do a statuc message
        statusSQL.html('<img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');
	   
   $.ajax({
	type: "post",
	url: "com/clientTableFunctions.cfc?method=editSQL",
	data: dataString,
	cache: false,
	success: function(msg){
	$("#statusSQL").html("SQL Statement has been added or updated!");
	$(".message").show();
	$(".message").fadeOut(25000);
	

  }
    });
 });
 
 $("#tableCreate").click(function () {
	
		var importStatus = $("#importStatus");
		
		
		var dataString = 'clientID=' + <cfoutput>#session.clientID#</cfoutput> + '&tableID=' + <cfoutput>#session.tableID#</cfoutput>;
		
	
		
		//First, do a statuc message
        importStatus.html('<img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');
	   
   $.ajax({
	type: "post",
	url: "com/dbTables.cfc?method=createTable",
	data: dataString,
	cache: false,
	success: function(msg){
	$("#importStatus").html("The table has been created, please refresh the page!");
	$(".message").show();
	$(".message").fadeOut(25000);
	

  }
    });
 });
});
</script>
		
	</head>
<body>
<div class="ui-layout-center" id="content">	
<cfset tableCheck = Request.cTableFunctions.tableExists(tableName="#tableName#") />
	
	<div id="tabs">
  <ul>
    <li><a href="#tabs-1"><cfoutput>Data for #tableName#</cfoutput></a></li>
    <li><a href="#tabs-2">Table Information</a></li>
   <li><a href="#tabs-3">SQL Statements</a></li>
  </ul>	
  <div id="tabs-1">
  	<div class="ui-widget-content container">
  	<cfif tableCheck.RecordCount>	
  		<cfset data = Request.dbBasic.getTableData(tableName=#tableName#) />
		
			
				
				<div id="gridBlock">
					<div id="gridCont" class="gridCont">
						<table id="accountGrid" class="gTable"></table>
						<div id="accountPager" class="gTable"></div>
				
					</div><br clear="all" />
				</div>
				
			<cfelse>
				Table does not exist.
	  </cfif>			
	</div>
	</div><!--- End of Tab 1 --->
	<div id="tabs-2">
		<div id="gridBlock">
					<div id="gridCont2" class="gridCont">
						<table id="accountInfoGrid" class="gTable"></table>
						<div id="accountInfoPager" class="gTable"></div>
				
					</div><br clear="all" />
				</div>
	</div><!--- End of Tab 2 --->
	<div id="tabs-3"><!--- Start Tab 3 --->
		<p>
	<form action="" name="sqlForm" id="sqlForm">
	<fieldset>		
		<textarea id="sql" name="sql" cols="80" rows="10"><cfif getSQL.RecordCount GT 0>
			<cfoutput>#getSQL.sqlScript#</cfoutput>
		</cfif></textarea><br>
		
    </fieldset>
	</form>    
			<button id="addSql"><img src="/assets/icons/large/sql_server.png" border="0" alt="Add or Update Table SQL" title="Add or Update Table SQL"></button>
	
    
		</p>
		<div id="statusSQL" class="message"></div>
	</div><!--- End of Tab 3 --->
	</div><!--- End of Tabs --->
</div>
<div class="ui-layout-north">
	<div align="left">&nbsp;
         
		<a href="index.cfm"><img src="./assets/icons/large/home_page.png" border="0" alt="Home Page" title="Home Page"></a> &nbsp;	
        
	</div>	
</div> <!-- End of North Layout -->
<div class="ui-layout-south">
	<div id="image_container">
	<ul class="toolbar transparent" id="tlbar">
		<li><div id="fileImport" class="import" title="Import Customer File."></div></li>
		<li><a href="ajaxPages/tableSQL.cfm?tableID=#session.tableID#" id="sqlScriptRun" class="runSQL" title="Run SQL script."></a></li>
		<li><div id="tableCreate" class="createTable" title="Build Table"></div></li>
		<li><div id="deleteTable" class="tableDelete" title="Delete Table"></div></li>
		<li><div id="exportText" class="tableExportText" title="Export to Text File."></div></li>
		<li><div id="exportExcel" class="tableExportExcel" title="Export to Excel File."></div></li>
	</ul>
</div>
</div>

<div class="ui-layout-west">
	
	<div id="importStatus" class="message"></div>
	<div id="sqlStatus" class="message"></div>
</div>

<!-- Import Files Dialog -->
<div id="importTheFile" title="Import Data File">
	
	<cfset currentDirectory = "#request.basePath#clientFiles\imports\">
<cfdirectory directory="#currentDirectory#" name="dirQuery" action="LIST">
	<div id="showFiles"></div>
	<p><form action="" name="importThisFile" id="importThisFile">
	<fieldset>
				    <select name="dataFile" id="dataFile">
						<option value="" selected="selected">Select File to Import</option>
						
						<cfloop query="dirQuery">
						<cfoutput><option value="#dirQuery.name#">#dirQuery.name#</option></cfoutput>
						</cfloop>
					</select><br>
					
					<select name="addMake" id="addMake">
						<option value="" selected="selected">Create Table</option>
						<option value="Yes">Yes</option>
						<option value="No">No - Add to Existing Table</option>
						<option value="Tun">No - Empty Existing Data</option>
					</select>
	</fieldset>
	<fieldset>
		<label for="delimiter"><h3>Select File Delimiter</h3></label>
		<ul>
									
									
                	<cfset theFileDelimiter = Request.files.getDelimiters() />
									<cfloop query="theFileDelimiter">
				<cfoutput>
                	<li><img src="../#theFileDelimiter.fileDelimIcon#" alt="#UCase(theFileDelimiter.fileDelimName)#" title="#UCase(theFileDelimiter.fileDelimName)#" border="0">
						<cfif theFileDelimiter.fileDelimDefault EQ 1>
							<input type="radio" name="delimiter" id="delimiter" value="#theFileDelimiter.fileDelimID#" checked="checked">
							<cfelse>
								<input type="radio" name="delimiter" id="delimiter" value="#theFileDelimiter.fileDelimID#">
						</cfif>
		
					</li>
                </cfoutput>
				</cfloop>
		</ul>		
	</fieldset>
	<fieldset>	<ul>			<!---<li><h2>Quote Object Names</h2></li>--->
					<li>
				<img src="./assets/icons/alphanumeric/red/035.png" alt="Add Quotes to Object Names" border="0" title="Quote Object Names">	
					<input type="radio" name="surroundData" id="surroundData" value="surround1">
				</li>
				</ul>
			<label for="header"><b>Column name as header:</b></label>	
	 <input type="radio" name="header" value="useHeader"><br>

	<select name="theStartRow" id="theStartRow">
		<option value="0" selected="selected">Select Start Row</option>
		<cfloop index="i" from="1" to="100">
			<cfoutput><option value="#i#">#i#</option></cfoutput>
		</cfloop>
	</select><br>

	<select name="linesTerm" id="linesTerm">
		<option value="1" selected="selected">\r\n</option>
		<option value="2">\n</option>
		
	</select><br>	
			<select name="deleteFile" id="deleteFile">
				<option value="delete" selected="selected">Delete File</option>
				<option value="delete">Yes</option>
				<option value="">No - Keep File</option>
			</select><br>
	
			<select name="archiveFile" id="archiveFile">
				<option value="archive" selected="selected">Archive File</option>
				<option value="archive">Yes</option>
				<option value="">No - Don't Archive</option>
			</select><br>
	</fieldset>
	<cfoutput>
    	<input type="hidden" name="tableID" id="tableID" value="#session.tableID#">
	<input type="hidden" name="clientID" id="clientID" value="#session.clientID#">
    </cfoutput>
		</form></p>		
</div>

<!-- Export Files Dialog -->
<div id="exportTheFile" title="Export Table to File">
	
	
	<p><form action="" name="exportThisFile" id="exportThisFile">
	<fieldset>
				<label for="fileName"><b>File Name</b></label><br>
				   <input type="text" name="fileName" id="fileName" value="<cfoutput>#tableName#</cfoutput>"><br>
		   <select name="addTimeStamp" id="addTimeStamp">
				<option value="" selected="selected">Add time stamp to file name</option>
				<option value="">No</option>
				<option value="1">Yes</option>
			</select><br>
		   <select name="fileType" id="fileType">
				<option value="txt" selected="selected">File Type</option>
				<option value="txt">Text</option>
				<option value="csv">CSV</option>
			</select><br>
					
					
	</fieldset>
	<fieldset>
		<label for="delimiter"><h3>Select File Delimiter</h3></label>
		<ul>
									
									
                	<cfset theFileDelimiter = Request.files.getDelimiters() />
									<cfloop query="theFileDelimiter">
				<cfoutput>
                	<li><img src="../#theFileDelimiter.fileDelimIcon#" alt="#UCase(theFileDelimiter.fileDelimName)#" title="#UCase(theFileDelimiter.fileDelimName)#" border="0">
						<cfif theFileDelimiter.fileDelimDefault EQ 1>
							<input type="radio" name="delimiter" id="delimiter" value="#theFileDelimiter.fileDelimID#" checked="checked">
							<cfelse>
								<input type="radio" name="delimiter" id="delimiter" value="#theFileDelimiter.fileDelimID#">
						</cfif>
		
					</li>
                </cfoutput>
				</cfloop>
		</ul>		
	</fieldset>
	<fieldset>	<ul>			<!---<li><h2>Quote Object Names</h2></li>--->
					<li>
				<img src="./assets/icons/alphanumeric/red/035.png" alt="Add Quotes to Object Names" border="0" title="Quote Object Names">	
					<input type="radio" name="surroundData" id="surroundData" value="surround1">
				</li>
				</ul>
			<label for="header"><b>Column name as header:</b></label>	
	 <input type="radio" name="header" value="useHeader"><br>

	

	<select name="linesTerm" id="linesTerm">
		<option value="1" selected="selected">\r\n</option>
		<option value="2">\n</option>
		
	</select><br>	
			
	</fieldset>
	<cfoutput>
    	<input type="hidden" name="tableID" id="tableID" value="#session.tableID#">
	<input type="hidden" name="clientID" id="clientID" value="#session.clientID#">
    </cfoutput>
		</form></p>		
</div>
<script type="text/javascript">
            $(function() {
                $('#img_cont').hover(
                function () {
                    $('#tlbar').slideDown(200);
                    $('#nav').slideDown(200);
                },
                function () {
                    $('#tlbar').slideUp(200);
                    $('#nav').slideUp(200);
                }
            );
                $('#tlbar,#nav').hover(
                function () {
                    $(this).removeClass('transparent');
                },
                function () {
                    $(this).addClass('transparent');
                }
            );
            });
        </script>
		
</body>	
</html>