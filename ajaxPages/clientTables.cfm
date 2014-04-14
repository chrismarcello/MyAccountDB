<html>
	<head>
		<script type="text/javascript">
			
	//Bind all install links to click event and dynamically build and load the remote form.
$( "#addTable" ).click(function(){
    url = "ajaxPages/newTableForm.cfm";
    dialog_box = $('<div id="newtable_div" style="display:hidden"></div>').appendTo('body');
	
	
    // load remote content
    dialog_box.load(url,{},function() {
        dialog_box.dialog({
            close: function(){
                $("#newtable_div").remove();
            },
            modal: true,
			buttons: {
		"OK": function(){
		var tableList = $("#tableList");
		var dataString = $("#newTableForm").serialize();	
        
	
	//First, do a statuc message
        tableList.html('<img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');
		
		$.ajax({
	type: "get",
	url: "com/dbTables.cfc?method=defineTable&returnformat=plain",
	data: dataString,
	cache: false,
	success: function(msg){
		
		if (msg == '') {
			$("#tableList").html("Sorry, an error has occurred and the file was not created.");
		}
		else {
			$("#tableList").html(msg);
			$('input#tableName').val('');
			//$('input#oscTableName').val('');
			//$('input#clientNumber').val('');
		}
	
  }
 })
	$("#newtable_div").remove();
            },
		"Cancel": function(){
                $("#newtable_div").remove();
            }
		},
		height: 450,
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
		
$( "#copyTable" ).click(function(){
    url = "ajaxPages/copyTableForm.cfm";
    dialog_box = $('<div id="copytable_div" style="display:hidden"></div>').appendTo('body');
	
	
    // load remote content
    dialog_box.load(url,{},function() {
        dialog_box.dialog({
            close: function(){
                $("#copytable_div").remove();
            },
            modal: true,
			buttons: {
		"OK": function(){
		var tableList = $("#tableList");
		var dataString = $("#copyTableForm").serialize();	
        
	
	//First, do a statuc message
        tableList.html('<img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');
		
		$.ajax({
	type: "get",
	url: "com/dbTables.cfc?method=copyTable&returnformat=plain",
	data: dataString,
	cache: false,
	success: function(msg){
		
		if (msg == '') {
			$("#tableList").html("Sorry, an error has occurred and the file was not created.");
		}
		else {
			$("#tableList").html(msg);
			$('input#tableName').val('');
			
		}
	
  }
 })
	 $("#copytable_div").remove();
            },
		"Cancel": function(){
                $("#copytable_div").remove();
            }
		},
		height: 450,
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
  
$(document).ready(function(){
$('#fieldNumber').bind("change keyup", getTableForm);
});  
function getTableForm(){
var tableForm = $("#tableForm");		
var fieldNumber = $("select#fieldNumber").val();

		
	
	//First, do a statuc message
        tableForm.html('<div align="center"><img src="./assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');



	   $( "#tableForm" ).load( "ajaxPages/columnForm.cfm", { fieldNumber: fieldNumber } );
					

}

$(document).ready(function() {
	
	 $( "div.showTable" ).click(function() {
	 	var tableInfo = $("#tableInfo");
	 	var theID = $(this).attr("data-target");
		//First, do a statuc message
       tableInfo.html('<div align="center"><img src="./assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');		
	 	$( "#tableInfo" ).load( "ajaxPages/tableInfo.cfm", { tableName: theID });
		
		
		$(function(){
	var searchTable = function() {
		var searchResults = $("#searchResults");
		var theTableName = $("input#theTableName").val;
		var searchTerm = $("input#searchTerm").val();
		
		var dataString = 'theTableName='+ theTableName + '&searchTerm=' + searchTerm;
	
	//First, do a statuc message
        searchResults.html('<img src="./assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');

		
	$.ajax({
	type: "get",
	url: "ajaxPages/tableSearch.cfm",
	data: dataString,
	cache: false,
	success: function(msg){
		
		if (msg == '') {
			$("#searchResults").html("Sorry, an error has occurred and the file was not created.");
		}
		else {
			$("#searchResults").html(msg);
			$('input#searchTerm').val('');
			
		}
	
  }
 }) 

//$( this ).dialog( "close" );
		
	}
	var cancel = function() {
		$( this ).dialog( "close" );
	}
	var searchThisTableOpts = {
		buttons: {
		"OK": searchTable,
		"Cancel": cancel
		},
		autoOpen: false,
		height: 650,
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
	$("#endDays").datepicker({
		showOn: 'button',
		buttonImage: '/assets/icons/small/calendar-day.png',
		buttonImageOnly: true,
		dateFormat: 'mm/dd/yy'
	})
	
	$("#searchThisTable").dialog(searchThisTableOpts);
	$( "#searchTable" ).click(function() {
		$( "#searchThisTable" ).dialog( "open" );
		
	});
});
		
	 }); 
});	

		</script>
	</head>
<body>
<cfoutput>
	<cfset theClient = Request.clients.getTheClient(clientID=#clientID#) />
	<cfset theTableList = Request.cTableFunctions.getTableList(clientID=#clientID#) />
	<cfset Session.clientID = #clientID# />

	<div class="ui-widget-header ui-corner-top">Client Tables: #theClient.clientName#</div>
	<ul>
		<cfloop query="theTableList">
			<!---<li>#theTableList.tableName#</li>--->
			<li><div id="#theTableList.tableName#" class="showTable" data-target="#theTableList.tableName#" title="Click to see details.">
    				#theTableList.tableName#
			</div></li>
		</cfloop>
	</ul><div id="tableList"></div>
<!---<div id="image_container">
	<ul class="toolbar transparent" id="tlbar" style="display:none;">
		<li id="addTable" title="Define a new table."><img src="http://10.40.3.136/CDN/Icons/medium/table_add.png"></li>
	</li>--->
	<div id="addTable" title="Define a new table."><img src="assets/icons/large/table_add.png"></div>
	<div id="copyTable" title="Copy a table."><img src="assets/icons/large/table_multiple.png"></div>
</div>	
	
</cfoutput>

</body>	
</html>

