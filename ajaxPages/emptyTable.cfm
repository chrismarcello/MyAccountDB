<cfoutput>
	<img src="assets/icons/large/exclamation.png" alt="Error!" title="Attention!" border="0"> Are you sure you want to empty table: #tableName#?
	
	<form name="emptyTheTableForm" id="emptyTheTableForm">
		<input type="hidden" name="theTable" id="theTable" value="#tableName#">
	</form>
</cfoutput>