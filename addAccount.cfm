<cfoutput>
	
	<cfset theClientDetails = Request.clients.getTheClient(clientID=#form.clientID#) />
<cfif IsDefined("form.billFile") AND #form.billFile# NEQ ''>

	<cfset destdir = "#Request.basePath#clientFiles\accountCopies\#theClientDetails.clientNumber#" />	
	<cfif not directoryExists(destdir)>
    	<cfdirectory action="create" directory="#destdir#">
	</cfif>
	<cffile action="upload" filefield="billFile" destination="#destdir#" nameconflict="makeunique" result="result">
	<!---<cfdump var="#result#">--->
	<cfset newFilePath = destdir & "\" & result.serverfile>
	<cfif FileExists("#newFilePath#")>
		<cfset newFileName = "#form.accountNumber#_#form.zipCode#_#theClientDetails.clientNumber#.#result.serverfileext#" />
		<cfset newFile = destdir & "\" & #newFileName#>
	<cffile action="rename" destination="#newFile#" source="#newFilePath#" >	
	
	</cfif>
	<cfif IsDefined("newFileName") AND #newFileName# NEQ ''>
		<cfset billCopy = "#newFileName#" />
			<cfelse>
		<cfset billCopy = "" />		
	</cfif>
		<cfelse>
	<cfset billCopy = "" />			
</cfif>		
	<cfset addAccount = Request.clients.addToOsC(clientID=#form.clientID#, accountNumber="#form.accountNumber#", zipCode="#form.zipCode#", billCopy="#billCopy#") />
	
	<cflocation url="index.cfm?&addStatus=success" >
</cfoutput>