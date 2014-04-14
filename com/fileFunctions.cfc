<cfcomponent>
<cffunction name="init" access="public" returntype="Any" output="false">
<cfreturn this>
</cffunction>



<!--- File Functions --->
	
	<cffunction name="getDelimiters" access="public" returntype="query">
		<cfargument name="delimID" required="false" default="" > 
		
		<cfset var theTypes = ""/>
		
		<cfquery name="theTypes" datasource="#Request.mydns1#">
		SELECT *
		FROM fileDelimiters
			<cfif arguments.delimID NEQ ''>
			WHERE fileDelimID = <cfqueryparam value="#arguments.delimID#" cfsqltype="cf_sql_integer" > 
			</cfif>
		</cfquery> 
			
		
		<cfreturn #theTypes#>
	</cffunction>
	
	
	
<cffunction name="deleteSourceFile" access="remote" returntype="void">
<cfargument name="fileName" required="false" default="" >

<cfset sourceFile="#request.basePath#clientFiles\imports\#arguments.filename#">
	  
<cfif FileExists(#sourceFile#)>
        <cffile action="delete" file="#sourceFile#">
</cfif>  

	</cffunction>	
	
	<cffunction name="cleanArchives" access="remote" returntype="void">
		<!--- Delete any zip folder older than 5 days. --->
	
<cfdirectory directory="#request.basePath#clientFiles\archived\" name="dirQuery" action="LIST" filter="*.zip">

<cfoutput>
	<!--- Set the number of days you want to keep the archive for. --->
<cfset daysOld = 10 />

	<cfset deleteDate = DateAdd("d", -#daysOld#, #NOW()#) />
	
	<cfloop query="dirQuery">
			<CFSET Age=DateDiff("d",dirQuery.DateLastModified,Now())>
				<cfif Age GT daysOld>
					<cffile action="delete" file="#request.basePath#clientFiles\archived\#dirQuery.name#">
				</cfif>
	</cfloop>
</cfoutput>	
	  
	  
	</cffunction>
	
	<cffunction name="writeLogFiles" access="remote" returntype="void">
		<cfargument name="fileName" required="false" default="" > 
	<!--- Create the code for the archive name. --->
		
	<cfset mytoday = #CreateODBCDate(NOW())# />
	<cfset myday = #DAY(mytoday)# />
	<cfset mymonth = #MONTH(mytoday)# />
	<cfset myyear = #YEAR(mytoday)# />
	<cfset myhour = #HOUR(mytoday)# />
	<cfset myMinute = #MINUTE(mytoday)# />
	<cfset mySecond = #SECOND(mytoday)# />
	<cfset mycode = "#myyear##mymonth##myday##myhour##myMinute##mySecond#" />
	
	<cfset sourceFile="#request.basePath#clientFiles\imports\#arguments.filename#">
	
     <cfzip file="#request.basePath#clientFiles\archived\#mycode#.zip" source="#sourceFile#">
	  
	 <!--- Delete load script file. --->

<cfif FileExists(sourceFile)>
        <cffile action="delete" file="#sourceFile#">
</cfif>
	  
	  
	</cffunction>

</cfcomponent>