<cfset getTableList = Request.cTableFunctions.getTableListAll() />

<p>
	<form action="" name="copyTableForm" id="copyTableForm">
	<fieldset>
			<label for="tableName">Table Name</label> <input type="text" name="tableName" id="tableName"><br>
			<select name="tableToCopy" id="tableToCopy" class="center">
				<option value="">Select table to copy</option>
			<cfloop query="getTableList">
				<cfoutput><option value="#getTableList.tableID#">#getTableList.tableName#</option></cfoutput>
			</cfloop>	
			</select>
			
	</fieldset>
	<cfoutput><input type="hidden" name="clientID" id="clientID" value="#session.clientID#"></cfoutput>
		</form>
</p>	