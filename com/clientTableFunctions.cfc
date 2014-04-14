<cfcomponent output="false">

<cffunction name="init" access="public" returntype="Any" output="false">
<cfreturn this>
</cffunction>

<cffunction name="getTableList" returntype="any" access="remote" output="false">
<cfargument name="clientID" required="true" />


<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT tableID, tableName
	FROM clientTables
WHERE clientID = <cfqueryparam value="#arguments.clientID#" cfsqltype="cf_sql_integer">
ORDER BY tableID ASC
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>



<cffunction name="tableExists" access="public" returntype="any">
	<cfargument name="tableName" required="true">
<cfdbinfo type="tables" datasource="#Request.mydns#" name="dbtables">

<cfquery name="theTable" dbtype="query">
SELECT *
	FROM dbtables
WHERE TABLE_NAME LIKE <cfqueryparam value="#arguments.tableName#" cfsqltype="cf_sql_varchar">
</cfquery>
		
		<cfset myResult="#theTable#">
		<cfreturn myResult>
	</cffunction>

<cffunction name="getTableListAll" returntype="any" access="remote" output="false">



<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT tableID, tableName
	FROM clientTables
ORDER BY tableID ASC
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableId" returntype="any" access="remote" output="false">
<cfargument name="tableName" required="true" />


<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTables
WHERE tableName LIKE <cfqueryparam value="#arguments.tableName#" cfsqltype="cf_sql_varchar">
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableHeader" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />


<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTables
WHERE tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

	<cffunction name="getTableContent" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />


<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTableFields
WHERE tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
ORDER BY columnPosition ASC
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableContentByColumn" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />
<cfargument name="theColumn" required="true" />


<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTableFields
WHERE tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer"> AND columnName LIKE <cfqueryparam value="#arguments.theColumn#" cfsqltype="cf_sql_varchar">
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableDetailsStandard" returntype="any" access="remote" output="false">
<!---<cfargument name="clientID" required="true" />--->
<cfargument name="tableID" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTableFields
	  WHERE	clientTableFields.tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
ORDER BY clientTableFields.columnPosition ASC
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableDetailsStandardNoInc" returntype="any" access="remote" output="false">
<cfargument name="clientID" required="true" />
<cfargument name="tableID" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT clientTableFields.*, clientTables.tableName 
	FROM clientTableFields
		INNER JOIN clientTables ON (clientTableFields.tableID = clientTables.tableID)
WHERE clientTables.clientID = <cfqueryparam value="#arguments.clientID#" cfsqltype="cf_sql_integer"> AND clientTables.tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer"> AND clientTableFields.autoIncrement = 0
ORDER BY clientTableFields.columnPosition ASC
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableDefinedFields" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />
<cfargument name="columnID" required="true" />
<cfargument name="columnValue" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT columnName
	FROM clientTableFields
WHERE tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer"> AND #arguments.columnID# = <cfqueryparam value="#arguments.columnValue#" cfsqltype="cf_sql_tinyint">
ORDER BY clientTableFields.tableLineID	
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>

<cffunction name="getTableKeys" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT clientTableKeys.tableKeyColumn AS columnName
	FROM clientTableKeys
WHERE clientTableKeys.tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
</cfquery>

		<!---<cfif theFile.RecordCount GT 1>
			<cfreturn #ValueList(theFile.tableKeyColumn)#>
				<cfelseif theFile.RecordCount EQ 1>
			<cfreturn #theFile.tableKeyColumn#>
				<cfelse>
				<cfset theReturn = "" />
			<cfreturn #theReturn#>				
		</cfif>--->
	<cfreturn #theFile#>
</cffunction>

<cffunction name="getTablePrimaryKeys" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT clientTablePrimaryKeys.tableKeyColumn
	FROM clientTablePrimaryKeys
WHERE clientTablePrimaryKeys.tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
</cfquery>


	<cfif theFile.RecordCount GT 1>
			<cfreturn #ValueList(theFile.tableKeyColumn)#>
				<cfelseif theFile.RecordCount EQ 1>
			<cfreturn #theFile.tableKeyColumn#>
				<cfelse>
				<cfset theReturn = "" />
			<cfreturn #theReturn#>				
		</cfif>
</cffunction>
<cffunction name="getTablePrimaryKeysQuery" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTablePrimaryKeys
WHERE clientTablePrimaryKeys.tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
</cfquery>


	
			<cfreturn #theFile#>				
		
</cffunction>
<cffunction name="getTableSQL" returntype="any" access="remote" output="false">
<cfargument name="tableID" required="true" />

<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT *
	FROM clientTablesSQL
WHERE tableID = <cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer">
</cfquery>


	<cfreturn #theFile#>
</cffunction>

<cffunction name="editSQL" access="remote" output="false">
	<cfargument name="sql" required="true" >
	<cfargument name="tableId" required="true"> 
	
	<cfset getSQL = Request.cTableFunctions.getTableSQL(tableID=#arguments.tableID#) />
	
	<cfif getSQL.recordCount GT 0>
		<cfquery datasource="#Request.mydns1#">
		UPDATE clientTablesSQL
		SET sqlScript = <cfqueryparam value="#TRIM(arguments.sql)#" cfsqltype="cf_sql_varchar" >		
				WHERE tableID = <cfqueryparam value="#arguments.tableId#" cfsqltype="cf_sql_integer">
		</cfquery>
				<cfelse>
		<cfquery datasource="#Request.mydns1#">
		INSERT INTO clientTablesSQL (tableID, sqlScript, dateAdded)
			VALUES (
						<cfqueryparam value="#arguments.tableId#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.sql#" cfsqltype="cf_sql_longvarchar">,
						<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">
					)
		</cfquery>			
	</cfif>
	
	
	
</cffunction>

<cffunction name="runSQL" access="remote" output="false" returntype="String" >
	<cfargument name="tableID" required="true"> 
	
	<cfset getSQL = Request.cTableFunctions.getTableSQL(tableID=#arguments.tableID#) />
	
	<cfset MyFile="#request.basePath#clientFiles\loadFile.bat">
	<cfset sqlFile="#request.basePath#clientFiles\sqlFile.sql">
	
<cfsavecontent variable="theSQL"><cfoutput>
#preservesinglequotes(getSQL.sqlScript)#
</cfoutput>
</cfsavecontent>
			<cffile action="write"
             file="#sqlFile#"
             output="#theSQL#"
             addnewline="yes" nameconflict="overwrite">
			  
	<cftry>
	<cfexecute name="C:\WINDOWS\system32\cmd.exe" arguments="/c ""#MyFile#""" outputFile = "#request.basePath#clientFiles\logs\output.txt" timeout="180"></cfexecute> 
			<cfset theReturn = "The Script was executed.">
	<cfcatch>
			<cfif cfcatch.type is "Database">
				
				<cfset theReturn = "#cfcatch.detail#">
			<cfelse>
				<cfrethrow>
			</cfif>
		</cfcatch>
	</cftry>		  
	
	<cfreturn theReturn>
	
</cffunction>

<cffunction name="deleteClientTable" access="remote" output="false" returntype="void" >
	
	<cfargument name="tableID" required="true"> 
	
	<cfquery datasource="#Request.mydns1#">
		DELETE FROM clienttablefields
		WHERE tableID = #arguments.tableID#
		</cfquery>
	<cfquery datasource="#Request.mydns1#">
		DELETE FROM clienttables
		WHERE tableID = #arguments.tableID#
		</cfquery>
</cffunction>

</cfcomponent>