
	<cfquery name="getTheFile" datasource="accountNumbers">
		SELECT accountNumber, clientNumber, copyOfBill
		 FROM accountsAdded	
		WHERE accountNumber = '#accountNumber#'
	</cfquery>
<p><cfoutput>
   	Account Number: #accountNumber#
   </cfoutput></p>	
		<cfoutput query="getTheFile">
			<cfif getTheFile.copyOfBill EQ ''>
				No documentation uploaded.
				<cfelse>
					<cfset theFile = "#Request.basePath#clientFiles\accountCopies\#clientNumber#\#copyOfBill#" />
			<cfset fileInfo = getFileInfo(#theFile#) >
			
			<cfset fileExt = "#ListLast(fileInfo.name, ".")#">
	<!--- is a file --->
	
	<cfif fileExt EQ 'jpg' OR fileExt EQ 'jpg' OR fileExt EQ 'png'>
		<cfimage source="#theFile#" action="info" structName="viatoInfo">
		<cfif viatoInfo.height GT 2000 AND viatoInfo.width GT 2000>
		<cfimage source="#theFile#" action="resize"  
    width="50%" height="50%" name="smLogo">
	
			<cfelse>
		<cfset smLogo = "#theFile#" />		
	</cfif>	
		
		<cfimage  
    action = "writeToBrowser" 
    source = "#smLogo#"  
    >
	</cfif>
	<cfif fileExt EQ 'pdf'>
		<cfset thisFile = "#ListFirst(fileInfo.name, ".")#" />
		<cfset tempFolder = "#Request.basePath#clientFiles\accountCopies\thumbs\#thisFile#">		
				<cfif not directoryExists(tempFolder)>
					
					<cfdirectory action="create" directory="#tempFolder#">
					
					<cfpdf action="thumbnail" overwrite="yes" source="#theFile#" format="png" imageprefix="#thisFile#" destination="#tempFolder#" hires="true">
						<cfdirectory name="thumbs" directory="#tempFolder#">
						<cfloop query="thumbs">
							<cfif fileExists("#tempFolder#\#name#") and isImageFile("#tempFolder#\#name#")>
    <cfimage action="writeToBrowser" source="#tempFolder#\#name#">
    <br>
</cfif>
						</cfloop>
						
			<cfelse>
				<cfdirectory name="thumbs" directory="#tempFolder#">
				<cfloop query="thumbs">
							<cfif fileExists("#tempFolder#\#name#") and isImageFile("#tempFolder#\#name#")>
    <cfimage action="writeToBrowser" source="#tempFolder#\#name#">
    <br>
</cfif>
						</cfloop>
	</cfif>
	</cfif>
			</cfif>
		</cfoutput>