<p><form action="addAccount.cfm" name="oscForm" method="post" enctype="multipart/form-data">
	<fieldset>
			
					<label for="accountNumber">Account Number:</label><br />
					<input type="text" name="accountNumber" id="accountNumber"><br>
					
					<label for="zipCode">Zip Code:</label><br />
					<input type="text" name="zipCode" id="zipCode" /><br>
					
					<label for="billFile">Copy of Bill:</label><br />
					<input type="file" name="billFile" id="billFile" />
					<cfoutput><input type="hidden" name="clientID" id="clientID" value="#clientID#" /></cfoutput>
				
			
			</fieldset>
		<fieldset class="submit">
	
		<input type="submit" name="addOsC" value="Add">
		</fieldset>
</form></p>