<cfset tableSQL = Request.cTableFunctions.getTableSQL(tableID="#session.tableID#") />

<cfif tableSQL.RecordCount GT 0>
			<cfoutput>#tableSQL.sqlScript#</cfoutput>
		</cfif>
<form id="runSQLFORM" name="runSQLFORM">
	<cfoutput><input type="hidden" name="tableID" id="tableID" value="#session.tableID#"></cfoutput>
</form>		