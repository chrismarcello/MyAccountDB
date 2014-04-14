<cfset tableSQL = Request.cTableFunctions.getTableSQL(tableID="#session.tableID#") />
<style>
        #editor { 
                position: absolute;
                top: 0;
                right: 0;
                bottom: 0;
                left: 0;
            }
    </style>
<script>
	 	var editor = ace.edit("editor");
        editor.setTheme("ace/theme/Dreamweaver");
        editor.getSession().setMode("ace/mode/mysql");
</script>
<cfif tableSQL.RecordCount GT 0>
			<div id="editor"><cfoutput>#tableSQL.sqlScript#</cfoutput></div>
		</cfif>
<form id="runSQLFORM" name="runSQLFORM">
	<cfoutput><input type="hidden" name="tableID" id="tableID" value="#session.tableID#"></cfoutput>
</form>		
