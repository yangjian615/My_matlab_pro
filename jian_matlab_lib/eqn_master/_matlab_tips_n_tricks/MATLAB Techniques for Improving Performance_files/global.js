/* Code to all hover dropdown for IE6 - Currently used for country nav and top navigation dropdown */

//Conditional to put script in IE6 browsers
var isIE6 = (navigator.userAgent.toLowerCase().substr(25,6)=="msie 6") ? true : false;

if (isIE6 == true ) {

	// JS used to make 
	
	function sfHover(element_id) {
		  var sfEls = document.getElementById(element_id).getElementsByTagName("li");
		  for (var i=0; i<sfEls.length; i++) {
              sfEls[i].onmouseover=function() {
                 this.className+=" sfhover";
              }
              sfEls[i].onmouseout=function() {
                 this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
    	}
 	  }
	}
// Add the IDs that you want to use the hover function below - CSS must have a hover "sfhover" class too
	function sfStart() {
	  sfHover("countrynav");
	  sfHover("navbar");
	}
	if (window.attachEvent) window.attachEvent("onload", sfStart);
}

/* Pop-up Window */
function openWindow ( url, width, height, options, name ) {
  if ( ! width ) width = 640;
  if ( ! height ) height = 420;
  if ( ! options ) options = "scrollbars=yes,menubar=yes,toolbar=yes,location=yes,status=yes,resizable=yes";
  if ( ! name ) name = "outsideSiteWindow";
  var newWin = window.open( url, name, "width=" + width + ",height=" + height + "," + options );
} // end function openWindow

/* Print this Page */
function printWindow () {
   bV = parseInt(navigator.appVersion)
   if (bV >= 4) window.print()
} // end function printWindow


/* Onclick Omniture Code for Auto-Redirect testing */
/* REMOVED 6/25 - The onClick was removed from the global dropdown. 
To restart the test simply add onclick="addOmnitureCode('${item.code}')" 
back to the hyperlinks in the dropdown UL which can be found in /lib/user/pagelib.html
function addOmnitureCode(txt) {
	 var s =s_gi(s_account);  
	s.linkTrackVars='prop36';
//	s.linkTrackEvents='event56';
	
	s.prop36= domain + "_" + txt; //please pick appropriate value from the spreadsheet
	//s.events='event56';
	s.tl(this,'o','Redirects Cookie');
	
}
*/

/* Used in the dropdown menus for webinar pages in solution areas
If we change the code for those dropdowns, this should be removed */
function jumpMenu (targ,selObj,restore) { //v3.0
  eval(targ+".location='"+selObj.options[selObj.selectedIndex].value+"'");
  if (restore) selObj.selectedIndex=0;
} // end function jumpMenu

function clearTextOnFocus(){
    
	/* This is for clearing text in a text field on focus and add default text back on blur if applicable.  Simply add class 'clear_text_onfocus' to the element */
	/* If you need to clear text from this text field when the submit button is clicked, add 'clear_text_onsubmit' class to the submit button*/
	
    var clearMePrevious = "";
    
    // clear input on focus
    $(".clear_text_onfocus").focus(function() {
    	
    	if($(this).val()==$(this).attr('value')) {
    		
	    	clearMePrevious = $(this).val();
	    	$(this).val('');
	    	$(this).addClass('search_not_empty');
    	}
    });

    // if field is empty afterward, add text again
    $(".clear_text_onfocus").blur(function()
    {
    	if($(this).val()=='') {
    		
	    	$(this).val(clearMePrevious);
	    	$(this).removeClass('search_not_empty');
    	}
		
    });

    // prevent default text from being submitted on click of submit button 	
    $(".clear_text_onsubmit").on("click", function() {
    	var searchbox = $(".clear_text_onfocus");
		if(searchbox.val() == searchbox.attr('value')) {
	    	searchbox.val('');
    	} 
	});	
    
}



/* BEGIN Zebra stripping */
/* This adds classes of even and odd for datatables with the zebra class */ 

function addEvenOddClasses(){
  $(".zebra tbody tr:nth-child(even)").addClass("even");
  $(".zebra tbody tr:nth-child(odd)").addClass("odd");
}

/* END Zebra stripping */ 

/* 
  Workaround for the new way we change countries
  IE[6-8] don't send referrer information in the
  header unless the browser follows an anchor tag.

  This function writes an anchor tag with to the
  document and simulates a browser click.
*/
function redirectAsClickedLink(url) {
  if (/MSIE ([678].\d+);/.test(navigator.userAgent)){
    var referLink = document.createElement('a');
    referLink.href = url;
    document.body.appendChild(referLink);
    referLink.click();
  } 
  else {
    location.href = url;
  }
}


/* All jQuery calls - All the calls are in one document.ready call because more than one slows down the page */
$(document).ready(function(){


	/* BEGIN Rollover Delay */
	/* Top Navigation Rollover Delay - Works with jQuery hoverIntent - Add delay to top navigation and country navigation */

	$(".rollover_delay").addClass("inactive_state");						   
							   
	//On Hover Over
	function megaHoverOver(){
		$(this).addClass("active_state");
		$(this).removeClass("inactive_state");
	}
	//On Hover Out
	function megaHoverOut(){
		$(this).removeClass("active_state");
		$(this).addClass("inactive_state");
	}
	
	//Set custom configurations
	var config = {
		 sensitivity: 4, // number = sensitivity threshold (must be 1 or higher)
		 interval: 200, // number = milliseconds for onMouseOver polling interval
		 over: megaHoverOver, // function = onMouseOver callback (REQUIRED)
		 timeout: 500, // number = milliseconds delay before onMouseOut
		 out: megaHoverOut // function = onMouseOut callback (REQUIRED)
	};
	
	if ($.fn.hoverIntent) {
    $(".rollover_delay").hoverIntent(config); //Trigger Hover intent with custom configurations
	}

	/* END Rollover Delay */

	$(function(){
		clearTextOnFocus();
	    addEvenOddClasses();
	});


	/* BEGIN Toogle Content */
	/*This is for toggling content (expand/collapse) */	

	$(".toggle_content").hide(); 
  $(".toggle_container .toggle_selector").click(function(){
		$(this).toggleClass("active").next(".toggle_content").slideToggle("slow,");
	}); 
	
	/* END Toogle Content */

	/*
	 * Added for worldwide_countries_universal_list.html issue with hashes
	 * not getting carred over on domainRedirects
	 * Also written in popup_menu.js for classic
	 */
			//grab hash and encode it
			var hash = window.location.hash; 

			//if hash exists continue
			if(hash != null && hash != ""){
				$(".countrynav_container a").each(function(){
					//for each anchor get the href attribute and append any hashes
					var href = $(this).attr('href');
					$(this).attr('href' ,href + hash);
				});
			}

});
