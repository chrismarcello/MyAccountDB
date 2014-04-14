<cfcomponent
	displayname="Application"
	output="true"
	hint="Handle the application.">
 
 
	<cfscript>
 
		THIS.Name = "accountNumbersSimple";
		THIS.ApplicationTimeout = CreateTimeSpan( 0, 1, 0, 0 );
		THIS.SessionManagement = true;
		THIS.SessionTimeout = CreateTimeSpan( 0, 0, 30, 0 );
		THIS.LoginStorage = "SESSION";
		THIS.SetClientCookies = true;
		THIS.ScriptProtect = "ALL";
		THIS.sameformfieldsasarray = true;
 
	</cfscript>
 
 
	<!--- <cfsetting
		requesttimeout="30"
		showdebugoutput="false"
		enablecfoutputonly="false"
		/> --->
 
 
	<cffunction name="OnApplicationStart" access="public" returntype="boolean" output="true"
		hint="Fires when the application is first created.">
 
		<cfset Application.myUtils = CreateObject("component", "com.udfs").init()> 
		
 
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
 
 
	<cffunction name="OnSessionStart" access="public" returntype="void" output="true"
		hint="Fires when the session is first created.">
 
		
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction name="OnRequestStart" access="public"
		hint="Fires when prior to page processing.">
 
		<!--- Define arguments. --->
<cfargument name = "thisRequest" type="string"
			required="true"
			hint="I am the template requested by the user."
			/>
 
			
			<cfset Request.mydns = "accountNumbers">
			<cfset Request.mydns1 = "accountNumbersNew">
			<cfset Request.CurrentPage=GetFileFromPath(GetTemplatePath())>
			
			<cfset Request.dbFunctions = CreateObject("component", "com.dbFunctions").init()>
			<cfset Request.clients = CreateObject("component", "com.clientFunctions").init()>
			<cfset Request.cTableFunctions = CreateObject("component", "com.clientTableFunctions").init()>
			<cfset Request.dbBasic = CreateObject("component", "com.dbBasic").init()>
		    <cfset Request.dbTables = CreateObject("component", "com.dbTables").init()>
			<cfset Request.files = CreateObject("component", "com.fileFunctions").init()>
		
			
			<!---<cfset Request.otherFunctions = CreateObject("component", "com.otherFunctions").init()>
			<cfset Request.groupFile = CreateObject("component", "com.groupFileFunctions2").init()>
			<cfset Request.custom = CreateObject("component", "com.customFiles").init()>
			<cfset Request.oscData = CreateObject("component", "com.oscFunctions").init()>--->
			
	<!--- Define the local scope. --->
		<cfset local = {} />
 
		<!--- Define request settings. --->
		<cfsetting showdebugoutput="false" />
 
		<!---
			Set the value of the web root. Since we know that this
			template (Application.cfc) is in the web root for this
			application, all we have to do is figure out the
			difference between this template and the requested
			template. Every directory difference will require our
			webroot to have a "../" in it.
		--->
 
		<!---
			Get the current (Application.cfc) directory path based
			on the current template path.
		--->
		<cfset local.basePath = getDirectoryFromPath(
			getCurrentTemplatePath()
			) />
			
		<cfset webBasePath = Replace(local.basePath, "\", "/", "ALL") />
			
		<cfset request.basePath = #local.basePath# />
		<cfset request.webBasePath = #webBasePath# />	
 
		<!---
			Get the target (script_name) directory path based on
			expanded script name.
		--->
		<cfset local.targetPath = getDirectoryFromPath(
			expandPath( arguments.thisRequest )
			) />
 
		<!---
			Now that we have both paths, all we have to do is
			find the difference in path. We can treat the paths
			as slash-delimmited lists. To do this, let's calculate
			the depth of sub directories.
		--->
		<cfset local.requestDepth = (
			listLen( local.targetPath, "\/" ) -
			listLen( local.basePath, "\/" )
			) />
 <cfset request.requestDepth = #local.requestDepth# />
		<!---
			With the request depth, we can easily create our
			web root by repeating "../" the appropriate number
			of times.
		--->
		<cfset request.webRoot = repeatString(
			"../",
			local.requestDepth
			) />
 
		<!---
			While we wouldn't normally do this for every page
			request (it would normally be cached in the
			application initialization), I'm going to calculate
			the site URL based on the web root.
		--->
		<cfset request.siteUrl = (
			"http://" &
			cgi.server_name &
			reReplace(
				getDirectoryFromPath( arguments.thisRequest ),
				"([^\\/]+[\\/]){#local.requestDepth#}$",
				"",
				"one"
				)
			) />		
			

	</cffunction>
 
 
 
	<cffunction name="OnRequestEnd" access="public" returntype="void" output="true"
		hint="Fires after the page processing is complete.">
 
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction name="OnSessionEnd" access="public" returntype="void" output="true"
		hint="Fires when the session is terminated.">
 
		<!--- Define arguments. --->
		<cfargument name="thisSession" type="struct" required="true" />
		<cfargument name="thisApp" type="struct" required="false" default="#StructNew()#" />
			
		
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
 
	<cffunction name="OnApplicationEnd" access="public" returntype="void" output="false"
		hint="Fires when the application is terminated.">
 
		<cfargument name="ApplicationScope" type="struct" required="false" default="#StructNew()#" />
 
		
 
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
 
<cffunction name="onMissingTemplate" returnType="boolean" output="false">
   <cfargument name="thePage" type="string" required="true">
	   <cflog file="missingtemplatelog" text="#arguments.thePage#">
	   <cflocation url="404.cfm?thepage=#urlEncodedFormat(arguments.thePage)#" addToken="false">
</cffunction>
 
	<cffunction name="onError" returnType="void" output="true">
   <cfargument name="exception" required="true">
   <cfargument name="eventname" type="string" required="true">
   <cfset var errortext = "">

   <cflog file="myapperrorlog" text="#arguments.exception.message#">
   
   <cfsavecontent variable="errortext">
   <cfoutput>
   An error occurred: http://#cgi.server_name##cgi.script_name#?#cgi.query_string#<br />
   Time: #dateFormat(now(), "short")# #timeFormat(now(), "short")#<br />
   
   <cfdump var="#arguments.exception#" label="Error">
   <cfdump var="#form#" label="Form">
   <cfdump var="#url#" label="URL">
   
   </cfoutput>
   </cfsavecontent>
<cfset CurrentTemplatePath=GetCurrenttemplatePath()>  
<cfset CurrentDirectory=GetDirectoryFromPath(CurrentTemplatePath)> 
<cfset yearcode = DateFormat(NOW(), 'YY')>
<cfset monthcode = DateFormat(NOW(), 'MM')>
<cfset daycode = #DateFormat(NOW(), 'DD')#>
<cfset hourcode = #TimeFormat(NOW(), 'hh')#>
<cfset minutecode = #TimeFormat(NOW(), 'mm')#>
<cfset seccode = TimeFormat(NOW(), 'ss')>
<cfset mycode = "#yearcode##monthcode##daycode##hourcode##minutecode##seccode#">
		<cffile
		   action = "append"
		   file = "#CurrentDirectory#errorlogs\error_#mycode#.html"
		   output = "#errortext#"
		>
 
		<!--- <cflocation url="#request.webRoot#error.cfm"> --->
	</cffunction>
 
</cfcomponent>