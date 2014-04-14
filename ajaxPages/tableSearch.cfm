

<cfoutput>
<cfset tableID = Request.cTableFunctions.getTableID(tableName="#tableName#") />	
	<p>
	<form action="" name="searchForm" id="searchForm">
	<fieldset>
			<label for="searchTerm">Search For</label> <input type="text" name="searchTerm" id="searchTerm"><br>
	</fieldset>
	
		</form>
		
		<div id="searchResults"></div>
		</p>	
	
</cfoutput>
