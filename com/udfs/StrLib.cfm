<!---
Turn a string into an array of lines.

@param inString      The string to parse. (Required)
@return Returns an array.
@author Massimo Foti (massimo@massimocorner.com)
@version 1, August 15, 2005
--->
<cffunction name="string2linesArray" output="false" returntype="array" hint="Turn a string into an array of lines, using java.io.BufferedReader to maximize performances">
    <cfargument name="inString" type="string" required="yes" hint="Incoming string">
    <cfscript>
    var linesArray = ArrayNew(1);
    var jReader = createObject("java","java.io.StringReader").init(arguments.inString);
    var jBuffer = createObject("java","java.io.BufferedReader").init(jReader);
    var line = jBuffer.readLine();    
    </cfscript>
    <cftry>
    <!---
    Unlike Java, CFML has no notion of null, but this is quite a special case.
    Whenever readLine() reach the end of the file, it return a Java null,
    as soon as the BufferedReader return null, ColdFusion "erase" the line variable, making it undefined.
    Here we leverage this somewhat weird behavior by using it as test condition for the loop
     --->
        <cfloop condition="#IsDefined("line")#">
            <cfset ArrayAppend(linesArray, line)>
            <cfset line=jBuffer.readLine()>
        </cfloop>
        <cfset jBuffer.close()>
        <cfcatch type="any">
            <!--- Something went wrong; we better close the stream anyway, just to be safe and leave no garbage behind --->
            <cfset jBuffer.close()>
            <cfthrow message="string2linesArray: Failed to read lines from string" type="string2linesArray">
        </cfcatch>
    </cftry>
    <cfreturn linesArray>
</cffunction>

<cffunction name="removeSymbols" hint="Converts MS-Windows superset characters (Windows-1252) into their XML friendly unicode counterparts" returntype="string">
	<cfargument name="value" type="string" required="yes">
	<cfscript>
		var string = value;
		string = replaceNoCase(string,chr(8218),'','all');	// ? 
		string = replaceNoCase(string,chr(402),'','all');		// ? 
		string = replaceNoCase(string,chr(8222),'','all');	// ? 
		string = replaceNoCase(string,chr(8230),'','all');	// ? 
		string = replaceNoCase(string,chr(8224),'','all');	// ? 
		string = replaceNoCase(string,chr(8225),'','all');	// ? 
		string = replaceNoCase(string,chr(710),'','all');		// ? 
		string = replaceNoCase(string,chr(8240),'','all');	// ? 
		string = replaceNoCase(string,chr(352),'','all');		// ? 
		string = replaceNoCase(string,chr(8249),'','all');	// ? 
		string = replaceNoCase(string,chr(338),'','all');		// ? 
		string = replaceNoCase(string,chr(8216),'','all');	// ? 
		string = replaceNoCase(string,chr(8217),'','all');	// ? 
		string = replaceNoCase(string,chr(8220),'','all');	// ? 
		string = replaceNoCase(string,chr(8221),'','all');	// ? 
		string = replaceNoCase(string,chr(8226),'','all');	// ? 
		string = replaceNoCase(string,chr(8211),'','all');	// ? 
		string = replaceNoCase(string,chr(8212),'','all');	// ? 
		string = replaceNoCase(string,chr(732),'','all');		// ? 
		string = replaceNoCase(string,chr(8482),'','all');	// ? 
		string = replaceNoCase(string,chr(353),'','all');		// ? 
		string = replaceNoCase(string,chr(8250),'','all');	// ? 
		string = replaceNoCase(string,chr(339),'','all');		// ? 
		string = replaceNoCase(string,chr(376),'','all');		// ? 
		string = replaceNoCase(string,chr(376),'','all');		// ? 
		string = replaceNoCase(string,chr(8364),'','all');		// ? 
	</cfscript>
	<cfreturn string>
</cffunction>
<cfscript>
/**
 * Highlights words in a string that are found in a keyword list.
 * v0.9 by Simon Bingham.
 * v1.0 by Adam Cameron. Improved regex and added configurable highlighting.
 * 
 * @param str 	 The string to highlight. (Required)
 * @param keywords 	 The list of keywords to highlight within the string. (Required)
 * @param highlight 	 A struct containing keys for tag and attributes, These are used to highlight the keyword. Defaults to an EM tag. (Required)
 * @return Returns the string  with the keywords highlighted. 
 * @author Simon Bingham (&#109;&#101;&#64;&#115;&#105;&#109;&#111;&#110;&#98;&#105;&#110;&#103;&#104;&#97;&#109;&#46;&#109;&#101;&#46;&#117;&#107;) 
 * @version 1.0, September 29, 2012 
 */
string function highlightKeywords(required string str, required string keywords, struct highlight){
	var keyword		= "";
	var replacement	= "";
	
	param name="highlight.tag"			default="em";
	param name="highlight.attributes"	default="";
	
	for (var index=1; index <= listLen( arguments.keywords ); index++){
		keyword = listGetAt(arguments.keywords, index);
		replacement = "<#highlight.tag#";
		if (len(highlight.attributes)){
			replacement &= " #highlight.attributes#";
		}
		replacement &= ">" & keyword & "</#highlight.tag#>";

		arguments.str = reReplaceNoCase( arguments.str, "\b#keyword#\b", replacement, "all" );
	}
	return arguments.str;
}
</cfscript>
<cfscript>
/**
 * Returns the passed string with all non-numbers removed (letters, punctuation, whitespace, etc.).
 * 
 * @param textStr 	 String containing numbers you want returned. 
 * @param allowDec 	 Boolean (yes/no) indicating whether to preserve decimal points.  Default is No. 
 * @return Returns a number. 
 * @author Mark Andrachek (&#104;&#97;&#108;&#108;&#111;&#119;&#64;&#119;&#101;&#98;&#109;&#97;&#103;&#101;&#115;&#46;&#99;&#111;&#109;) 
 * @version 1, December 18, 2001 
 */
function GetNumbers(textstr) {
  if (arraylen(arguments) GTE 2) { 
    return REReplace(textstr,"[^0-9\.]",'','ALL'); }
  else { 
    return REReplace(textstr,"[^0-9]",'','ALL');  }
}
</cfscript>