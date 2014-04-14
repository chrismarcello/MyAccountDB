<cfset tableID = Request.cTableFunctions.getTableID(tableName="#tableName#") />
<!---<cfdump var="#tableID#">--->
<script type="text/javascript">	

//Bind all install links to click event and dynamically build and load the remote form.
$( "#searchTable" ).click(function(){
    url = $(this).attr("href");
    dialog_box = $('<div id="temp_div" style="display:hidden"></div>').appendTo('body');
	
	
    // load remote content
    dialog_box.load(url,{},function() {
        dialog_box.dialog({
            close: function(){
                $("#temp_div").remove();
            },
            modal: true,
			buttons: {
		"OK": function(){
                var searchResults = $("#searchResults");
		//var theTableName = $("input#theTableName").val;
		var searchTerm = $("input#searchTerm").val();
		
		var dataString = 'searchTerm=' + searchTerm + '&myTable=' + <cfoutput>#tableID.tableID#</cfoutput>;
	
	//First, do a statuc message
        searchResults.html('<img src="./assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');
		
		$.ajax({
	type: "get",
	url: "ajaxPages/tableSearchResults.cfm",
	data: dataString,
	cache: false,
	dataType: "html",
	success: function(msg){
		
		/*if (msg == '') {
			$("#searchResults").html("Sorry, an error has occurred and the file was not created.");
		}*/
		//else {
			//console.log(msg);
			$("#searchResults").html(msg);
			$('input#searchTerm').val('');
			
				//$("#searchTable").dataTable();
			
		//}
	
  }
 }) 
            },
		"Cancel": function(){
                $("#temp_div").remove();
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
//Bind all install links to click event and dynamically build and load the remote form.
$( "#addNewAcct" ).click(function(){
    url = $(this).attr("href");
    dialog_box = $('<div id="acct_div" style="display:hidden"></div>').appendTo('body');
    // load remote content
    dialog_box.load(url,{},function() {
        dialog_box.dialog({
            close: function(){
                $("#acct_div").remove();
            },
            modal: true
        });
    });
    return false;
});
$( "#truncateTable" ).click(function(){
    url = $(this).attr("href");
    dialog_box = $('<div id="empty_div" style="display:hidden"></div>').appendTo('body');
    // load remote content
    dialog_box.load(url,{},function() {
        dialog_box.dialog({
            close: function(){
                $("#empty_div").remove();
            },
            modal: true,
        buttons: {
		"OK": function(){
               
		
		var dataString = $("#emptyTheTableForm").serialize();
	
	
		
		$.ajax({
	type: "get",
	url: "com/dbBasic.cfc?method=emptyTable",
	data: dataString,
	cache: false,
	dataType: "html",
	success: function(msg){
		
		
			$("#tableList").html("Table has been emptied.");
			
	
  }
 }) 
            },
		"Cancel": function(){
                $("#empty_div").remove();
            }
		},
		height: 350,
		width: 450,
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


</script>


<div id="image_container">
	<div class="ui-widget-header ui-corner-top">Table Details: <cfoutput>#tableName#</cfoutput></div>
	<ul class="toolbar transparent" id="tlbar">
		<li><cfoutput><a class="search" id="searchTable" href="ajaxPages/tableSearch.cfm?tableName=#tableName#" title="Search accounts"></a></cfoutput></li>
		<li><cfoutput><a class="addAcct" id="addNewAcct" href="ajaxPages/addAccountForm.cfm?clientID=#tableID.clientID#" title="Add a new account"></a></cfoutput></li>
		<li><cfoutput><a class="empty" id="truncateTable" href="ajaxPages/emptyTable.cfm?tableName=#tableName#" title="Empty this table."></a></cfoutput></li>
		<li><cfoutput><a class="details" href="tableDetails.cfm?tableName=#tableName#" title="View table details."></a></cfoutput></li>
	</ul>
</div>




<cfset tableCheck = Request.cTableFunctions.tableExists(tableName="#tableName#") />
<cfif tableCheck.RecordCount>
	<cfset getRecordCount = Request.dbTables.getTableRecordCount(tableName=#tableName#) />
<b>Records:</b> <cfoutput>#NumberFormat(getRecordCount)#</cfoutput>	
<cfquery name="getHistory" datasource="accountNumbersNew">
		SELECT * 
		FROM fileImportHistory
		WHERE clientTableID = #tableID.tableID#
		ORDER BY importedDate DESC
	</cfquery>
	<cfif getHistory.RecordCount>
	<ul>
		<cfoutput query="getHistory">
		<li>File #importFileName# was imported #importedDate#</li>
		</cfoutput>
	</ul>
	</cfif>
	<cfelse>
	This table does not exist at the moment.
	<cfquery name="getHistory" datasource="accountNumbersNew">
		SELECT * 
		FROM fileImportHistory
		WHERE clientTableID = #tableID.tableID#
		ORDER BY importedDate DESC
	</cfquery>
	<cfif getHistory.RecordCount>
	<ul>
		<cfoutput query="getHistory">
		<li>File #importFileName# was imported #importedDate#</li>
		</cfoutput>
	</ul>
	</cfif>
</cfif>

