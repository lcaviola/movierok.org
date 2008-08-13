var ap_update_interval = 200; // milliseconds to next update
var ap_preload_distance_from_bottom = 300; // pixels from button to next getmore
var ap_page = ""; // file to request
var ap_additional_parameters = "";
var ap_nextpage = 2;
var ap_total_pages;
var ap_timer;
var ap_is_updating = false
var ap_rp = null
var ap_rips = null


/*
 * Arguments:
 * 1 - page
 * 2 - total pages
 * Optional:
 * 3 - next pagenumber - default: 2
 * 4 - preloadDistanceFromButtom - default: 20
 * 5 - additionalGet - default:''
 */
function append_auto_pagnation(page, total_items){
    if(arguments.length > 2){
        ap_nextpage = arguments[2]
    }
    if (arguments.length > 3) {
        ap_preload_distance_from_bottom = arguments[3]
    }
    if (arguments.length > 4) {
        ap_additional_parameters = "&"+arguments[4]
    }
    ap_page = page;
    ap_total_pages = Math.ceil(total_items / 30)
    ap_rp = $('rips_box')
    ap_rips = $('rips')
    ap_timer = window.setInterval("updatePage()", ap_update_interval);
}

function get_more_content() {
    var params = "page=" + ap_nextpage + ap_additional_parameters;
    if (ap_nextpage <= ap_total_pages) {
        new Ajax.Request(ap_page, {asynchronous:true, method: 'get',
            onComplete: add_more_content, onFailure: failure, parameters: params});
    }
}

function failure() {
    ap_rb.innerHTML = "<p><strong>Could not contact the server.</strong><br />Please wait awhile and try again. <br /><br />We apologize for the inconvenience.</p>";
}

function add_more_content(ajax){
    response = ajax.responseText
    //ap_rips.innerHTML += response
    $(ap_rips).insert(response)
    if (ap_nextpage == parseInt(ap_total_pages)) {
        window.clearInterval(ap_timer);
    }
    ap_nextpage +=  1;
    $('loaded_rips_count').update(ap_rips.childElements().length)
    
    ap_is_updating = false
}

function updatePage(){
    if (!ap_is_updating && calc_distance()  < ap_preload_distance_from_bottom) {
        ap_is_updating = true
        get_more_content()
    }
}

function calc_distance(){
    return (ap_rp.scrollHeight - ap_rp.scrollTop) - ap_rp.offsetHeight + 2
}
