var rip_id = null
var selected_langs = []
var langs = [['de', 'german', 'deutsch', 'ger'], ['us', 'en', 'english','eng', 'englisch'], ['fr', 'french']]
var types = [['dvdrip', 'dvd'], ['cam', 'camrip'], ['telesync', 'ts'], ['screener', 'screen', 'scr', 'dvdscr'], ['r5'], ['telecine', 'tc'], ['workprint', 'wp']]
var no_movie_title_words = 'avi mpg mpeg www dvd dvdrip sample '+
'xvid divx rip com movie movies cd net ld th srtsxi extra extras sg '+
'german english ac en eng de neu new mkv mov by from screener domino up phorum izzy max cam camrip lmg '+
'xc kvcd tus tgf dmd ws lan lang language languages sub dvf ch gre jjh ct tdr kai rg dvdscr vite lrc widescreen dt org makingoff freshwap jaw '+
'div fmi hd hdtv special bb warez nedivx edition lfod telecine tdvc ts mov home cal uploaded edukators download downloads festival rcdivx ' +
'additional scene scenes sc xl ivx xvid@ min mp subtitle subtitles disc fg ii iii iv v vi vii fixed nodlabs team iafw posted tdvcb nbs hr vmt xvod imbt audio sound trashcan unrated promise dmc jamgood bestdivx ' +
'tc sm fxg unrated spielfilme telesync crew rsvcd svcd src shared  mrok media trunk hq tln gowenna rina ' +
'venomowns mvn encode md mvcd vcd aoe trailer tdvca stv tide traday part video videos videoz moviez '

var omdb_response = null

Event.observe(window, 'load', function() {
    if($('search')) {
        $('search').focus()
        //Event.observe('search_form', 'onsubmit', submit_search)

        adjust_rip_search_links()
        adjust_header()
        adjust_rip_list_links_with_covers()
        $('settings_link').href = '/users/' + name + '/edit'

        if($('rip_form')) {
            prepare_rip_forms()
            if($('toggle_samples'))
                toggle_samples()
        }
        if(is_logged_in())
           insert_extension_warning()
    
        init_stars('audio_rating')
        init_stars('video_rating')
        
        $$('#rip_form .select_box li').each(function(e) {
            e.onclick = toggle_lang
        })
    
        if(is_logged_in()) {
            $$('.only_when_logged_in').each(function(e) {
                e.removeClassName("only_when_logged_in")
            })
        } else {
            $$('.only_when_not_logged_in').each(function(e) {
                $(e).removeClassName("only_when_not_logged_in")
            })
        }
    
        if($('parts')) {
            Sortable.create('parts')
        }
    }
});


function init_advanced_search() {
    $$('#advanced_search .select_box ul li').each(function(e) {
        e.onclick = search_item_clicked
    })
}


function toggle_lang(event) {
    e = get_target(event)
    input = e.down('input')
    input.disabled = !input.disabled
    if(input.disabled) {
        e.removeClassName('enabled_lang')
        selected_langs[selected_langs.indexOf(e)] = null
    } else {
        e.addClassName('enabled_lang')
        selected_langs.push(e)
    }
}

function get_target(event) {
    if(event.target)
        return $(event.target)
    return $(event)
}

function search_item_clicked(e) {
    classNames = $w(e.target.className)
    value = get_value_from_class_name(e.target, 'paste-')
    if(!value)
        value = get_value_from_class_name(e.target, 'flag-')
    if(!value)
        value = e.target.innerHTML
    name = get_value_from_class_name(e.target.parentNode, 'search-')
    paste_to_search(name, value.toLowerCase())
}

function get_value_from_class_name(element, class_name) {
    classNames = $w(element.className)
    for(i = 0; i < classNames.length; i++) {
        if(classNames[i] && classNames[i].indexOf(class_name) != -1)
            return classNames[i].substr(class_name.length)
    }
    return null
}

function init_stars(class_name) {
    $$('.' +class_name).each(function(e) {
        e.onmouseover = select_star; e.onmouseout = unselect_star
    })
}

function select_star(e) {
    $(e.target).previousSiblings().each(function(s) {
        s.addClassName('selected_star')
    })
    $(e.target).addClassName('selected_star')
}
function unselect_star(e) {
    $(e.target).previousSiblings().each(function(s) {
        s.removeClassName('selected_star')
    })
    $(e.target).removeClassName('selected_star')
}

//document.documentElement.offsetHeight

Event.observe(window, 'resize', function() {
    resize_rips_box()
});

function resize_rips_box() {
    if($("rips_box")) {
        windowHeight = (Prototype.Browser.IE) ? document.documentElement.clientHeight : window.innerHeight
        $('rips_box').style.height = (windowHeight - 170) + 'px';
    }
}

function adjust_header() {
    if(is_logged_in()) {
        name = logged_in_as()
        $('my_rips_link').onclick = ''
        $('my_rips_link').href = '/users/' + name + '/rips'
        $('my_rips_link').title = 'show my rips'
    }
   
    if(is_logged_in() && document.location.href.indexOf($('my_rips_link').href) != -1)
        $$('#menu > li')[0].addClassName('selected_tab')
    else if(document.location.href.indexOf('/rips') != -1)
        $$('#menu > li')[1].addClassName('selected_tab')
       
    
    if(is_logged_in() && document.location.href.indexOf('/users/') != -1) {
        url = document.location.href
        name = url.substr(url.indexOf('/users/') + 7)
        name = name.substr(0, name.indexOf('/'))
        $('search_form').action = '/users/' + name + '/rips'
    }
}

function adjust_rip_search_links() {
    pos = document.location.href.indexOf('users')
    if(pos != -1) {
        name = document.location.href.substring(pos+6)
        if(name.indexOf('/') != -1){
            name = name.substring(0, name.indexOf('/'))
        }
        $$('.search_link').each(function(link) {
            tmp = link.href
            tmp = tmp.substring(0, tmp.indexOf('/rips'))
            tmp += '/users/' + name + '/rips'
            tmp += link.href.substring(link.href.indexOf('/rips') + 5,  link.href.length)
            link.href = tmp
        })
    }
}

function adjust_rip_list_links_with_covers() {
    if(Cookie.get('default_view') == 'covers') {
        $$('.rip_list_link').each(function(link){
            //link.href += '/covers'
            link.href = link.href.replace("/rips", "/rips/covers")
        })
        $('search_form').action += '/covers'
    }
}


// replaces all spaces with + and submits the search form
function submit_search() {
    query = $('search').value.replace(/[ ]/g, '+')
    document.location = $('search_form').action + '?search=' + query
}

function submit_omdb_search() {
    $('omdb_search_form').submit()
}

function remove_part(element) {   
    element.previous('.add_part_link').show()
    element.hide()
    
    element = $(element).up('.part').remove()
    $('unknown_parts').insert(element)
    
    Sortable.create('parts')
    
    if($('parts').empty()){
        $('rip_info').hide()
    // Effect.Fade('rip_info', {duration:0.3})
    }
    
    unselect_selected_rip_infos()
}


function add_part(element) {
    //$('rip_info').show()
    
    Effect.Appear('rip_info', {
        duration:0.3
    })
    
    element = $(element).up('.part').remove()
    
    $('parts').insert(element)
    
    
    element.down('.remove_part_link').show()
    element.down('.add_part_link').hide()
    Sortable.create('parts')
    insert_omdb_search_term(element)
}


function insert_omdb_search_term(element) {
    unselect_selected_rip_infos()
    if($(element).down('.filename')) {
        filename = $(element).down('.filename').childNodes[0].nodeValue.toLowerCase()
        filename = filename.replace(/\[(.*)\]/, ' ').replace(/\((.*)\)/, ' ')
        filename = filename.replace(/[\.\/\]\[\-_,]/g, ' ').replace(/\d/g, ' ')
        filename = filename.escapeHTML()
        filename = filename.replace(/&nbsp;/g, ' ')

        nmtw = no_movie_title_words + ' ' + releasers.toLowerCase()
        nmtw = nmtw.split(' ')
        filename = filename.split(' ')
  
        search_terms = []
        for(i = 0; i < filename.length; i++) {
            t = filename[i].replace(/^\s\s*/, '').replace(/\s\s*$/, '')
            t.replace(/\s+/g, '')
            filename[i] = null
            if(nmtw.indexOf(t) == -1) {
           
                if(filename.indexOf(t) == -1 && t.length > 1) {
                    search_terms.push(t)
                }
            }
            if(t == 'dvdrip') {
                $('rip_type_id').childElements()[1].selected = 'selected'
            }
        }
        search_terms = cleanup_term(search_terms)
        search_term = search_terms.join(' ')
        $('omdb_search_field').value = search_term.unescapeHTML()
        if($('omdb_search_form').hasClassName('new_part_added')) {
            $('omdb_search_form').removeClassName('new_part_added')
        } else {
            $('omdb_search_form').addClassName('new_part_added')
        }
        preselect_rip_info_from_filename($(element).down('.filename').childNodes[0].nodeValue.toLowerCase(), element)
    }
}

function cleanup_term(terms) {
    new_terms = []
    to_remove = []
    for(i = 0; i < terms.length; i++) {
        t = terms[i]

        if(t.length > 3) {
            for(j = 0; j < terms.length; j++) {
                t2 = terms[j]
                if(j != i && t2.indexOf(t) != -1) {
                    to_remove.push(j)
                }
            }
        }
        

        shorthand = ''
        for(j = 0; j < terms.length; j++) {
            t2 = terms[j]
            if(j != i && t2.length > 0) {
                shorthand += t2.substr(0, 1)
            }
        }
        if(shorthand.length > 2) {
            for(j = 0; j < terms.length; j++) {
                t2 = terms[j]
                if(t2 == shorthand || (t2.length > 2 && t2.indexOf(shorthand) != -1)) {
                    to_remove.push(j)
                }
            }
        }
        
        
        for(j = 0; j < terms.length; j++) {
            t2 = terms[j].replace(/[aeiou]+/g, '')
            if(t2.length > 2 && t2 == t) {
                to_remove.push(j)
            }
        }
        
            
    }

    for(i = 0; i < terms.length; i++) {
        if(to_remove.indexOf(i) == -1) {
            new_terms.push(terms[i])
        }
    }
    
    return new_terms
}

function preselect_rip_info_from_filename(filename, element) {
    sample_warning = false
    filename = filename.replace(/[\(\)\.\/\]\[\-_]/g, ' ')//.replace(/\d/g, ' ')
    filename_orignal_size = filename.split(' ')
    filename = filename.toLowerCase().split(' ')
    

    for(i = 0; i < filename.length; i++) {
        t = filename[i]
        
        filename[i] = null
        if(filename.indexOf(t) == -1) {
            // types
            for(j = 0; j < types.length; j++) {
                for(k = 0; k < types[j].length; k++) {
                    if(types[j][k] == t) {
                        $('rip_type_id').childElements()[j+1].selected = 'selected'
                    }
                }
            }
            
            // releasers
            rel = releasers.split(' ')
            for(j = 0; j < rel.length; j++) {
                if(t.length > 0 && rel[j].toLowerCase() == t) {
                    $('rip_releaser').value = rel[j]
                }
            }
            
            // languages
            for(j = 0; j < langs.length; j++) {
                for(k = 0; k < langs[j].length; k++) {
                    iso = langs[j][0]
                    if(langs[j][k] == t) {
                        toggle_lang($$('#language_selection .flag-' + iso)[0])
                    }
                }
            }
        }
        
        // sample
        if(!sample_warning && t == 'sample') {
            sample_warning = true
            $(element).insert('<small class="warning">don\'t add samples</small>')
        }

    }
    if(!sample_warning) {
        duration = parseInt(element.down('.duration').innerHTML)
        if(isNaN(duration) || duration == 0) {
            $(element).insert('<small class="warning">sure it is a real movie and not a sample or something like that?</small>')
        } else if(duration < 900) {
            $(element).insert('<small class="warning">short movie duration. sure it is a real movie and not a sample or something like that?</small>')
        }
    }
}

function unselect_selected_rip_infos() {
    for(i = 0; i < selected_langs.length; i++) {
        if(selected_langs[i])
            toggle_lang(selected_langs[i])
    }
    for(i = 0; i <  $('rip_type_id').childElements().length; i++) {
        $('rip_type_id').childElements()[i].selected = ''
    }
    $('rip_releaser').value = ''
    $('omdb_search_field').value = ''
}




function paste_to_search(name, value) {
    if(value.indexOf(' ') != -1) {
        value = '"' + value + '"'
    }
    to_add = name + ':' + value
    query = $('search').value
    if(query.indexOf(to_add) == -1) {
        if(query.length > 0 && query.substring(query.length -1, query.length)  != ' ') {
            $('search').value += ' '
        }
        $('search').value += to_add
    }
}

function logged_in_as() {
    return Cookie.get('user_name')
}

function is_logged_in() {
    name = logged_in_as()
    return name && name != null && !(typeof name == 'string' && name == 'null')
}



function select_rating(type, el){
    $$('.'+ type + '_rating').each(function(e) {
        e.removeClassName('user_selected')
    })
    el.addClassName('user_selected')
}

    

function insert_parts_into_form(form) {
    $$('#parts input').each(function(p) {
        $(form).insert(p)
    })
}



function prepare_rip_forms() {
    create_input_hint($$('#rip_form input'))
    create_input_hint($$('#rip_form select'))
    create_input_hint($$('#rip_form textarea'))
    create_input_hint($$('#rip_form .select_box'), false)
    
    $('rip_omdb').onblur = function() {
        set_omdb($('rip_omdb').value)
        $('rip_omdb').parentNode.getElementsByTagName("span")[0].style.display = "none";
    }
    
    $('omdb_suggestions').onmouseover = function () {
        $('rip_omdb').parentNode.getElementsByTagName("span")[0].style.display = "block";
    }
    $('omdb_suggestions').onmouseout = function () {
        $('rip_omdb').parentNode.getElementsByTagName("span")[0].style.display = "none";
    }
}

function create_input_hint(inputs, focusing) {

    if(typeof focusing == "undefined") {
        focusing = true
    }
    for (var i=0; i<inputs.length; i++){
        if (inputs[i].parentNode.getElementsByTagName("span")[0]) {
            if(focusing) {
                inputs[i].onfocus = function () {
                    this.parentNode.getElementsByTagName("span")[0].style.display = "block";
                }
                // when the cursor moves away from the field, hide the hint
                inputs[i].onblur = function () {
                    this.parentNode.getElementsByTagName("span")[0].style.display = "none";
                }
            } else {
                inputs[i].onmouseover = function () {
                    this.parentNode.getElementsByTagName("span")[0].style.display = "block";
                }
                // when the cursor moves away from the field, hide the hint
                inputs[i].onmouseout = function () {
                    this.parentNode.getElementsByTagName("span")[0].style.display = "none";
                }
            }
        }
    }
}


function set_omdb(id) {
    $$('.selected_movie').each(function(e) {
        e.removeClassName('selected_movie')
    })
    if($('omdb_movie_' + id))
        $('omdb_movie_' + id).addClassName('selected_movie')
    $('rip_omdb').value = id
}


function installExtension(aEvent, extensionName, iconURL) {
    var params = new Object()
    params[extensionName] =
    {
        URL: aEvent.target.href,
        IconURL: iconURL,
        toString: function () {
            return this.URL;
        }
    }
    InstallTrigger.install(params);
    return false;
}


function toggle_samples() {
    $$('#unknown_parts .part').each(function(e) {
        if(e && e.down('.filename') && e.down('.filename').innerHTML.toLowerCase().indexOf('sample') > -1)
            e.toggle()
    })
    toggle_samples_text = 'hide samples'
    if($('toggle_samples').innerHTML == toggle_samples_text) {
        toggle_samples_text = 'show samples'
    }
    $('toggle_samples').innerHTML = toggle_samples_text
}

function insert_extension_warning() {
    if(/firefox\/3/.test(navigator.userAgent.toLowerCase())) {
        if($$('meta[name=movierok.ff.version]').length == 0) {
            $('container').insert( {
                top: '<div id="ext_warning"><span class="warning">please install the <a href="/help">extension</a></span></div>'
            } )
        } else {
            if($$('meta[name=movierok.ff.status]').length > 0 && ($$('meta[name=movierok.ff.status]')[0]['content'] == 'on')) 
              $$('.only_when_extension').each(function(e){e.style.display = 'inline'})
        }
    } else {
        $('container').insert( {
            top: '<div id="ext_warning"><span class="warning">you need <a href="http://mozilla.com/">firefox 3</a> to use movierok</span></div>'
        } )
      
    }
}