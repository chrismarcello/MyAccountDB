<cfcomponent output="false">

<cffunction name="init" access="public" returntype="Any" output="false">
<cfreturn this>
</cffunction>

	<cffunction name="addClients" access="remote" returntype="any">
		<cfargument name="clientName" type="string" required="yes">
		<cfargument name="oscTableName" type="string" required="no" default="">
		<cfargument name="clientNumber" type="string" required="yes">
		
		<cfquery datasource="#Request.mydns1#">
		INSERT INTO clients (clientName, clientNumber, oscTableName)
			VALUES (
						
						<cfqueryparam value="#arguments.clientName#" cfsqltype="cf_sql_varchar">,
					
						<cfqueryparam value="#arguments.clientNumber#" cfsqltype="cf_sql_varchar">,
						
					<cfif IsDefined("arguments.oscTableName") AND #arguments.oscTableName# NEQ ''>
						<cfqueryparam value="#arguments.oscTableName#" cfsqltype="cf_sql_varchar">
							<cfelse>
						''	
					</cfif>
					)
		</cfquery>
	
	
	<cfset getTheReturn = Request.Clients.getClientsList() />
	<cfsavecontent variable="thisReturn">
	<ul>
		<cfoutput query="getTheReturn">
		<li><div id="#getTheReturn.clientID#" class="some-class" data-target="#getTheReturn.clientID#">
    				#getTheReturn.clientName#
			</div></li>
		</cfoutput>
	</ul>
	</cfsavecontent>
	
	<cfreturn thisReturn>
	</cffunction>
		<cffunction name="addGroup" access="remote" returntype="any">
		<cfargument name="clientName" type="string" required="yes">
		<cfargument name="newTableName" type="string" required="yes">
		<cfargument name="finalTableName" type="string" required="yes">
		
		<cfquery datasource="#Request.mydns1#" result="InsertGroup">
		INSERT INTO clientGroups (groupName, dateCreated)
			VALUES (
						
						<cfqueryparam value="#arguments.clientName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp">
					)
		</cfquery>
		
		<cfquery datasource="#Request.mydns1#">
		INSERT INTO oscTables (groupID, newTableName, finalTableName)
			VALUES (
						
						<cfqueryparam cfsqltype="cf_sql_integer" value="#InsertGroup.GENERATED_KEY#">,
						<cfqueryparam value="#arguments.newTableName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.finalTableName#" cfsqltype="cf_sql_varchar">
					)
		</cfquery>
	
	
	<cfset getTheReturn = Request.Clients.getGroupList() />
	<cfsavecontent variable="thisReturn">
	<ul>
		<cfoutput query="getTheReturn">
		<li><a href="groupDash.cfm?groupID=#getTheReturn.groupID#">#getTheReturn.groupName#</a></li>
		</cfoutput>
	</ul>
	</cfsavecontent>
	
	<cfreturn thisReturn>
	</cffunction>
	
	
	
	<cffunction name="getClientsList" access="public" returntype="any">
		
	<cfset var Clients = "" />
	
<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT clientID, clientName
	FROM clients
	ORDER BY clientName
</cfquery>
	
	<cfset myresults = #Clients# />
		<cfreturn myresults>
	</cffunction>
	
	<cffunction name="getClientsListJson" access="remote" returntype="query" returnformat="json">
		
	<cfset var Clients = "" />
	
<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT clientID, clientName
	FROM clients
	ORDER BY clientName
</cfquery>
	
	<cfset myresults = #serializeJSON(Clients)# />
		<cfreturn myresults>
	</cffunction>
	
<cffunction name="getAllClientsList" access="public" returntype="any">
		
		
	<cfset var Clients = "" />
	
<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT clientID, clientName
	FROM clients
	ORDER BY clientName
</cfquery>
	
	<cfset myresults = "#Clients#" />
		<cfreturn myresults>
	</cffunction>
	
	<cffunction name="getGroups" access="public" returntype="any">
		
	<cfset var Clients = "" />
	
<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT groupID, groupName
	FROM clientgroups
	ORDER BY groupName
</cfquery>
	
	<cfset myresults = #Clients# />
		<cfreturn myresults>
	</cffunction>
	
	
	<cffunction name="getGroupList" access="public" returntype="any">
		
	<cfset var Clients = "" />
	
<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT groupID, groupName
	FROM clientgroups
	ORDER BY groupName
</cfquery>
	
	<cfset myresults = #Clients# />
		<cfreturn myresults>
	</cffunction>
	<cffunction name="getTheClient" access="public" returntype="any">
		<cfargument name="clientID" required="yes">
		
	<cfset var Clients = "" />
	
<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT clientID, clientName, clientNumber, oscTableName
	FROM clients

WHERE clientID = <cfqueryparam value="#arguments.clientID#" cfsqltype="cf_sql_integer">

</cfquery>
	
	<cfset myresults = #Clients# />
		<cfreturn myresults>
	</cffunction>
	<cffunction name="addToOsC" access="remote" returntype="any">
		<cfargument name="clientID" type="string" required="yes">
		<cfargument name="accountNumber" type="string" required="yes">
		<cfargument name="zipCode" type="string" required="yes">
		<cfargument name="billCopy" type="string" required="false" default=""> 
		
		<cfset theClientDetails = Request.clients.getTheClient(clientID=#arguments.clientID#) />
		
<cfset theNormalized = ReReplace(arguments.accountNumber, "^0+", "") />
<cfset theNormalized = "#Application.myUtils.GetNumbers(arguments.accountNumber)#" />

<cfset theAccount = "#Application.myUtils.GetNumbers(arguments.accountNumber)#" />

<cfif LEN(arguments.zipCode) LT 5>
	<cfset theZip = #NumberFormat(arguments.zipCode, "000005")# />
		<cfelse>
	<cfset theZip = #arguments.zipCode# />		
</cfif>
		
		<cfquery datasource="efi">
		INSERT IGNORE INTO #theClientDetails.oscTableName# (account_number, zipcode, normalized, utility)
			VALUES (
						
						<cfqueryparam value="#theAccount#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#LEFT(theZip, 5)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#theNormalized#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#theClientDetails.clientNumber#" cfsqltype="cf_sql_varchar">
					)
		</cfquery>
		
		<cfquery datasource="accountNumbers">
		INSERT IGNORE INTO accountsAdded (accountNumber, zipCode, clientNumber, dateAdded, copyOfBill)
			VALUES (
						
						<cfqueryparam value="#arguments.accountNumber#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#LEFT(theZip, 5)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#theClientDetails.clientNumber#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#NOW()#" cfsqltype="cf_sql_timestamp" >,
						<cfif IsDefined("arguments.billCopy") AND #arguments.billCopy# NEQ ''>
						<cfqueryparam value="#arguments.billCopy#" cfsqltype="cf_sql_varchar">
							<cfelse>
								''
						</cfif>
					)
		</cfquery>
		<cfquery datasource="accountNumbers">
		INSERT IGNORE INTO allaccountnumbers (account_number, zipcode, normalized, utility)
			VALUES (
						
						<cfqueryparam value="#arguments.accountNumber#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#LEFT(theZip, 5)#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#theNormalized#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#theClientDetails.clientNumber#" cfsqltype="cf_sql_varchar">
					)
		</cfquery>
	
	<cfset thisReturn = "#theNormalized# Account Added" />
	
	<cfreturn thisReturn>
	</cffunction>
</cfcomponent>