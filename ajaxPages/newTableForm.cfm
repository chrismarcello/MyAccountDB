<script type="application/javascript">
	$(document).ready(function(){
$('#fieldNumber').bind("change keyup", getTableForm);
});  
function getTableForm(){
var tableForm = $("#tableForm");		
var fieldNumber = $("select#fieldNumber").val();

		
	
	//First, do a statuc message
        tableForm.html('<div align="center"><img src="../../common/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');



	   $( "#tableForm" ).load( "ajaxPages/columnForm.cfm", { fieldNumber: fieldNumber } );
					

}
</script>
<p>
	<form action="" name="newTableForm" id="newTableForm">
	<fieldset>
			<label for="tableName">Table Name</label> <input type="text" name="tableName" id="tableName"><br>
			<select name="fieldNumber" id="fieldNumber" class="center">
				<option value="">Select Number of Columns</option>
			<cfloop index="i" from="1" to="50">
				<cfoutput><option value="#i#">#i#</option></cfoutput>
			</cfloop>	
			</select>
			<div id="tableForm"></div>
	</fieldset>
	<cfoutput><input type="hidden" name="clientID" id="clientID" value="#session.clientID#"></cfoutput>
		</form>
</p>	