<cfloop index="x" from="1" to="#fieldNumber#">
	<cfoutput>
	<input type="hidden" name="filePosition" id="filePosition" value="#x#">
	<li>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td><div align="center">#x#</div></td>
				<td>
				<label for="columnName">Column Name</label>
				<input name="columnName" id="columnName" type="text"></td>
				<td>
				  <div align="center">
				    <select name="columnType" id="columnType">
				      <option value="varchar">Select Column Type</option>
				      <option value="varchar">Varchar</option>
				      <option value="int">Int</option>
				      <option value="decimal">Decimal</option>
				      <option value="char">Char</option>
			          </select>
		          </div></td>
				<td><label for="columnLength">
				<div align="center">Column Length</div>
				</label>
				<input name="columnLength" type="text" id="columnLength" value="20" size="5" maxlength="11"></td>
				<td><div align="center">
				<select name="columnNull" id="columnNull">
					<option value="NULL">Null</option>
					<option value="NOT NULL">Not Null</option>
				</select></div>
				</td>
				
				<td><div align="center">
				<select name="columnKeyType" id="columnKeyType">
					<option value="0">No Index</option>
					<option value="1">Index</option>
				</select></div>
				</td>
				<td><div align="center">
				<select name="tablePrimary" id="tablePrimary">
					<option value="0">Not Primary</option>
					<option value="1">PRIMARY</option>
					<option value="2">PRIMARY - Auto Increment</option>
				</select></div>
				</td>
			</tr>
		</table>
	</li>
	</cfoutput>
</cfloop>