component  output="false"
{
	
	VARIABLES._DIRARRAY = ["asc","desc"];
	
	/**
	 *	FUNCTION getTableHeaders
	 *	A function to get paging query of blog entries for layout in jqGrid
	 *
	 *	@access remote
	 *	@returnType any
	 *	@output false
	 
	 */
	 
	function getTableHeaders( numeric tableID = "") returnformat="JSON"       {
		LOCAL.retVal = {"tableID" = Arguments.tableID};

		

		

		// Main data query
		LOCAL.sql = "SELECT	columnName
					FROM clienttablefields	
					WHERE 0 = 0
					 ";
		
			LOCAL.sql &= " AND tableID = :tableID
			 ";
					 
		
		LOCAL.sql &= "ORDER BY columnPosition ASC
					 ";
		LOCAL.q = new Query(sql = LOCAL.sql);
		LOCAL.q.setDatasource("accountNumbersNew");
		LOCAL.q.setcachedwithin(CreateTimeSpan(0, 3, 0, 0)); 
		
		
			LOCAL.q.addParam(name = "tableID", value = "#ARGUMENTS.tableID#", cfsqltype = "cf_sql_integer");
		
		

		try {
			LOCAL.retVal.data = LOCAL.q.execute().getResult();
			
			/** arrColumn = [];
			
			for (i=1; i<=LOCAL.retVal.data.recordCount; i++) {
				
				arrayAppend(arrColumn, "'#LOCAL.retVal#'");
				
			}; */
			
		} catch (any excpt) {
			LOCAL.retVal.success = false;
			LOCAL.retVal.message = excpt.message;
		}
		//return ArrayToList(arrColumn);
		return SerializeJson(LOCAL.retVal.data);
		//return LOCAL.retVal.data;
	}
	
	/**
	 *	FUNCTION getTableHeaders
	 *	A function to get paging query of blog entries for layout in jqGrid
	 *
	 *	@access remote
	 *	@returnType struct
	 *	@output false
	 
	 */
	 
	function getTableDetails(string tableName= "", numeric pageIndex = 1, numeric pageSize = 50, string sortCol = "columnPosition", string sortDir = "asc", boolean _search = "false", string searchField = "", string searchOper = "", string searchString = "") {
		LOCAL.retVal = {"tableName" = ARGUMENTS.tableName, "success" = true, "pageIndex" = ARGUMENTS.pageIndex, "pageCount" = 0, "recordCount" = 0, "message" = "", "data" = ""};

		LOCAL.scArr = ListToArray(ARGUMENTS.sortCol);
		LOCAL.sortCol = (ArrayLen(LOCAL.scArr) eq 2) ? LOCAL.scArr[2] : ARGUMENTS.sortCol;
		// Verify that your sort column and direction are valid. If not, then return an error.
		if(ArrayFindNoCase(VARIABLES._DIRARRAY, ARGUMENTS.sortDir)){
			LOCAL.orderby = ARGUMENTS.sortCol & " " & ARGUMENTS.sortDir;
		} else {
			StructAppend(LOCAL.retVal,{"success" = false, "message" = "Your sort criteria is not valid."},true);
			return LOCAL.retVal;
		}
	tableID = Request.cTableFunctions.getTableID(tableName="#ARGUMENTS.tableName#");
		
		

		// Main data query
		LOCAL.sql = "SELECT SQL_CALC_FOUND_ROWS tableLineID, columnPosition, columnName, columnType, columnLength, defaultValue, columnNull, autoIncrement
					FROM clienttablefields
					WHERE 0 = 0
					 ";
		LOCAL.sql &= " AND tableID = :tableID
			 ";			 
		
		LOCAL.sql &= "ORDER BY #LOCAL.orderby#
					 LIMIT	:start,:numRec";
					 
		LOCAL.q = new Query(sql = LOCAL.sql);
		LOCAL.q.setDatasource("accountNumbersNew");
		LOCAL.q.addParam(name = "tableID", value = "#tableID.tableID#", cfsqltype = "cf_sql_integer");
		LOCAL.q.addParam(name = "start", value = (ARGUMENTS.pageIndex-1) * ARGUMENTS.pageSize, cfsqltype = "cf_sql_integer");
		LOCAL.q.addParam(name = "numRec", value = ARGUMENTS.pageSize, cfsqltype = "cf_sql_integer");
		
		
		try {
			//savecontent variable="myQuery" {WriteOutput(LOCAL.sql);} 
			//FileWrite("#request.basePath#query.txt", "#myQuery#");
			LOCAL.retVal.data = LOCAL.q.execute().getResult();
			if(LOCAL.retVal.data.recordCount){
				/*
				 * The next statement is used to provide a TotalCount of all matched records.
				 */
				LOCAL.q.setSql("SELECT FOUND_ROWS() as totalCount");
				LOCAL.totResult = LOCAL.q.execute().getResult();
				if(LOCAL.totResult.recordCount){
					LOCAL.retVal.recordCount = LOCAL.totResult.totalCount; // total number of records
					LOCAL.retVal.pageCount = Ceiling(LOCAL.totResult.TotalCount / ARGUMENTS.pageSize); // total number of pages by pageSize
				}
			}
		} catch (any excpt) {
			LOCAL.retVal.success = false;
			LOCAL.retVal.message = excpt.message;
			
			yearcode = DateFormat(NOW(), 'YY');
			monthcode = DateFormat(NOW(), 'MM');
			daycode = #DateFormat(NOW(), 'DD')#;
			hourcode = #TimeFormat(NOW(), 'hh')#;
			minutecode = #TimeFormat(NOW(), 'mm')#;
			seccode = TimeFormat(NOW(), 'ss');
			
			mycode = "#yearcode##monthcode##daycode##hourcode##minutecode##seccode#";
			savecontent variable="myQuery" {WriteOutput(excpt.message);
				WriteOutput(excpt.type);
				 if(StructKeyExists(excpt,"errorCode") AND Len(excpt.errorCode)){
         		WriteOutput(excpt.errorCode);
   }
   				WriteDump(var=excpt);
			} 
			FileWrite("#request.basePath#errorLogs\error_#mycode#.html", "#myQuery#");
			
		}
		return LOCAL.retVal;
	}
	
	/**
	 *	FUNCTION getTableData
	 *	A function to get paging query of blog entries for layout in jqGrid
	 *
	 *	@access remote
	 *	@returnType struct
	 *	@output false
	 
	 */
	 
	function getTableData(string tableName= "", numeric pageIndex = 1, numeric pageSize = 50, string sortCol = "AccountNumber", string sortDir = "asc", boolean _search = "false", string searchField = "", string searchOper = "", string searchString = "") {
		LOCAL.retVal = {"tableName" = ARGUMENTS.tableName, "success" = true, "pageIndex" = ARGUMENTS.pageIndex, "pageCount" = 0, "recordCount" = 0, "message" = "", "data" = ""};

		LOCAL.scArr = ListToArray(ARGUMENTS.sortCol);
		LOCAL.sortCol = (ArrayLen(LOCAL.scArr) eq 2) ? LOCAL.scArr[2] : ARGUMENTS.sortCol;
		// Verify that your sort column and direction are valid. If not, then return an error.
		if(ArrayFindNoCase(VARIABLES._DIRARRAY, ARGUMENTS.sortDir)){
			LOCAL.orderby = ARGUMENTS.sortCol & " " & ARGUMENTS.sortDir;
		} else {
			StructAppend(LOCAL.retVal,{"success" = false, "message" = "Your sort criteria is not valid."},true);
			return LOCAL.retVal;
		}
	dataColumns = Request.dbTables.getTableColumnList(tableName=#ARGUMENTS.tableName#);
		
		/* arrColumn = [];
			
			for (i=1; i<= dataColumns.recordCount; i++) {
				
				arrayAppend(arrColumn, "#dataColumns.COLUMN_NAME#");
				
			}; */

		// Main data query
		LOCAL.sql = "SELECT SQL_CALC_FOUND_ROWS #dataColumns#
					FROM #ARGUMENTS.tableName#	
					WHERE 0 = 0
					 ";
					 
					 if(ARGUMENTS._search EQ 'true'){
			
			switch(ARGUMENTS.searchOper) {
					case "eq":
					theCompare = "=";
					break;
					case "ne":
					theCompare = "!=";
					break;
					case "lt":
					theCompare = "<";
					break;
					case "le":
					theCompare = "=<";
					break;
					case "gt":
					theCompare = ">";
					break;
					case "ge":
					theCompare = "=>";
					break;
					case "cn":
					theCompare = "LIKE";
					break;
					case "nc":
					theCompare = "NOT LIKE";
					break;
					default:
					theCompare = "LIKE";
				}
			if(ARGUMENTS.searchOper EQ 'cn' OR ARGUMENTS.searchOper EQ 'nc')
				{
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '%#ARGUMENTS.searchString#%'
			 ";
				} else if(ARGUMENTS.searchOper EQ 'bw')
				{
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '#ARGUMENTS.searchString#%'
			 ";
				} else if(ARGUMENTS.searchOper EQ 'ew')
				{
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '%#ARGUMENTS.searchString#'
			 ";
				} 
				
				else {
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '#ARGUMENTS.searchString#'	
			";	
				}
		}
		
		LOCAL.sql &= "ORDER BY #LOCAL.orderby#
					 LIMIT	:start,:numRec";
					 
		LOCAL.q = new Query(sql = LOCAL.sql);
		LOCAL.q.setDatasource("accountNumbers");
		LOCAL.q.setcachedwithin(CreateTimeSpan(0, 3, 0, 0));
		LOCAL.q.addParam(name = "start", value = (ARGUMENTS.pageIndex-1) * ARGUMENTS.pageSize, cfsqltype = "cf_sql_integer");
		LOCAL.q.addParam(name = "numRec", value = ARGUMENTS.pageSize, cfsqltype = "cf_sql_integer");
		
		
		try {
			//savecontent variable="myQuery" {WriteOutput(LOCAL.sql);} 
			//FileWrite("#request.basePath#query.txt", "#myQuery#");
			LOCAL.retVal.data = LOCAL.q.execute().getResult();
			if(LOCAL.retVal.data.recordCount){
				/*
				 * The next statement is used to provide a TotalCount of all matched records.
				 */
				LOCAL.q.setSql("SELECT FOUND_ROWS() as totalCount");
				LOCAL.totResult = LOCAL.q.execute().getResult();
				if(LOCAL.totResult.recordCount){
					LOCAL.retVal.recordCount = LOCAL.totResult.totalCount; // total number of records
					LOCAL.retVal.pageCount = Ceiling(LOCAL.totResult.TotalCount / ARGUMENTS.pageSize); // total number of pages by pageSize
				}
			}
		} catch (any excpt) {
			LOCAL.retVal.success = false;
			LOCAL.retVal.message = excpt.message;
			
			yearcode = DateFormat(NOW(), 'YY');
			monthcode = DateFormat(NOW(), 'MM');
			daycode = #DateFormat(NOW(), 'DD')#;
			hourcode = #TimeFormat(NOW(), 'hh')#;
			minutecode = #TimeFormat(NOW(), 'mm')#;
			seccode = TimeFormat(NOW(), 'ss');
			
			mycode = "#yearcode##monthcode##daycode##hourcode##minutecode##seccode#";
			savecontent variable="myQuery" {WriteOutput(excpt.message);
				WriteOutput(excpt.type);
				 if(StructKeyExists(excpt,"errorCode") AND Len(excpt.errorCode)){
         		WriteOutput(excpt.errorCode);
   }
   				WriteDump(var=excpt);
			} 
			FileWrite("#request.basePath#errorLogs\error_#mycode#.html", "#myQuery#");
			
		}
		return LOCAL.retVal;
	}
	/**
	 *	FUNCTION getManualAccounts
	 *	A function to get paging query of blog entries for layout in jqGrid
	 *
	 *	@access remote
	 *	@returnType struct
	 *	@output false
	 
	 */
	 
	function getManualAccounts(numeric pageIndex = 1, numeric pageSize = 50, string sortCol = "dateAdded", string sortDir = "desc", boolean _search = "false", string searchField = "", string searchOper = "", string searchString = "") {
		LOCAL.retVal = {"success" = true, "pageIndex" = ARGUMENTS.pageIndex, "pageCount" = 0, "recordCount" = 0, "message" = "", "data" = ""};

		LOCAL.scArr = ListToArray(ARGUMENTS.sortCol);
		LOCAL.sortCol = (ArrayLen(LOCAL.scArr) eq 2) ? LOCAL.scArr[2] : ARGUMENTS.sortCol;
		// Verify that your sort column and direction are valid. If not, then return an error.
		if(ArrayFindNoCase(VARIABLES._DIRARRAY, ARGUMENTS.sortDir)){
			LOCAL.orderby = ARGUMENTS.sortCol & " " & ARGUMENTS.sortDir;
		} else {
			StructAppend(LOCAL.retVal,{"success" = false, "message" = "Your sort criteria is not valid."},true);
			return LOCAL.retVal;
		}
	
		// Main data query
		LOCAL.sql = "SELECT SQL_CALC_FOUND_ROWS accountNumber, zipCode, clientNumber, dateAdded
					FROM accountsAdded	
					WHERE 0 = 0
					 ";
					 
					 if(ARGUMENTS._search EQ 'true'){
			
			switch(ARGUMENTS.searchOper) {
					case "eq":
					theCompare = "=";
					break;
					case "ne":
					theCompare = "!=";
					break;
					case "lt":
					theCompare = "<";
					break;
					case "le":
					theCompare = "=<";
					break;
					case "gt":
					theCompare = ">";
					break;
					case "ge":
					theCompare = "=>";
					break;
					case "cn":
					theCompare = "LIKE";
					break;
					case "nc":
					theCompare = "NOT LIKE";
					break;
					default:
					theCompare = "LIKE";
				}
			if(ARGUMENTS.searchOper EQ 'cn' OR ARGUMENTS.searchOper EQ 'nc')
				{
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '%#ARGUMENTS.searchString#%'
			 ";
				} else if(ARGUMENTS.searchOper EQ 'bw')
				{
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '#ARGUMENTS.searchString#%'
			 ";
				} else if(ARGUMENTS.searchOper EQ 'ew')
				{
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '%#ARGUMENTS.searchString#'
			 ";
				} 
				
				else {
			LOCAL.sql &= " AND #ARGUMENTS.searchField# #theCompare# '#ARGUMENTS.searchString#'	
			";	
				}
		}
		
		LOCAL.sql &= "ORDER BY #LOCAL.orderby#
					 LIMIT	:start,:numRec";
					 
		LOCAL.q = new Query(sql = LOCAL.sql);
		LOCAL.q.setDatasource("accountNumbers");
		LOCAL.q.addParam(name = "start", value = (ARGUMENTS.pageIndex-1) * ARGUMENTS.pageSize, cfsqltype = "cf_sql_integer");
		LOCAL.q.addParam(name = "numRec", value = ARGUMENTS.pageSize, cfsqltype = "cf_sql_integer");
		
		
		try {
			//savecontent variable="myQuery" {WriteOutput(LOCAL.sql);} 
			//FileWrite("#request.basePath#query.txt", "#myQuery#");
			LOCAL.retVal.data = LOCAL.q.execute().getResult();
			if(LOCAL.retVal.data.recordCount){
				/*
				 * The next statement is used to provide a TotalCount of all matched records.
				 */
				LOCAL.q.setSql("SELECT FOUND_ROWS() as totalCount");
				LOCAL.totResult = LOCAL.q.execute().getResult();
				if(LOCAL.totResult.recordCount){
					LOCAL.retVal.recordCount = LOCAL.totResult.totalCount; // total number of records
					LOCAL.retVal.pageCount = Ceiling(LOCAL.totResult.TotalCount / ARGUMENTS.pageSize); // total number of pages by pageSize
				}
			}
		} catch (any excpt) {
			LOCAL.retVal.success = false;
			LOCAL.retVal.message = excpt.message;
			
			yearcode = DateFormat(NOW(), 'YY');
			monthcode = DateFormat(NOW(), 'MM');
			daycode = #DateFormat(NOW(), 'DD')#;
			hourcode = #TimeFormat(NOW(), 'hh')#;
			minutecode = #TimeFormat(NOW(), 'mm')#;
			seccode = TimeFormat(NOW(), 'ss');
			
			mycode = "#yearcode##monthcode##daycode##hourcode##minutecode##seccode#";
			savecontent variable="myQuery" {WriteOutput(excpt.message);
				WriteOutput(excpt.type);
				 if(StructKeyExists(excpt,"errorCode") AND Len(excpt.errorCode)){
         		WriteOutput(excpt.errorCode);
   }
   				WriteDump(var=excpt);
			} 
			FileWrite("#request.basePath#errorLogs\error_#mycode#.html", "#myQuery#");
			
		}
		return LOCAL.retVal;
	}
}