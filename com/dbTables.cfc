<cfcomponent>
	<cffunction name="init" access="public" returntype="Any" output="false">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="getTableRecordCount" access="remote" returnType="any" output="false">
	<cfargument name="tableName" required="true">
	
	<cfset var thisQuery = "" />
	
	<cfquery name="thisQuery" datasource="#Request.mydns#">
	SELECT COUNT(*) AS theNumber
	FROM #arguments.tableName#
	</cfquery>

		<cfset myResult="#thisQuery.theNumber#">
		<cfreturn myResult>

</cffunction>
	<cffunction name="getTableColumns" access="remote" output="false" returntype="Any" >
		<cfargument name="tableName" required="true">
	
	
	<cfset var makeQuery = "" />
	


	
	<cfquery name="makeQuery" datasource="#Request.mydns1#">
	SELECT clienttablefields.*
	FROM clienttablefields
	INNER JOIN clienttables ON (clienttablefields.tableID = clienttables.tableID)
	WHERE clienttables.tableName = '#arguments.tableName#' AND clienttablefields.displayColumn = 1
	ORDER BY clienttablefields.columnPosition ASC
	</cfquery>
	
	<cfreturn makeQuery>
	
	</cffunction>
	
	<cffunction name="getTableColumnList" access="remote" output="false" returntype="Any" >
		<cfargument name="tableName" required="true">
	
	
	<cfset var makeQuery = "" />
	


	
	<cfquery name="makeQuery" datasource="#Request.mydns1#">
	SELECT clienttablefields.*
	FROM clienttablefields
	INNER JOIN clienttables ON (clienttablefields.tableID = clienttables.tableID)
	WHERE clienttables.tableName = '#arguments.tableName#' AND clienttablefields.displayColumn = 1
	ORDER BY clienttablefields.columnPosition ASC
	</cfquery>
	
		<cfset columnList = #ValueList(makeQuery.columnName)# />
	
	<cfreturn columnList>
	
	</cffunction>
	

<cffunction name="tableSearch" access="remote" output="false" returntype="Any" >
	<cfargument name="tableName" required="true" >
	<cfargument name="searchTerm" required="true" > 
	
	<cfset var makeQuery = "" />
	
<cfset tableID = Request.cTableFunctions.getTableID(tableName="#arguments.tableName#") />	
<cfset fileContent = Request.cTableFunctions.getTableContent(tableID=#tableID.tableID#) />

<cfset tableColumns = ArrayNew(1) />
	<cfloop query="fileContent">
	<cfset temp = ArrayAppend(tableColumns, "#fileContent.columnName#") />
</cfloop>
	<cfset theRow = 0 />
	
	<cfquery name="makeQuery" datasource="#Request.mydns#">
	SELECT *
	FROM #arguments.tableName#
	 
		<cfif arguments.searchTerm NEQ ''>
		WHERE 
					(0=0
				<cfloop list="#arguments.searchTerm#" index="word" delimiters=",">
				  <!---AND (id LIKE '%#word#%') --->
				  	<cfloop array="#tableColumns#" index="i">
					  	<cfset theRow = #theRow# + 1 />
						<cfif theRow EQ 1>
					AND (#i# LIKE '%#word#%')
							<cfelse>
						OR (#i# LIKE '%#word#%')				
						</cfif>  
					
					</cfloop>
				</cfloop>	)
		</cfif>
		
	
	</cfquery> 
		<cfreturn makeQuery>
</cffunction>
<cffunction name="recordImportFileHistory" returntype="void" access="remote">
	<cfargument name="tableID" required="true" />	
	<cfargument name="dataFile" required="true" />
	
	<cfquery datasource="accountNumbersNew">
		INSERT INTO fileImportHistory (clientTableID, importFileName, importedDate)
			VALUES (
						<cfqueryparam value="#arguments.tableID#" cfsqltype="cf_sql_integer" >,
						<cfqueryparam value="#arguments.dataFile#" cfsqltype="cf_sql_varchar" >,
						<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp" >
					)
	</cfquery>
	
</cffunction>

<cffunction name="importFile" returntype="string" returnformat="plain" access="remote">
<cfargument name="clientID" required="true" />
<cfargument name="tableID" required="true" />	
<cfargument name="dataFile" required="true" />
<cfargument name="addMake" required="false" default="Yes" />
<cfargument name="delimiter" required="true" >
<cfargument name="surroundData" required="false" default="" >
<cfargument name="header" required="false" default=""> 
<cfargument name="theStartRow" required="false" default="0">
<cfargument name="deleteFile" required="false" default="">
<cfargument name="archiveFile" required="false" default="">
<cfargument name="linesTerm" required="true"> 


<cfset theFileDetails = Request.cTableFunctions.getTableDetailsStandardNoInc(clientID=#arguments.clientID#, tableID=#arguments.tableID#) />

<!--- If we have to build a table, do it here first. --->
<cfif arguments.addMake NEQ '' AND arguments.addMake EQ 'Yes'>
	<cfset buildTable = Request.dbTables.createTable(clientID=#arguments.clientID#, tableID=#arguments.tableID#) />
	<cfset sleep(10000) />	 
<cfelseif arguments.addMake EQ 'Tun'>
	<cfset emptyTable = Request.dbBasic.emptyTable(theTable="#theFileDetails.tableName#") />
</cfif>



			<cfset MyFile="#request.basePath#clientFiles\loadFile.bat">
			<cfset sqlFile="#request.basePath#clientFiles\sqlFile.sql">
			<cfset loadThis = "'#request.webBasePath#clientFiles/imports/#arguments.dataFile#'" />
			
			<cfif arguments.theStartRow GT 0>
				<cfset startRow = #arguments.theStartRow# - 1 />
					<cfelse>
				<cfset startRow = 0 />		
			</cfif>
			
			<cfif arguments.header EQ 'useHeader'>
				<cfset startingRow = 1 + #startRow# />
					<cfelse>
				<cfset startingRow = #startRow# />		
			</cfif>
			
			
	<cfswitch expression="#arguments.delimiter#">  
 <cfcase value="1">  
  <cfset theDelimiter = "," />  
    </cfcase>  
 <cfcase value="5">  
  <cfset theDelimiter = ";" />  
    </cfcase>  
 <cfcase value="2">  
  <cfset theDelimiter = "|" />  
    </cfcase>
    <cfcase value="3">  
  <cfset theDelimiter = "~" />  
    </cfcase> 
 <cfcase value="4">  
  <cfset theDelimiter = "-" /> 
    </cfcase>  
    <cfdefaultcase>  
    
  <cfset theDelimiter = "," /> 
       
    </cfdefaultcase>  
</cfswitch> 
<cfswitch expression="#arguments.linesTerm#">  
 <cfcase value="1">  
  <cfset theTerminator = "\r\n" />  
    </cfcase>  
 <cfcase value="2">  
  <cfset theTerminator = "\n" />  
    </cfcase>  
 
    <cfdefaultcase>  
    
  <cfset theTerminator = "\r\n" /> 
       
    </cfdefaultcase>  
</cfswitch>  		 		
			
<cfsavecontent variable="theSQL"><cfoutput>
LOAD DATA LOCAL INFILE #loadThis# INTO TABLE #theFileDetails.tableName# 
FIELDS TERMINATED BY '#theDelimiter#' <cfif #arguments.surroundData# NEQ '' AND #arguments.surroundData# EQ 'surround1'>ENCLOSED BY '"'</cfif>
LINES TERMINATED BY '#theTerminator#' 
<cfif startingRow GT 0>IGNORE #startingRow# LINES</cfif> 
(#ValueList(theFileDetails.columnName,",")#);
</cfoutput>
</cfsavecontent>

	

<!--- Write the load file. --->	
<cffile action="write"
             file="#sqlFile#"
             output="#theSQL#"
             addnewline="yes" nameconflict="overwrite">
			  
			  
<!--- Execute batch file to import data. --->
             
        <cfexecute name="C:\WINDOWS\system32\cmd.exe" arguments="/c ""#MyFile#""" timeout="360"></cfexecute>    
					  
<cfset doRecord = Request.dbTables.recordImportFileHistory(tableID=#arguments.tableID#, dataFile="#arguments.dataFile#") />

<!--- Save to archived folder after zipping --->
<cfif arguments.archiveFile EQ 'archive'>	
	<!---<cfset doZip = Request.files.createArchive(fileName="#arguments.dataFile#") />--->
	<cfset doArchive = Request.dbTables.createArchive(fileName="#arguments.dataFile#", deleteFile="#arguments.deleteFile#") />	
</cfif>	
		<!--- Clean out import folder --->
<!---<cfif arguments.deleteFile EQ 'delete'>
	<cfset doDelete = Request.files.deleteSourceFile(fileName="#arguments.dataFile#") />	
</cfif>--->	
	

	
	
	
	<cfset theAnswer = "The Database has been loaded with file: #arguments.deleteFile#" />
	<cfreturn theAnswer>
	
</cffunction>

<cffunction name="createTable" returntype="void" access="remote">
	
<cfargument name="clientID" required="true" />
<cfargument name="tableID" required="true" />	



<cfset theClientDetails = Request.clients.getTheClient(clientID=#arguments.clientID#) />
<cfset theFileDetails = Request.cTableFunctions.getTableDetailsStandard(tableID=#arguments.tableID#) />
<cfset theTableName = Request.cTableFunctions.getTableHeader(tableID=#arguments.tableID#) />
<cfset theFileKeys = Request.cTableFunctions.getTableKeys(tableID=#arguments.tableID#) />
<cfset theFilePrimaryKeys = Request.cTableFunctions.getTablePrimaryKeys(tableID=#arguments.tableID#) />		


			<cfset MyFile="#request.basePath#clientFiles\loadFile.bat">
			<cfset sqlFile="#request.basePath#clientFiles\sqlFile.sql">






	
	<!--- Write the table create script. --->

<cfsavecontent variable="theSQL"><cfoutput>
DROP TABLE IF EXISTS `#theTableName.tableName#`; 

CREATE TABLE IF NOT EXISTS `#theTableName.tableName#` (<cfloop query="theFileDetails">
  `#theFileDetails.columnName#` #theFileDetails.columnType#<cfif #theFileDetails.columnType# NEQ 'text'>
  (#theFileDetails.columnLength#)</cfif> #theFileDetails.columnNull# <cfif theFileDetails.autoIncrement EQ 1>AUTO_INCREMENT</cfif>, 
  </cfloop>
  <cfif ListLen(theFilePrimaryKeys) GT 0 AND #theFilePrimaryKeys# NEQ ''>PRIMARY KEY (#theFilePrimaryKeys#),</cfif><!---<cfif theFileKeys.RecordCount GT 0>,</cfif>--->
  <cfloop query="theFileKeys"><cfset theKeyCount = theFileKeys.RecordCount />
  <cfif theFileKeys.CurrentRow LT #theKeyCount#> 
  KEY `#theFileKeys.columnName#` (`#theFileKeys.columnName#`),
  <cfelse>KEY `#theFileKeys.columnName#` (`#theFileKeys.columnName#`)
  </cfif>
  </cfloop>
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
</cfoutput>
</cfsavecontent>

	


<!--- Write the load file. --->	
<cffile action="write"
             file="#sqlFile#"
             output="#theSQL#"
             addnewline="yes" nameconflict="overwrite">
			  


	<cfexecute name="C:\WINDOWS\system32\cmd.exe" arguments="/c ""#MyFile#""" timeout="30"></cfexecute>
	
</cffunction>
<cffunction name="defineTable" returntype="void" access="remote">
	<cfargument name="clientID" required="true">
	<cfargument name="tableName" required="true">
	<cfargument name="fieldNumber" required="true">
	<cfargument name="columnname" required="true">
	<cfargument name="columntype" required="true">
	<cfargument name="columnlength" required="true">
	<cfargument name="columnnull" required="true">
	<cfargument name="columnkeytype" required="true">
	<cfargument name="tableprimary" required="true">


<cfquery datasource="#Request.mydns1#" result="theFile">
		INSERT INTO clientTables (clientID, tableName)
			VALUES (
						<cfqueryparam value="#arguments.clientID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.tableName#" cfsqltype="cf_sql_varchar">
						
					)
		</cfquery>


<cfset columnNameList = #columnname# />
<cfset columnTypeList = #columntype# />
<cfset columnLengthList = #columnlength# />
<cfset columnNullList = #columnnull# />
<cfset columnKeyList = #columnkeytype# />
<cfset columnPrimList = #tableprimary# />
		
<cfloop index="i" from="1" to="#arguments.fieldNumber#">
	<cfset myName = #listGetAt(columnNameList, i)# />
	<cfset myType = #listGetAt(columnTypeList, i)# />
	<cfset myLength = #listGetAt(columnLengthList, i)# />
	<cfset myNull = #listGetAt(columnNullList, i)# />
	<cfset myKeys = #listGetAt(columnKeyList, i)# />
	<cfset myPrimary = #listGetAt(columnPrimList, i)# />
	


	
	
	<cfquery datasource="#Request.mydns1#">
   INSERT INTO clientTableFields (tableID, columnPosition, columnName, columnType, columnLength, columnNull, autoIncrement)
   		VALUES (
   					
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#i#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#myName#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#myType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#myLength#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#myNull#" cfsqltype="cf_sql_varchar">,
					<cfif IsDefined("myPrimary") AND #myPrimary# EQ '2'>
						<cfqueryparam value="1" cfsqltype="cf_sql_tinyint">
							<cfelse>
						<cfqueryparam value="0" cfsqltype="cf_sql_tinyint">		
					</cfif>
					
				)
   </cfquery>
   
   <!--- Add Indexes if any --->
   	<cfif IsDefined("myKeys") AND #myKeys# NEQ '0'>
   	<cfquery datasource="#Request.mydns1#">
   INSERT INTO clientTableKeys (tableID, tableKeyColumn)
   		VALUES (
   					
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#myName#" cfsqltype="cf_sql_varchar">
					
				)
   </cfquery>
   	</cfif>
   <!--- Add Primary Indexes if any --->
   	<cfif IsDefined("myPrimary") AND #myPrimary# NEQ '0'>
	   	
   	<cfquery datasource="#Request.mydns1#">
   INSERT INTO clientTablePrimaryKeys (tableID, tableKeyColumn, autoIncrement)
   		VALUES (
   					
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					
					<cfqueryparam value="#myName#" cfsqltype="cf_sql_varchar">,
					<cfif IsDefined("myPrimary") AND #myPrimary# EQ '2'>
						<cfqueryparam value="1" cfsqltype="cf_sql_tinyint">
							<cfelse>
						<cfqueryparam value="0" cfsqltype="cf_sql_tinyint">		
					</cfif>
				)
   </cfquery>
   
   	</cfif>
	
</cfloop>
	
</cffunction>

<cffunction name="copyTable" returntype="void" access="remote" output="false">
<cfargument name="clientID" required="true" />
<cfargument name="tableToCopy" required="true" />
<cfargument name="tableName" required="true" />



<cfset fileContent = Request.cTableFunctions.getTableContent(tableID=#arguments.tableToCopy#) />
<cfset tableInfo = Request.cTableFunctions.getTableHeader(tableID=#arguments.tableToCopy#) />

<cfset theFileKeys = Request.cTableFunctions.getTableKeys(tableID=#arguments.tableToCopy#) />
<cfset theFilePrimaryKeys = Request.cTableFunctions.getTablePrimaryKeysQuery(tableID=#arguments.tableToCopy#) />

<cfquery datasource="#Request.mydns1#" result="theFile">
		INSERT INTO clientTables (clientID, tableName)
			VALUES (
						<cfqueryparam value="#arguments.clientID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#arguments.tableName#" cfsqltype="cf_sql_varchar">
						
					)
		</cfquery>
		
	

	<cfloop query="fileContent">
	 <cfquery datasource="#Request.mydns1#">
   INSERT INTO clientTableFields (tableID, columnPosition, columnName, columnType, columnLength, columnNull, autoIncrement)
   		VALUES (
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#fileContent.columnPosition#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#fileContent.columnName#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#fileContent.columnType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#fileContent.columnLength#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#fileContent.columnNull#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#fileContent.autoIncrement#" cfsqltype="cf_sql_tinyint">
					
				)
   </cfquery>
	</cfloop>
		
		
		 <!--- Add Indexes if any --->
  <cfif theFileKeys.RecordCount GT 0>
  	 	<cfloop query="theFileKeys">  	
   	<cfquery datasource="#Request.mydns1#">
   INSERT INTO clientTableKeys (tableID, tableKeyColumn)
   		VALUES (
   					
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#theFileKeys.columnName#" cfsqltype="cf_sql_varchar">
					
				)
   </cfquery>
   		</cfloop>
   	</cfif>
   <!--- Add Primary Indexes if any --->
   	<cfif theFilePrimaryKeys.RecordCount GT 0>
  	 	<cfloop query="theFilePrimaryKeys">
	   	
   	<cfquery datasource="#Request.mydns1#">
   INSERT INTO clientTablePrimaryKeys (tableID, tableKeyColumn, autoIncrement)
   		VALUES (
   					
					<cfqueryparam value="#theFile.GENERATED_KEY#" cfsqltype="cf_sql_integer">,
					
					<cfqueryparam value="#theFilePrimaryKeys.tableKeyColumn#" cfsqltype="cf_sql_varchar">,
					
						<cfqueryparam value="#theFilePrimaryKeys.autoIncrement#" cfsqltype="cf_sql_tinyint">		
					
				)
   </cfquery>
		   </cfloop>
   	</cfif>
		
</cffunction>
<cffunction name="exportTable" returntype="string" returnformat="plain" access="remote">
<cfargument name="clientID" required="true" />
<cfargument name="tableID" required="true" />	
<cfargument name="fileName" required="true" />
<cfargument name="fileType" required="true" />
<cfargument name="delimiter" required="true" >
<cfargument name="surroundData" required="false" default="" >
<cfargument name="addTimeStamp" required="false" default=""> 
<cfargument name="header" required="false" default=""> 
<cfargument name="linesTerm" required="true"> 


<cfset theFileDetails = Request.cTableFunctions.getTableDetailsStandardNoInc(clientID=#arguments.clientID#, tableID=#arguments.tableID#) />





			<cfset MyFile="#request.basePath#clientFiles\loadFile.bat">
			<cfset sqlFile="#request.basePath#clientFiles\sqlFile.sql">
			
			<cfif arguments.addTimeStamp NEQ ''><
				<cfset exportFile = "#arguments.fileName#-#DateTimeFormat(NOW(), "yyyyMMddHHnnsstt")#.#arguments.fileType#" />
					<cfelse>
				<cfset exportFile = "#arguments.fileName#.#arguments.fileType#" />		
			</cfif>
			
			
			<cfset exportThis = "'#request.webBasePath#clientFiles/exports/#exportFile#'" />
			
<cfset selectStatement = "#ValueList(theFileDetails.columnName)#"/>		
<cfset exportHeader = "#QuotedValueList(theFileDetails.columnName)#"/>	
<cfset exportHeader = #ReReplace(exportHeader, "[""]", "'", "all" )# />	
			
			
	<cfswitch expression="#arguments.delimiter#">  
 <cfcase value="1">  
  <cfset theDelimiter = "," />  
    </cfcase>  
 <cfcase value="5">  
  <cfset theDelimiter = ";" />  
    </cfcase>  
 <cfcase value="2">  
  <cfset theDelimiter = "|" />  
    </cfcase>
    <cfcase value="3">  
  <cfset theDelimiter = "~" />  
    </cfcase> 
 <cfcase value="4">  
  <cfset theDelimiter = "-" /> 
    </cfcase>  
    <cfdefaultcase>  
    
  <cfset theDelimiter = "," /> 
       
    </cfdefaultcase>  
</cfswitch> 
<cfswitch expression="#arguments.linesTerm#">  
 <cfcase value="1">  
  <cfset theTerminator = "\r\n" />  
    </cfcase>  
 <cfcase value="2">  
  <cfset theTerminator = "\n" />  
    </cfcase>  
 
    <cfdefaultcase>  
    
  <cfset theTerminator = "\r\n" /> 
       
    </cfdefaultcase>  
</cfswitch>  		 		
			
			<cfif arguments.header EQ ''>
<cfsavecontent variable="theSQL"><cfoutput>
SELECT #selectStatement#
FROM #theFileDetails.tableName#	
INTO OUTFILE "#request.webBasePath#clientFiles/exports/#exportFile#" 
FIELDS TERMINATED BY '#theDelimiter#' <cfif #arguments.surroundData# NEQ '' AND #arguments.surroundData# EQ 'surround1'>ENCLOSED BY '"'</cfif> 
LINES TERMINATED BY '#theTerminator#' 
	</cfoutput>
</cfsavecontent>	
				<cfelse>
<cfsavecontent variable="theSQL"><cfoutput>
SELECT #exportHeader# 
UNION ALL 	
 SELECT #selectStatement# 
FROM #theFileDetails.tableName#	
INTO OUTFILE "#request.webBasePath#clientFiles/exports/#exportFile#" 
FIELDS TERMINATED BY '#theDelimiter#' <cfif #arguments.surroundData# NEQ '' AND #arguments.surroundData# EQ 'surround1'>ENCLOSED BY '"'</cfif> 
LINES TERMINATED BY '#theTerminator#' 
	</cfoutput>
</cfsavecontent>							
			</cfif>
			

	

<!--- Write the load file. --->	
<cffile action="write"
             file="#sqlFile#"
             output="#theSQL#"
             addnewline="yes" nameconflict="overwrite">
			  
			  
<!--- Execute batch file to import data. --->
             
        <cfexecute name="C:\WINDOWS\system32\cmd.exe" arguments="/c ""#MyFile#""" timeout="1800"></cfexecute>    
					  
<!--- Delete any zip folder older than 5 days. --->
	
<cfdirectory directory="#request.basePath#clientFiles\exports\" name="dirQuery" action="LIST">


	<!--- Set the number of days you want to keep the archive for. --->
<cfset daysOld = 5 />

	<cfset deleteDate = DateAdd("d", -#daysOld#, #NOW()#) />
	
	<cfloop query="dirQuery">
			<CFSET Age=DateDiff("d",dirQuery.DateLastModified,Now())>
				<cfif Age GT daysOld>
					<cffile action="delete" file="#request.basePath#clientFiles\exports\#dirQuery.name#">
				</cfif>
	</cfloop>


	

	
	
	
	<cfset theAnswer = "Your file has been exported." />
	<cfreturn theAnswer>
	
</cffunction>
<cffunction name="createArchive" access="remote" returntype="void">
		<cfargument name="fileName" required="true" >
		<cfargument name="deleteFile" required="false" default=""> 
	
	<cfset MyFile="#request.basePath#clientFiles\archive.bat">
	<cfset mytoday = #CreateODBCDate(NOW())# />
	<cfset myday = #DAY(mytoday)# />
	<cfset mymonth = #MONTH(mytoday)# />
	<cfset myyear = #YEAR(mytoday)# />
	
	<cfset mycode = "#myyear#-#mymonth#-#myday#" />
		
	<!--- Create the batch file that will call on MySQL to execute. --->
	

<cfsavecontent variable="theLoad"><cfcontent reset="true"><cfoutput>
set backuptime=#mycode# 

set importFile="C:\Apache2.2\htdocs\accounts\clientFiles\imports\#arguments.fileName#" 
set backupfldr="C:\Apache2.2\htdocs\accounts\clientFiles\archived\" 


set zipper="c:\Program Files\7-Zip\7z.exe" 

set password="%SXH8cLn,_?!3k5Y9,{(]p{3{"

:: Number of days to retain .zip backup files 
set retaindays=5 
 

%zipper% a -t7z -mx9 -mmt -aos -p%password% "%backupfldr%%backuptime%.7z" "%importFile%"

 
<cfif arguments.deleteFile EQ 'delete'>
del "%importFile%"  
</cfif> 

Forfiles -p %backupfldr% -s -m *.* -d -%retaindays% -c "cmd /c del /q @path" 
</cfoutput>
</cfsavecontent>


			<cffile action="write"
             file="#MyFile#"
             output="#theLoad#"
             addnewline="yes" nameconflict="overwrite">

	<cfexecute name="C:\WINDOWS\system32\cmd.exe" arguments="/c ""#MyFile#""" timeout="1800"></cfexecute>
	  
	
	</cffunction>
</cfcomponent>