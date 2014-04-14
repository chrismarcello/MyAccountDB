<script type="text/javascript" charset="utf-8">
			$(document).ready( function () {
				var oTable = $('#example').dataTable( {
					"sDom": 'Rlfrtip'
				} );
			} );
</script>

<cfoutput>
	<cfset theTable = Request.cTableFunctions.getTableHeader(tableID=#myTable#) />
<cfset tableQuery = Request.dbTables.tableSearch(tableName=#theTable.tableName#, searchTerm="#searchTerm#") />

</cfoutput>



	<style type="text/css">
        .HighLighted
        {
            background-color: yellow;
        }

        td.CenterCell
        {
            text-align: left;
        }
    </style>
<cfif tableQuery.RecordCount>

	<cfset cols = getMetadata(tableQuery)> <!--- This get the column names since it is dynamic --->
<cfset colList = "">
<cfloop from="1" to="#arrayLen(cols)#" index="x">
    <cfset colList = listAppend(colList, cols[x].name)> <!--- Since it is dynamic, we must get CF to output the columns in the correct format. --->
</cfloop>
<table align="center" border="1" class="display" id="example" cellpadding="0" cellspacing="0">
  <thead>	
	<tr>
		<cfloop index="col" list="#collist#"><th><div align="center"><cfoutput><b>#col#</b></cfoutput></div></th></cfloop> <!--- This give the table header with the dynamic column names --->
	</tr>
  </thead>
  <tbody>
<cfoutput query="tableQuery"> <!--- Loop through new query --->
  <!--- <tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">--->
  		<tr  class="odd gradeX">
    <cfloop index="col" list="#collist#"> <!--- Loop through list so that the columns match the correct data --->
           <td><cfif #tableQuery[col][currentRow]# NEQ ''>
		   			<cfif IsDate(#tableQuery[col][currentRow]#)> <!--- If the data is a data field, we must format it as such. --->
						<cfset myd = #DateFormat(tableQuery[col][currentRow], 'MM/DD/YYYY')# />
							<cfelse>
						<cfset myd = #tableQuery[col][currentRow]# />	
					</cfif>
		   
		   <div align="center"><!---#request.myUtils.highlightKeywords(myd, searchTerm, {tag="span", attributes='style="color:yellow;"'})#--->#myd#</div>
		   <cfelse>&nbsp;</cfif></td>
    </cfloop>
    </tr>
	</tbody>
</cfoutput>
</table>
	<cfelse>
		<cfoutput>
		Sorry, #searchTerm# was not found.
		</cfoutput>
</cfif>

	