<cfoutput>
	<cfset fileDirectory = "#request.basePath#clientFiles\imports\">
	<cfset readFile = "#fileDirectory##dataFile#">
<b>File Preview:</b><br>	
</cfoutput>	
	<cfloop file="#readfile#" index="line" from="1" to="5">
    <cfoutput>#line#<br /></cfoutput>
</cfloop>
