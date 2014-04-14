<cfquery name="Clients" datasource="#Request.mydns1#">
SELECT clientID, clientName
	FROM clients
	ORDER BY clientName
</cfquery>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />

        <!-- Always force latest IE rendering engine (even in intranet) & Chrome Frame
        Remove this if you use the .htaccess -->
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<cfheader
	name="x-powered-by"
	value="#Server.ColdFusion.ProductVersion#"
	/>
<cfheader name="Cache-Control" value="no-cache">
<cfheader name="Expires" value="0">

	
<link href="assets/images/favicon.ico" rel="shortcut icon">

<title>Account Numbers</title>

<link rel="stylesheet" href="assets/css/accounts.css" type="text/css">

<link href="assets/lib/jQueryUI/1.10.1/themes/cupertino/jquery-ui.min.css" rel="stylesheet" type="text/css" />
<link href="assets/lib/jQueryPluggins/jquery-layout/1.3.0/layout-default-latest.css" rel="stylesheet" type="text/css" />
<link href="assets/lib/plupload-2.0.0/js/jquery.ui.plupload/css/jquery.ui.plupload.css" rel="stylesheet" type="text/css" />
<link href="//cdnjs.cloudflare.com/ajax/libs/datatables/1.9.4/css/jquery.dataTables.min.css" rel="stylesheet" type="text/css">
<link type="text/css" rel="stylesheet" href="assets/lib/jQueryPluggins/jqGrid/4.5.2/css/ui.jqgrid.css" />
<script src="assets/lib/jQuery/jquery-1.10.1.min.js" type="text/javascript"></script>
<script src="assets/lib/jQueryUI/1.10.1/jquery-ui-1.10.1.custom.min.js" type="text/javascript"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-layout/1.3.0/jquery.layout-latest.min.js"></script>

<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-layout/1.3.0/jquery.layout.resizeTabLayout-1.3.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-layout/1.3.0/jquery.layout.resizePaneAccordions-1.2.min.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jquery-json/jquery.json-2.3.min.js"></script>
<script type="text/javascript" src="assets/lib/plupload-2.0.0/js/plupload.full.min.js"></script>
<script type="text/javascript" src="assets/lib/plupload-2.0.0/js/jquery.ui.plupload/jquery.ui.plupload.js"></script>
<script type="text/javascript" src="assets/lib/jQueryUI/1.10.1/Super-Theme-Switcher/jquery.themeswitcher.min.js"></script>
<script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/datatables/1.9.4/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jqGrid/4.5.2/js/i18n/grid.locale-en.js"></script>
<script type="text/javascript" src="assets/lib/jQueryPluggins/jqGrid/4.5.2/js/jquery.jqGrid.min.js"></script>
	
<script>
	//JQuery Plugin that will take a form, serialize it's field values, then create a JSON object of the array
(function( $ ){
	$.fn.serializeJSON=function() {
		var json = {};
		jQuery.map($(this).serializeArray(), function(n, i){
			(json[n['name']] === undefined) ? json[n['name']] = n['value'] : json[n['name']] += ',' + n['value'];
		});
		return json;
	};
})( jQuery );

/*
	 *	Utility methos used for UI Theme Selector
	 */
	function toggleCustomTheme () {
		$('body').toggleClass('custom');
		resizePageLayout();
	};

		/*
			Dashboard layout configuration
		*/
function resizePageLayout () {
		var pageLayout = $("body").data("layout");
		if (pageLayout) pageLayout.resizeAll();
	};
	
	
 $(function(){
	var addClient = function() {
		
		var clientList = $("#clientList");
		var clientName = $("input#clientName").val();
		var oscTableName = $("input#oscTableName").val();
		var clientNumber = $("input#clientNumber").val();
		var dataString = 'clientname='+ clientName + '&oscTableName=' + oscTableName + '&clientNumber=' + clientNumber;
	
	//First, do a statuc message
        clientList.html('<img src="/assets/icons/loaders/blue_bar_circle.gif" align="absmiddle">');

		
	$.ajax({
	type: "get",
	url: "com/clientFunctions.cfc?method=addClients&returnformat=plain",
	data: dataString,
	cache: false,
	success: function(msg){
		
		if (msg == '') {
			$("#clientList").html("Sorry, an error has occurred and the file was not created.");
		}
		else {
			$("#clientList").html(msg);
			$('input#clientName').val('');
			$('input#oscTableName').val('');
			$('input#clientNumber').val('');
		}
	
  }
 }) 

$( this ).dialog( "close" );
		
	}
	var cancel = function() {
		$( this ).dialog( "close" );
	}
	var addNewClientOpts = {
		buttons: {
		"OK": addClient,
		"Cancel": cancel
		},
		autoOpen: false,
		height: 350,
		width: 450,
		modal: true,
		show: {
		effect: "blind",
		duration: 1000
		},
		hide: {
		effect: "explode",
		duration: 1000
		}
	};
	$("#endDays").datepicker({
		showOn: 'button',
		buttonImage: '/assets/icons/small/calendar-day.png',
		buttonImageOnly: true,
		dateFormat: 'mm/dd/yy'
	})
	
	$("#addNewClient").dialog(addNewClientOpts);
	$( "#addClient" ).button().click(function() {
		$( "#addNewClient" ).dialog( "open" );
		
	});
});		

/*
	 *	Define options for all the layouts
	 */

	var pageLayoutOptions = {
		name:					'pageLayout' // only for debugging
	,	resizeWithWindowDelay:	250		// delay calling resizeAll when window is *still* resizing
	//,	resizeWithWindowMaxDelay: 2000	// force resize every XX ms while window is being resized
	//,	resizable:				false
	//,	slidable:				false
	//,	closable:				false
	,	north__paneSelector:	"#outer-north"
	,	center__paneSelector:	"#outer-center" 
	,	south__paneSelector:	"#outer-south" 
	,	west__paneSelector:		"#outer-west"
	,	south__spacing_open:	0
	,	north__spacing_open:	0
	,	west__spacing_open:		0
	,	west__togglerLength_open: 0
	,	west__fxSettings:		{ direction: "up" }
	,	west__trackMouseWhenSliding: false // so doesn't immediately close when using Toggle-Slide button
	,	west__fxSpeed_open:			500
	,	west__fxSpeed_close:		1000
	,	autoBindCustomButtons:	true
	,	west__initClosed:	true
	
	//	add a child-layout inside the center-pane
	,	center__children: {
			name:					'tabsContainerLayout'
		//,	resizable:				false
		//,	slidable:				false
		//,	closable:				false
		,	north__paneSelector:	"#tabbuttons"
		,	center__paneSelector:	"#tabpanels" 
		,	spacing_open:			0
		,	center__onresize:		$.layout.callbacks.resizeTabLayout // resize ALL visible layouts nested inside
		}
	};


	//	define sidebar options here because are used for BOTH east & west tab-panes (see below)
	var sidebarLayoutOptions = {
		name:					'sidebarLayout' // only for debugging
	,	showErrorMessages:		false	// some panes do not have an inner layout
	,	resizeWhileDragging:	true
	,   north__size:			"30%"
	,   south__size:			"40%"
	,	minSize:				100
	,	center__minHeight:		100
	,	spacing_open:			10
	,	spacing_closed:			10
	,	contentSelector:		".ui-widget-content"
	,	togglerContent_open:	'<div class="ui-icon"></div>'
	,	togglerContent_closed:	'<div class="ui-icon"></div>'
	};

	//	options used for the tab-panel-layout on all 3 tabs
	var tabLayoutOptions = {
	//	name:					'tabPanelLayout' // only for debugging
		resizeWithWindow:		false	// required because layout is 'nested' inside tabpanels container
	//,	resizeWhileDragging:	true	// slow in IE because of the nested layouts
	,	resizerDragOpacity:		0.5
	,	north__resizable:		true
	,	south__resizable:		true
	,	north__closable:		true
	,	south__closable:		true
	,	west__minSize:			200
	,	east__minSize:			425
	,	center__minWidth:		300
	,	spacing_open:			10
	,	spacing_closed:			10
	,	contentSelector:		".ui-widget-content"
	,	togglerContent_open:	'<div class="ui-icon"></div>'
	,	togglerContent_closed:	'<div class="ui-icon"></div>'
	,	triggerEventsOnLoad:	true // so center__onresize is triggered when layout inits
	,	center__onresize:		$.layout.callbacks.resizePaneAccordions // resize ALL Accordions nested inside
	,	west__onresize:			$.layout.callbacks.resizePaneAccordions // ditto for west-pane
	/*
	,	center__onresize: function (pane, $Pane) {
			$Pane.find(":ui-accordion").accordion("resize");
		}
	*/

	//	add child-layouts for BOTH the east/west panes (sidebars)
	//	sidebarLayoutOptions was created above so they could be used twice here
	,	west__children:		sidebarLayoutOptions
	,	east__children:		sidebarLayoutOptions
	};


$(document).ready( function() {
	// create the page-layout, which will ALSO create the tabs-wrapper child-layout
		var pageLayout = $("body").layout( pageLayoutOptions ); 

		// init the tabs inside the center-pane
		// NOTE: layout.center = NEW pane-instance object
		pageLayout.center.pane
			.tabs({
				// using callback addon
				activate: $.layout.callbacks.resizeTabLayout

				/* OR using a manual/custom callback
				activate: function (evt, ui) {
					var tabLayout = $(ui.newPanel).data("layout");
					if ( tabLayout ) tabLayout.resizeAll();
				}*/
			})
			// make the tabs sortable
			.find(".ui-tabs-nav") .sortable({ axis: 'x', zIndex: 2 }) .end()
		;
		// after creating the tabs, resize the tabs-wrapper layout...
		// we can access this layout as a 'child' property of the outer-center pane
		pageLayout.center.children.tabsContainerLayout.resizeAll();

		// init ALL the tab-layouts - all use the same options
		// layout-initialization will _complete_ the first time each layout becomes 'visible'
		$("#tab1").layout( tabLayoutOptions );
		$("#tab2").layout( tabLayoutOptions );
		$("#tab3").layout( tabLayoutOptions );
		

		// init inner-tabs inside outer-tab #3
		$("#innerTabs").tabs({
			// look for and resize inner-accordion(s) each time a tab-panel is shown
			activate: $.layout.callbacks.resizePaneAccordions
		});

		// init ALL accordions (all have .accordion class assigned)
		// accordions' 'height' will be reset as each becomes 'visible'
		$(".accordion").accordion({ heightStyle: "fill" });
		
jQuery("#accountsAddedGrid").jqGrid({
		datatype: function(postdata2) {
        jQuery.ajax({
           url: 'com/accounts.cfc',
			data: $.extend(true, {}, postdata2),
			method:'POST',
			dataType:"json",
			complete: function(jsondata2,stat2)

			{ if(stat2=="success") {

			var thegrid2 = jQuery("#accountsAddedGrid")[0];

		thegrid2.addJSONData(eval("("+jsondata2.responseText+")"))

			}

		}

	});

}
		,
	
		width:650,
		height: 350,
		loadui: 'block',
		altRows: true,
		deepempty: true,
		
		pager:'#accountsAddedPager',
		toppager: true,
		//pagerpos:'left',
		
		//toolbar:[true,"top"],
		
		rowNum:20,
		rowList:[10,20,30,40,50],
		viewrecords: true,
		rownumbers: true,
		//loadonce: true,
		gridview: true,
		rownumWidth: 40,
		sortname: 'dateAdded',
		sortorder: 'desc',
		
		colModel: [
			
						
					
					{name:'accountNumber', hidden:false, key: true, label: 'Account Number'},
					{name:'zipCode', hidden:false, key: true, label: 'Zip Code'},
					{name:'clientNummber', hidden:false, key: true, label: 'Client Number'},
					{name:'dateAdded', hidden:false, key: true, label: 'dateAdded'}	
		],
		
		prmNames:{page:"pageIndex",sort:"sortCol",order:"sortDir",rows:"pageSize"},
		postData:{method:"getManualAccounts",returnFormat:"JSON"},
		jsonReader: {
			id: "accountNumber", // function(obj){return $.inArray("ID",obj.data.COLUMNS);}, *not yet, but I'm working on it*
			root: "data.DATA",
			page: "pageIndex",
			total: "pageCount",
			records: "recordCount",
			cell:""
		},
		onSelectRow: function(id){
			var fileSelect = $("#fileSelect");	
			
			
			//First, do a statuc message
        fileSelect.html('<div align="center"><p>&nbsp;</p><img src="assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');
		
	
		$( "#fileSelect" ).load( "ajaxPages/fileViewer.cfm", { accountNumber: id } );
		
		}
	});
	
	
	jQuery("#accountsAddedGrid").jqGrid('navGrid','#accountsAddedPager', {edit:false,add:false,del:false}, {}, {}, {}, {multipleSearch:false, multipleGroup:false, showQuery: false,
	sopt: ['eq','cn','bw','ew','ne','lt','le','gt','ge']
	
	} );
		
		
		// Initialize the widget when the DOM is ready
	$(function() {
		$("#uploader").plupload({
			// General settings
			runtimes : 'html5,flash,silverlight,html4',
			url : 'file_upload.cfm',

			// User can upload no more then 20 files in one go (sets multiple_queues to false)
			max_file_count: 20,
			
			chunk_size: '1000mb',
			unique_names: true,

			// Resize images on clientside if we can
			resize : {
				width : 200, 
				height : 200, 
				quality : 90,
				crop: true // crop to exact dimensions
			},
			
			filters : {
				// Maximum file size
				max_file_size : '1000mb',
				// Specify what files to browse for
				mime_types: [
					{title : "Image files", extensions : "jpg,gif,png"},
					{title : "Zip files", extensions : "zip"},
					{title : "PDF Files", extensions : "pdf"},
					{title : "Text files", extensions : "txt,csv"},
					{title : "Office files", extensions : "doc,docx,xls,xlsx"}
				]
			},

			// Rename files by clicking on their titles
			rename: true,
			
			// Sort files
			sortable: true,

			// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
			dragdrop: true,

			// Views to activate
			views: {
				list: true,
				thumbs: true, // Show thumbs
				active: 'thumbs'
			},

			// Flash settings
			flash_swf_url : 'assets/lib/plupload-2.0.0/js/Moxie.swf',

			// Silverlight settings
			silverlight_xap_url : 'assets/lib/plupload-2.0.0/js/Moxie.xap'
		});


		// Handle the case when form was submitted before uploading has finished
		$('#uploadForm').submit(function(e) {
			// Files in queue upload them first
			if ($('#uploader').plupload('getFiles').length > 0) {

				// When all files are uploaded submit form
				$('#uploader').on('complete', function() {
					$('#form')[0].submit();
				});

				$('#uploader').plupload('start');
			} else {
				alert("You must have at least one file in the queue.");
			}
			return false; // Keep the form from submitting
		});
	});
		
}); //End of document ready

$(function() {
	 $( "#uploadFW" ).dialog({
	 autoOpen: false,
	 height: 500,
	 width: 800,
	 show: {
	 effect: "blind",
	 duration: 1000
	 },
	 hide: {
	 effect: "explode",
	 duration: 1000
	 }
	 });
	 $( "#uploadWindow" ).button().click(function() {
	 $( "#uploadFW" ).dialog( "open" );
	 
	 });
}); 	//End of upload dialog

$(document).ready(function(){
 $("#switcher").themeswitcher({
    			imgpath: "assets/lib/jQueryUI/1.10.1/Super-Theme-Switcher/images/",
    			loadTheme: "cupertino"
    		});
});

$(document).ready(function() {
	
	 $( "div.some-class" ).click(function() {
	 	var clientTables = $("#clientTables");
	 	var theID = $(this).attr("data-target");
		//First, do a statuc message
       clientTables.html('<div align="center"><img src="assets/icons/loaders/blue_bar_circle.gif" align="absmiddle"></div>');		
	 	$( "#clientTables" ).load( "ajaxPages/clientTables.cfm", { clientID: theID });
		
		
		
	 }); 
});	

$(function() {
    $( document ).tooltip({
      position: {
        my: "center bottom-20",
        at: "center top",
        using: function( position, feedback ) {
          $( this ).css( position );
          $( "<div>" )
            .addClass( "arrow" )
            .addClass( feedback.vertical )
            .addClass( feedback.horizontal )
            .appendTo( this );
        }
      }
    });
  });

/*$(document).ready(function() {
	$('#search').dataTable( {
		"aaSorting": [[ 4, "desc" ]]
	} );
} );*/

</script>		
<style>
  .ui-tooltip, .arrow:after {
    background: black;
    border: 2px solid white;
  }
  .ui-tooltip {
    padding: 10px 20px;
    color: white;
    border-radius: 20px;
    font: bold 14px "Helvetica Neue", Sans-Serif;
    text-transform: uppercase;
    box-shadow: 0 0 7px black;
  }
  .arrow {
    width: 70px;
    height: 16px;
    overflow: hidden;
    position: absolute;
    left: 50%;
    margin-left: -35px;
    bottom: -16px;
  }
  .arrow.top {
    top: -16px;
    bottom: auto;
  }
  .arrow.left {
    left: 20%;
  }
  .arrow:after {
    content: "";
    position: absolute;
    left: 20px;
    top: -20px;
    width: 25px;
    height: 25px;
    box-shadow: 6px 5px 9px -9px black;
    -webkit-transform: rotate(45deg);
    -moz-transform: rotate(45deg);
    -ms-transform: rotate(45deg);
    -o-transform: rotate(45deg);
    tranform: rotate(45deg);
  }
  .arrow.top:after {
    bottom: -20px;
    top: auto;
  }
  
  .image_container{
                width:325px;
                height:35px;
                padding:5px;              
                background-color:#f7f7f7;
                border:1px solid #ccc;
                -moz-box-shadow: 0 1px 3px #777;
                -webkit-box-shadow: 0 1px 3px #777;
                margin: 0 auto;
            }           
            .transparent{
                opacity: 1.0;
            }
            ul.toolbar{
                position:relative;
                width:325px;
                height:32px;
                margin:0px;
                padding:0px;
                background-color:#fff;
                border-bottom:2px solid #ccc;
                list-style-type:none;				
            }
            ul.toolbar li{
                display:inline;                            
            }
            ul.toolbar li div, .navigation div{ 
                float:left;
                cursor:pointer;
                width:70px;
                height:32px;
                opacity: 0.6;
            }		
            ul.toolbar li div:hover, .navigation div:hover{                
                opacity: 1.0;
            }
			 ul.toolbar li a, .navigation a{ 
                float:left;
                cursor:pointer;
                width:70px;
                height:32px;
                opacity: 0.6;
            }		
            ul.toolbar li a:hover, .navigation a:hover{                
                opacity: 1.0;
            }
			div.tableadd{
                background:#fff url(assets/icons/large/table_add.png) no-repeat center center;
            }
			div.tablecopy{
                background:#fff url(assets/icons/large/table_multiple.png) no-repeat center center;
            }
			a.search{
                background:#fff url(assets/icons/large/search_accounts.png) no-repeat center center;
            }
            a.addAcct{
                background:#fff url(assets/icons/large/table_row_insert.png) no-repeat center center;
            }
            a.details{
                background:#fff url(assets/icons/large/folder_table.png) no-repeat center center;
            }
			a.empty{
                background:#fff url(assets/icons/large/table_refresh.png) no-repeat center center;
            }
			
  </style>	
		
</head>
<body>
<DIV id="page-loading">Loading...</DIV>
	<!-- Start outer layout -->
<!---<div id="outer-north"> <!-- North Outer Layout -->
	North
</div>---> <!-- End North Outer Layout -->
<div id="outer-south" class="hidden">
	<button id="btnToggle" class="ui-layout-button-toggle-west" layoutName="pageLayout"><img src="assets/icons/large/widgets.png" ></button>
	<div class="message">Your files were created.</div>
</div>
<div id="outer-west" class="hidden">
	<div id="switcher"></div>
<p>	
	<div class="toolbar ui-widget-content ui-state-active">Add or Delete</div>
		 <p>
		<button id="addClient">Add New Client</button><br></p>
		<button id="uploadWindow">Upload Files</button><br></p>
		
  </p>		
   
</div>
<div id="outer-center" class="hidden">
	<!-- Majority of content goes inside this div -->
				<!-- Main Dash Tabs -->
	<ul id="tabbuttons" class="hidden">
		<li class="tab1"><a href="#tab1">Clients</a></li>
		<li class="tab2"><a href="#tab2">Groups</a></li>
		<li class="tab3"><a href="#tab3">Accounts Added</a></li>
	</ul>
				<!-- End Main Dash Tabs -->	
				<!-- Main Dash Tab Panels -->
				<div id="tabpanels">
					<!-- Main Tab 1 -->
						<div id="tab1" class="tab-panel hidden">	
					<!-- Start First Inner Layout -->
		<!-- Start North Inner Layout -->	
		<div class="ui-layout-north ui-widget">
				<!-- Toolbar - Utility Name --><div class="toolbar ui-widget-content ui-state-active">
					Clients
				</div><!-- End Toolbar - Utility Name -->
			</div>
					<!-- End North Inner Layout -->
				<!-- Start South Inner Layout -->
			<!---<div class="ui-layout-south ui-widget">
				<div class="toolbar ui-widget-content ui-state-default">
					<div class="message">Your files were created.</div>
				</div>
			</div>--->
				<!-- End South Inner Layout -->	
				<!-- Inner Center -->
				<div class="ui-layout-center">
					
<div id="clientList">
 
 <cfset getTheReturn = Request.Clients.getClientsList() />
	
	<ul>
		<cfoutput query="getTheReturn">
		<li><div id="#getTheReturn.clientID#" class="some-class" data-target="#getTheReturn.clientID#" title="Click to see details.">
    				#getTheReturn.clientName#
			</div></li>
		</cfoutput>
	</ul>
 
</div> <!-- End of clientList div -->
		
				</div>
				<div class="ui-layout-east">
				
	<div class="ui-layout-center">
		<!---<div class="ui-widget-header ui-corner-top">Client Tables</div>--->
		
		<div id="clientTables"></div>
		
  		
   </div>
	<div class="ui-layout-south"> 
		
		<p><div id="tableInfo"></div></p>
	</div>
</div>
				<!-- End Inner Center -->	
						</div> <!-- End Tab1 -->
						<!-- Main Tab 2 -->
						<div id="tab2" class="tab-panel hidden">	
					<!-- Start First Inner Layout -->
		<!-- Start North Inner Layout -->	
		<div class="ui-layout-north ui-widget">
				<!-- Toolbar - Utility Name --><div class="toolbar ui-widget-content ui-state-active">
					Groups
				</div><!-- End Toolbar - Utility Name -->
			</div>
					<!-- End North Inner Layout -->
				<!-- Start South Inner Layout -->
			<!---<div class="ui-layout-south ui-widget">
				<div class="toolbar ui-widget-content ui-state-default">
					<div class="message">Your files were created.</div>
				</div>
			</div>--->
				<!-- End South Inner Layout -->	
				<!-- Inner Center -->
				<div class="ui-layout-center">
				
				</div>
				<div class="ui-layout-east">
				
	<div class="ui-layout-center">
		
  		
   </div>
	<div class="ui-layout-south">  
		
		
		
	</div>
</div>
				<!-- End Inner Center -->	
						</div> <!-- End Tab2 -->
						<!-- Main Tab 3 -->
						<div id="tab3" class="tab-panel hidden">	
					<!-- Start First Inner Layout -->
		<!-- Start North Inner Layout -->	
		<div class="ui-layout-north ui-widget">
				<!-- Toolbar - Utility Name --><div class="toolbar ui-widget-content ui-state-active">
					Accounts Added
				</div><!-- End Toolbar - Utility Name -->
			</div>
					<!-- End North Inner Layout -->
				<!-- Start South Inner Layout -->
			<!---<div class="ui-layout-south ui-widget">
				<div class="toolbar ui-widget-content ui-state-default">
					<div class="message">Your files were created.</div>
				</div>
			</div>--->
				<!-- End South Inner Layout -->	
				<!-- Inner Center -->
				<div class="ui-layout-center">
			<div id="gridBlock">
				<div id="gridCont" class="gridCont">
					<table id="accountsAddedGrid" class="gTable"></table>
					<div id="accountsAddedPager" class="gTable"></div>
				
				</div><br clear="all" />
			</div>
				</div>
				<div class="ui-layout-east">
				
	<div class="ui-layout-center">
		<div id="fileSelect"></div>
  		
   </div>
	<!---<div class="ui-layout-south">  
		
		
		
	</div>--->
</div>
				<!-- End Inner Center -->	
						</div> <!-- End Tab2 -->
						
						
						
				</div><!-- End tabpanels -->
</div>

<!--- Dialogs --->
	<!-- File Upload Dialog -->
	<div id="uploadFW" title="Upload Files">
	
	<p> <form id="uploadForm" method="post">
	<div id="uploader">
		<p>Your browser doesn't have Flash, Silverlight or HTML5 support.</p>
	</div>
	<br />
	<!--- <input type="submit" value="Submit" /> --->
</form> </p>
	
	</div>
	
	<!--- Add Client Dialog --->
	<div id="addNewClient" title="Add New Client">
		<p>
	<form action="" name="newClientForm" id="newClientForm">
	<fieldset>
			<label for="clientName">Client Name</label> <input type="text" name="clientName" id="clientName"><br>
			<label for="clientNumber">Client Number</label> <input name="clientNumber" id="clientNumber" type="text"><br>
			<label for="oscTableName">Validation Table Name</label> <input name="oscTableName" id="oscTableName" type="text"><br>
	</fieldset>
		</form>
		</p>	
	</div>
	
	
</body>
</html>	