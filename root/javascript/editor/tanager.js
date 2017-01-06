var keyCounter=0;
var autoSaveInterval=300000   // in milliseconds. default = 5 minutes.
var intervalID=0;
var prevLength=0;
var currLength=0;
var isFocus=0;

function countKeyStrokes () {
    keyCounter++;    
}


document.addEventListener("DOMContentLoaded", function() {

//    jQuery( window ).bind( 'resize', sync_panels ).trigger( 'resize' );

    window.onresize = sync_panels;

    var handler = window.onresize;
    handler();

    onkeydown = function(e){
        if(e.ctrlKey && e.keyCode == 'P'.charCodeAt(0)){
        //  if(e.ctrlKey && e.shiftKey && e.keyCode == 'P'.charCodeAt(0)){
            e.preventDefault();
            previewPost();
        }

        if(e.ctrlKey && e.keyCode == 'S'.charCodeAt(0)){
            e.preventDefault();
            keyCounter++; // force a save even if no editing occurred since user clicked the save link.
            savePost();
        }

        if(e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)){
            e.preventDefault();
            singleScreenMode();
        }

        // bare minimum view. large textarea box only. no border. no nav bar. no other links. no buttons.
        if(e.ctrlKey && e.keyCode == 'J'.charCodeAt(0)){
            e.preventDefault();
            // document.getElementsByTagName('body')[0].style.background = "#fff";
            document.body.style.background = "#fff";
            document.getElementById('navmenu').style.display = "none";
            document.getElementById('tx_input').style.background = "#fff";
            document.getElementById('tx_input').style.border = "none";
            document.getElementById('tx_input').style.color = "#222";
            document.getElementById('col_left').style.padding = "1em 0 0 0";
            singleScreenMode();
        }

        // display a 5-line text area box
        if(e.ctrlKey && e.keyCode == 'H'.charCodeAt(0)){
            e.preventDefault();
            document.body.style.background = "#fff";
            document.getElementById('navmenu').style.display = "none";
            document.getElementById('tx_input').style.background = "#fff";
            document.getElementById('tx_input').style.border = "none";
            document.getElementById('tx_input').style.color = "#222";
            document.getElementById('tx_input').style.height = "150px";
            document.getElementById('tx_input').style.margin = "30% 0 0 0";
            document.getElementById('col_left').style.padding = "1em 0 0 0";

            isFocus=1;
            singleScreenMode();
        }

        if(e.ctrlKey && e.keyCode == 'B'.charCodeAt(0)){
            e.preventDefault();
            document.body.style.background = "#ddd";
            document.getElementById('navmenu').style.display = "inline";
            document.getElementById('tx_input').style.background = "#f8f8f8";
            document.getElementById('tx_input').style.border = "1px solid #bbb";
            document.getElementById('tx_input').style.color = "#222";
            document.getElementById('col_left').style.padding = "0";

            if ( isFocus ) {            
                document.getElementById('tx_input').style.margin = "0 0 0 0";
                document.getElementById('tx_input').style.height = "100%";

                ifFocus=0;
            }
            splitScreenMode();
        }

        if(e.ctrlKey && e.keyCode == 'D'.charCodeAt(0)){
            e.preventDefault();
            document.body.style.background = "#181818";
            document.getElementById('tx_input').style.background = "#181818";
            document.getElementById('tx_input').style.color = "#c0c0c0";
        }
    }

    // autosave every five minutes
    //    setInterval(function(){savePost()},300000); 
    intervalID = setInterval(function(){savePost()},autoSaveInterval); 


// ******************** 
// SINGLE-SCREEN MODE
// ******************** 

    document.getElementById('moveButton').onclick = singleScreenMode;

    function singleScreenMode () {
        fadeOut(document.getElementById('text_preview'));
        fadeIn(document.getElementById('tx_input')); // it seems this is unnecessary
        document.getElementById('col_left').className = "singlecol"; // change css class from "col" to "singlecol"
        document.getElementById('col_right').className = "col"; // change css class from "prevsinglecol" to "col"
        document.getElementById('col_right').style.cssFloat = "right";
        document.getElementById('col_right').style.position = "relative";
        document.getElementById('tx_input').focus();
    }


// ******************** 
// SPLIT-SCREEN MODE
// ******************** 

    document.getElementById('resetButton').onclick = splitScreenMode;

    function splitScreenMode () { 
        fadeIn(document.getElementById('tx_input'));
        fadeIn(document.getElementById('text_preview'));

        document.getElementById('col_left').className = "col"; // change css class from "singlecol" to "col"
        document.getElementById('col_right').className = "col"; // change css class from "prevsinglecol" to "col"

        document.getElementById('col_right').style.cssFloat = "right";
        document.getElementById('col_right').style.position = "relative";
        document.getElementById('tx_input').focus();
    }


// **********
// PREVIEW
// ********** 

    document.getElementById('previewButton').onclick = previewPost;

    function previewPost () { 
     
        var col_type = document.getElementById('col_left').className;

        var action  = document.getElementById('tanageraction').value;
        var cgiapp  = document.getElementById('tanagercgiapp').value;
        var apiurl  = document.getElementById('tanagerapiurl').value;        
        var postrev = document.getElementById('tanagerpostrev').value;

        var postid = 0;
        postid = document.getElementById('tanagerpostid').value;

        if ( col_type === "singlecol" ) { 
            document.getElementById('col_left').className = "col"; // change css class from "singlecol" to "col"

            fadeOut(document.getElementById('tx_input'));

            document.getElementById('col_right').className = "prevsinglecol"; // change css class from "col" to "prevsinglecol"

            document.getElementById('col_right').style.cssFloat = "normal";
            document.getElementById('col_right').style.position = "absolute";
            fadeIn(document.getElementById('text_preview'));
        } 

        var markup = document.getElementById('tx_input').value;

        var regex = /^autosave=(\d+)$/m;
        var myArray;
        if ( myArray = regex.exec(markup) ) {
            if ( myArray[1] > 0  &&  (myArray[1] * 1000) != autoSaveInterval ) {
                autoSaveInterval = myArray[1] * 1000; 
                clearInterval(intervalID);
                intervalID = setInterval(function(){savePost()},autoSaveInterval); 
            }
        }

        markup=escape(markup);

        var paramstr;

        var author_name  = getCookie('wrenauthor_name');
        var session_id   = getCookie('wrensession_id');
        var rev          = getCookie('wrenrev');

        var myRequest = {         // create a request object that can be serialized via JSON
            author:      author_name,
            session_id:  session_id,
            rev:         rev,
            submit_type: 'Preview',
            form_type:   'ajax',
            markup:      markup,
            original_slug:     postid,
        };

        var json_str = JSON.stringify(myRequest);       
  
        // may need to reference this for cors or cross domain posting
        // http://stackoverflow.com/questions/5584923/a-cors-post-request-works-from-plain-javascript-but-why-not-with-jquery
        // or at http://blog.garstasio.com/you-dont-need-jquery/ajax/#cors

        var request = new XMLHttpRequest();

        if ( postid > 0 ) {
            request.open('PUT', apiurl + '/posts', true);
        } else {
            request.open('POST', apiurl + '/posts', true);
        }

        request.withCredentials = true;
        request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');

        request.onload = function() {
            if (request.status >= 200 && request.status < 400) {
                var resp = request.responseText;
                var obj = JSON.parse(resp);
                if ( obj['post_type'] == "article" ) {
                    document.getElementById('text_preview').innerHTML = '<h1>' + obj['title'] + '</h1>' + obj['html'];
                } else {
                    document.getElementById('text_preview').innerHTML = obj['html'];
                }
            } else {
                // reached the target server, but it returned an error
                var resp = request.responseText;
                var obj = JSON.parse(resp);
                document.getElementById('text_preview').innerHTML = '<h1>Error</h1>' + obj['user_message'] + ' ' + obj['system_message'];
            }
        };

        request.onerror = function() {
            // There was a connection error of some sort
            document.getElementById('text_preview').innerHTML = '<h1>Server Connection Error</h1> Unable to connect to ' + apiurl + '/posts';
        };

        request.send(json_str);

    } // end preview post function


// **********
// SAVE
// ********** 

    document.getElementById('saveButton').onclick = forceSave;

    function forceSave () {
        keyCounter++;
        savePost();
    }

    function savePost () {
        var markup = document.getElementById('tx_input').value;

        currLength = markup.length;

        if ( keyCounter == 0 && currLength == prevLength ) {
            return;
        }
    
        prevLength = currLength; 
        keyCounter=0;
 
        var col_type = document.getElementById('col_left').className;

        var action  = document.getElementById('tanageraction').value;
        var cgiapp  = document.getElementById('tanagercgiapp').value;
        var apiurl  = document.getElementById('tanagerapiurl').value;
        var postid  = document.getElementById('tanagerpostid').value;
        var postrev = document.getElementById('tanagerpostrev').value;

        markup=escape(markup);

        var sbtype = "Create";

        if ( action === "updateblog" ) {
            sbtype = "Update";
        }

        var author_name  = getCookie('wrenauthor_name');
        var session_id   = getCookie('wrensession_id');
        var rev          = getCookie('wrenrev');


        var myRequest = {         // create a request object that can be serialized via JSON
            author:      author_name,
            session_id:  session_id,
            rev:         rev,
            submit_type: sbtype,
            form_type:   'ajax',
            markup:      markup,
            original_slug:     postid,
        };

        var json_str = JSON.stringify(myRequest);       

        var request = new XMLHttpRequest();

        if ( action === "updateblog" ) {
            request.open('PUT', apiurl + '/posts', true);
        } else {
            request.open('POST', apiurl + '/posts', true);
        }

        request.withCredentials = true;
        request.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');

        request.onload = function() {
            if (request.status >= 200 && request.status < 400) {
                var resp = request.responseText;
                var obj = JSON.parse(resp);
                if ( obj['post_type'] == "article" ) {
                    document.getElementById('text_preview').innerHTML = '<h1>' + obj['title'] + '</h1>' + obj['html'];
                } else {
                    document.getElementById('text_preview').innerHTML = obj['html'];
                }
                document.getElementById('saveposttext').style.color = "#000"; 
                // setTimeout(function() {$('#saveposttext').set({$color: '#f8f8f8'})}, 2000);
                setTimeout(function() {document.getElementById('saveposttext').style.color = "#f8f8f8"}, 2000);
                document.getElementById('tanageraction').value =   'updateblog';
                document.getElementById('tanagerpostid').value =   obj['slug'];
                document.getElementById('tanagerpostrev').value =  obj['rev']; 
            } else {
                // reached the target server, but it returned an error
                var resp = request.responseText;
                var obj = JSON.parse(resp);
                document.getElementById('text_preview').innerHTML = '<h1>Error</h1>' + obj['user_message'] + ' ' + obj['system_message'];
            }
        };

        request.onerror = function() {
            // There was a connection error of some sort
            document.getElementById('text_preview').innerHTML = '<h1>Server Connection Error</h1> Unable to connect to ' + apiurl + '/posts';
        };

        request.send(json_str);


    } // send save function

    function getCookie(c_name) {
        var c_value = document.cookie;
        var c_start = c_value.indexOf(" " + c_name + "=");
        if (c_start == -1) {
            c_start = c_value.indexOf(c_name + "=");
        }
        if (c_start == -1) {
            c_value = null;
        }
        else {
            c_start = c_value.indexOf("=", c_start) + 1;
            var c_end = c_value.indexOf(";", c_start);
            if (c_end == -1) {
                c_end = c_value.length;
            }
            c_value = unescape(c_value.substring(c_start,c_end));
        }
        return c_value;
    }

    function sync_panels () {
        var col = document.getElementById('col_left');
        var md  = document.getElementById('tx_input');
        // ???       var tally = jQuery('body > h1').outerHeight();
        var tally = null;
        var elements = col.children;

        [].forEach.call(elements, function(item) {
            tally += outerHeight(item);
        });

        var space = col.offsetHeight - ( tally - outerHeight(md) );

        document.getElementById('tx_input').style.height= space + "px";
        document.getElementById('text_preview').style.height= space + "px";
    }

    function outerHeight(el) {
        var height = el.offsetHeight;
        var style = getComputedStyle(el);
        height += parseInt(style.marginTop) + parseInt(style.marginBottom);
       return height;
    }


// http://www.chrisbuttery.com/articles/fade-in-fade-out-with-javascript/
// fade out

function fadeOut(el){
  el.style.opacity = 1;

  (function fade() {
    if ((el.style.opacity -= .1) < 0) {
      el.style.display = "none";
    } else {
      requestAnimationFrame(fade);
    }
  })();
}

// fade in

function fadeIn(el, display){
  el.style.opacity = 0;
  el.style.display = display || "block";

  (function fade() {
    var val = parseFloat(el.style.opacity);
    if (!((val += .1) > 1)) {
      el.style.opacity = val;
      requestAnimationFrame(fade);
    }
  })();
}

}); // end

