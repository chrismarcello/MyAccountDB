<cfcomponent output="false">

<cffunction name="init" access="public" returntype="Any" output="false">
<cfreturn this>
</cffunction>

	<cffunction name="getAllTables" access="public" returntype="any">
		
<cfdbinfo type="tables" datasource="#Request.mydns1#" name="dbtables">
		
		<cfset myResult="#dbtables#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="findTables" access="public" returntype="any">
	<cfargument name="tableName" required="true">
<cfdbinfo type="tables" datasource="efi" name="dbtables">

<cfquery name="theTable" dbtype="query">
SELECT *
	FROM dbtables
WHERE TABLE_NAME LIKE <cfqueryparam value="#arguments.tableName#" cfsqltype="cf_sql_varchar">
</cfquery>
		
		<cfset myResult="#theTable#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getTableColumns" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		
<cfdbinfo type="columns" datasource="#Request.mydns1#" name="dbtables" table="#arguments.tableName#">
		
		<cfset myResult="#dbtables#">
		<cfreturn myResult>
	</cffunction>
	
	<cffunction name="getThisTableColumn" access="public" returntype="any">
		<cfargument name="tableName" required="true">
		<cfargument name="columnName" required="true">
		
		<cfset var dbtables = "" />
		<cfset var theTable = "" />
		
<cfdbinfo type="columns" datasource="#Request.mydns1#" name="dbtables" table="#arguments.tableName#">

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

<cffunction name="getDBCountLocal" access="remote" returnType="any" output="false">
	<cfargument name="dbName" required="true">
	
	<cfset var thisQuery = "" />
	
	<cfquery name="thisQuery" datasource="#Request.mydns1#">
	SELECT COUNT(*) AS theNumber
	FROM #arguments.dbName#
	</cfquery>

		<cfset myResult="#thisQuery#">
		<cfreturn myResult>

</cffunction>

<cffunction name="getTableRecordCount" access="public" returntype="any" output="false">
		<cfargument name="theTable" required="yes">
		
		
		<cfset var getMetEd="" />
		
	<cfset QuoteMark = Chr(34)>
		
<cfquery name="getMetEd" datasource="#Request.mydns1#">
SELECT COUNT(*) AS theNumber
FROM #arguments.theTable#
</cfquery>

		
		<cfset myResult="#getMetEd.theNumber#">
		<cfreturn myResult>
	</cffunction>
	
	<!--- End Table Counts and Record Counts --->
	
	<cffunction name="getLoadFileType" returntype="any" access="remote" output="false">


<cfset var theFile = "" />

<cfquery name="theFile" datasource="#Request.mydns1#">
SELECT fileTypes.fileTypeID, fileTypes.typeDescription
	FROM fileTypes
ORDER BY fileTypeID
</cfquery>

	<cfset foo = #theFile#>
	<cfreturn foo>
</cffunction>



<cffunction name="copyGroupTable" returntype="void" access="remote" output="false">
<cfargument name="groupID" required="true" />
<cfargument name="tableToCopy" required="true" />
<cfargument name="fileName" required="true" />
<cfargument name="newTableName" required="true" />
<cfargument name="finalTableName" required="true" />



<cfset fileContent = Request.cTableFunctions.getTableContent(tableID=#arguments.tableToCopy#) />
<cfset tableInfo = Request.cTableFunctions.getTableHeader(tableID=#arguments.tableToCopy#) />

<cfquery datasource="#Request.mydns1#" result="theFile">
		INSERT INTO oscTables (groupID, fileName, newTableName, finalTableName)
			VALUES (
						<cfqueryparam value="#arguments.clientID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.fileName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.newTableName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.finalTableName#" cfsqltype="cf_sql_varchar">
					)
		</cfquery>
		
	

	<cfloop query="fileContent">
	 <cfquery datasource="#Request.mydns1#">
   INSERT INTO oscTableFields (tableID, columnPosition, columnName, columnType, columnLength, columnNull, columnKeyType)
   		VALUES (
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#fileContent.CurrentRow#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#fileContent.columnName#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#fileContent.columnType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#fileContent.columnLength#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#fileContent.columnNull#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#fileContent.columnKeyType#" cfsqltype="cf_sql_varchar">
					
					
				)
   </cfquery>
	</cfloop>
		
		
</cffunction>


<cffunction name="setNewGroup" returntype="void" access="remote" output="false">
<cfargument name="groupName" required="true" />
<cfargument name="groupDirectory" required="true" />
<cfargument name="fileName" required="true" />
<cfargument name="createTableName" required="true" />
<cfargument name="changeTableName" required="no" />
<cfargument name="normalizeColumn" required="no" />
<cfargument name="addClientNo" required="yes" default="1" />
<cfargument name="addOsC" required="yes" default="1" />




<cfquery datasource="#Request.mydns1#" result="theFile">
		INSERT INTO clientgroups (groupName, groupDirectory, fileName, createTableName, changeTableName, normalizeColumn, addClientNo, oscAdd, dateCreated)
			VALUES (
						
						<cfqueryparam value="#arguments.groupName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.groupDirectory#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.fileName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.createTableName#" cfsqltype="cf_sql_varchar">,
					<cfif IsDefined("arguments.changeTableName") AND #arguments.changeTableName# NEQ ''>
						<cfqueryparam value="#arguments.changeTableName#" cfsqltype="cf_sql_varchar">
							<cfelse>
						''	
					</cfif>,
					<cfif IsDefined("arguments.normalizeColumn") AND #arguments.normalizeColumn# NEQ ''>
						<cfqueryparam value="#arguments.normalizeColumn#" cfsqltype="cf_sql_smallint">
							<cfelse>
						<cfqueryparam value="0" cfsqltype="cf_sql_char">	
					</cfif>,
					
						<cfqueryparam value="#arguments.addClientNo#" cfsqltype="cf_sql_smallint">
							,
					
						<cfqueryparam value="#arguments.addOsC#" cfsqltype="cf_sql_smallint">
							,
						<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">
					)
		</cfquery>
		
		<cfloop index="s" list="#session.theTableList#">
		
	<cfset tableInfo = Request.cTableFunctions.getTableId(tableName=#s#) />
	 <cfquery datasource="#Request.mydns1#">
   INSERT INTO clientgroupmembers (groupID, clientID, tableID)
   		VALUES (
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#tableInfo.clientID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#tableInfo.tableID#" cfsqltype="cf_sql_integer">
					
				)
   </cfquery>
  
   
 
	</cfloop>
		
   	<cfset fileDestination = "#request.basePath#Files\#arguments.groupDirectory#" />


<cfif DirectoryExists(#fileDestination#)>
	<cfelse>
			<cfdirectory action="create" directory="#fileDestination#" mode="777">
			<cfdirectory action="create" directory="#fileDestination#\archivedFiles" mode="777">
			
</cfif>	
</cffunction>

<cffunction name="executeSQL" returntype="void" access="remote" output="false">
	<cfargument name="theFile" required="yes">
	
	<cffile action="read" file="#arguments.theFile#" variable="sql">
		<cfset parts = listToArray(sql, "-")>
	
	<cfloop index="x" from="1" to="#arrayLen(parts)#">
		<cfset sql = trim(parts[x])>
		<cfif len(sql)>
			
			<cfquery datasource="#Request.mydns1#">
			#preserveSingleQuotes(sql)#
			</cfquery>
			
		</cfif>
	</cfloop>


<!--- Delete load script file. --->
<!---<cfif FileExists(arguments.theFile)>
        <cffile action="delete" file="#arguments.theFile#" mode="777">
</cfif>	--->	
</cffunction>

<cffunction name="deleteDupEntries" access="remote" returntype="void" output="false">
		
		<cfargument name="tableID" required="yes">
		
		
		<cfset var getMetEd="" />
		
		<cfset getMainKey = Request.cTableFunctions.getTableHeader(tableID=#arguments.tableID#) />
		
		<cfquery name="getMetEd" datasource="#Request.mydns1#">
		DELETE bad_rows.*
		FROM #getMainKey.tableName# AS bad_rows
   			INNER JOIN (
      SELECT AccountNumber, MIN(id) AS min_id
      FROM #getMainKey.tableName#
      GROUP BY AccountNumber
      HAVING COUNT(*) > 1
   ) AS good_rows ON good_rows.AccountNumber = bad_rows.AccountNumber
      AND good_rows.min_id <> bad_rows.id;
		</cfquery>	
		
	</cffunction>
	
	
	
<cffunction name="dropOldTable" returntype="void" access="remote">
	<cfargument name="theTable" required="yes">
	
	<cfsavecontent variable="dropSQL"><cfoutput>
	DROP TABLE IF EXISTS `#arguments.theTable#`;
	</cfoutput>
	</cfsavecontent>
	
			<cfquery datasource="#Request.mydns1#">
			#preserveSingleQuotes(dropSQL)#
			</cfquery>
</cffunction>


	
</cfcomponent>