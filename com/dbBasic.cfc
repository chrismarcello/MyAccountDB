<cfcomponent>
<cffunction name="init" access="public" returntype="Any" output="false">
<cfreturn this>
</cffunction>

	<cffunction name="getAllTables" access="public" returntype="any">
		
<cfdbinfo type="tables" datasource="#Request.mydns#" name="dbtables">
		
		<cfset myResult="#dbtables#">
		<cfreturn myResult>
	</cffunction>
	
<cffunction name="findTables" access="public" returntype="any">
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
	
	<cffunction name="getTableIndexes" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		
<cfdbinfo type="Index" datasource="#Request.mydns#" name="dbtables" table="#arguments.tableName#">
		
		<cfset myResult="#dbtables#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getTablePrimaryKey" access="public" returntype="string">
		<cfargument name="tableName" required="true">
		
<cfdbinfo type="Index" datasource="#Request.mydns#" name="dbtables" table="#arguments.tableName#">

<cfquery name="theTable" dbtype="query">
SELECT COLUMN_NAME
	FROM dbtables
WHERE INDEX_NAME = <cfqueryparam value="PRIMARY" cfsqltype="cf_sql_varchar" >
</cfquery>
		
		<cfset myResult="#theTable.COLUMN_NAME#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getTableFKeys" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		
<cfdbinfo type="Foreignkeys" datasource="#Request.mydns#" name="dbtables" table="#arguments.tableName#">
		
		<cfset myResult="#dbtables#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getTableColumns" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		
<cfdbinfo type="columns" datasource="#Request.mydns#" name="dbtables" table="#arguments.tableName#">
		
		<cfset myResult="#dbtables#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getTableColumnNames" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		
<cfdbinfo type="columns" datasource="#Request.mydns#" name="dbtables" table="#arguments.tableName#">

	<cfquery name="columns" dbtype="query" >
	SELECT COLUMN_NAME
	FROM dbtables
	ORDER BY ORDINAL_POSITION
	</cfquery>
		
		<cfset myResult="#columns#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getThisTableColumn" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		<cfargument name="columnName" required="true">
		
		<cfset var dbtables = "" />
		<cfset var theTable = "" />
		
<cfdbinfo type="columns" datasource="#Request.mydns#" name="dbtables" table="#arguments.tableName#">

<cfquery name="theTable" dbtype="query">
SELECT *
	FROM dbtables
WHERE COLUMN_NAME LIKE <cfqueryparam value="#arguments.columnName#">
</cfquery>
		
		<cfset myResult = #theTable#>
		<cfreturn myResult>
	</cffunction>
	
	<!--- Table Counts and Record Counts --->
	
<cffunction name="getDBCount" access="remote" returnType="any" output="false">
	<cfargument name="dbName" required="true">
	
	<cfset var thisQuery = "" />
	
	<cfquery name="thisQuery" datasource="#Request.mydns#">
	SELECT COUNT(*) AS theNumber
	FROM #arguments.dbName#
	</cfquery>

		<cfset myResult="#thisQuery#">
		<cfreturn myResult>

</cffunction>


<cffunction name="getTableData" access="remote" returnType="any" output="false">
	<cfargument name="tableName" required="true">
	
	<cfset var thisQuery = "" />
	
	<cfset getPrimary = Request.dbBasic.getTablePrimaryKey(tableName=#arguments.tableName#) />
	
	<cfquery name="thisQuery" datasource="#Request.mydns#" maxrows="200">
	SELECT *
	FROM #arguments.tableName#
	<cfif IsDefined("getPrimary") AND #getPrimary# NEQ ''>
	ORDER BY #getPrimary# ASC
	</cfif>
	</cfquery>

		<cfset myResult="#thisQuery#">
		<cfreturn myResult>

</cffunction>

<cffunction name="dropTable" returntype="void" access="remote">
	<cfargument name="theTable" required="yes">
	
	<cfsavecontent variable="dropSQL"><cfoutput>
	DROP TABLE IF EXISTS `#arguments.theTable#`;
	</cfoutput>
	</cfsavecontent>
	
			<cfquery datasource="#Request.mydns#">
			#preserveSingleQuotes(dropSQL)#
			</cfquery>
</cffunction>

<cffunction name="emptyTable" returntype="void" access="remote">
	<cfargument name="theTable" required="yes">
	
	
			<cfquery datasource="#Request.mydns#">
			TRUNCATE #arguments.theTable#
			</cfquery>
</cffunction>

<!--- File Functions --->
	
	<cffunction name="getDelimiters" access="public" returntype="query">
		<cfargument name="delimID" required="false" default="" > 
		
		<cfset var theTypes = ""/>
		
		<cfquery name="theTypes" datasource="#Request.mydns#">
		SELECT *
		FROM fileDelimiters
			<cfif arguments.delimID NEQ ''>
			WHERE fileDelimID = <cfqueryparam value="#arguments.delimID#" cfsqltype="cf_sql_integer" > 
			</cfif>
		</cfquery> 
			
		
		<cfreturn #theTypes#>
	</cffunction>

</cfcomponent>