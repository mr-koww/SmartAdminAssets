$.fn.extend jarvismenu: (options) ->
  defaults =
    accordion: 'true'
    speed: 200
    closedSign: '[+]'
    openedSign: '[-]'
  opts = $.extend(defaults, options)
  $this = $(this)

  #add a mark [+] to a multilevel menu
  $this.find('li').each ->
    if $(this).find('ul').size() != 0
      #avoid jumping to the top of the page when the href is an #
      if $(this).find('a:first').attr('href') == '#'
        $(this).find('a:first').click ->
          false
    return

  #open active level
  $this.find('li.active').each ->
    $(this).parents('ul').slideDown opts.speed
    $(this).parents('ul').parent('li').find('b:first').html opts.openedSign
    $(this).parents('ul').parent('li').addClass 'open'
    return

  $this.find('li a').click ->
    if $(this).parent().find('ul').size() != 0
      if opts.accordion
        #Do nothing when the list is open
        if !$(this).parent().find('ul').is(':visible')
          parents = $(this).parent().parents('ul')
          visible = $this.find('ul:visible')
          visible.each (visibleIndex) ->
            close = true
            parents.each (parentIndex) ->
              if parents[parentIndex] == visible[visibleIndex]
                close = false
                return false
              return
            if close
              if $(this).parent().find('ul') != visible[visibleIndex]
                $(visible[visibleIndex]).slideUp opts.speed, ->
                  $(this).parent('li').find('b:first').html opts.closedSign
                  $(this).parent('li').removeClass 'open'
                  return
            return
      # end if
      if $(this).parent().find('ul:first').is(':visible') and !$(this).parent().find('ul:first').hasClass('active')
        $(this).parent().find('ul:first').slideUp opts.speed, ->
          $(this).parent('li').removeClass 'open'
          $(this).parent('li').find('b:first').delay(opts.speed).html opts.closedSign
          return
      else
        $(this).parent().find('ul:first').slideDown opts.speed, ->
          $(this).parent('li').addClass 'open'
          $(this).parent('li').find('b:first').delay(opts.speed).html opts.openedSign
          return
    return
  return


checkURL = ->
  url = location.href.split('#').splice(1).join('#')
  if !url
    try
      documentUrl = window.document.URL
      if documentUrl
        if documentUrl.indexOf('#', 0) > 0 and documentUrl.indexOf('#', 0) < documentUrl.length + 1
          url = documentUrl.substring(documentUrl.indexOf('#', 0) + 1)
    catch err

  container = $('#content')

  if url
    # remove all active class
    $('nav li.active').removeClass 'active'
    # match the url and add the active class
    $('nav li:has(a[href="' + url + '"])').addClass 'active'
    title = $('nav a[href="' + url + '"]').attr('title')
    # change page title from global var
    document.title = title or document.title
    loadURL url + location.search, container
  else
    $this = $('nav > ul > li:first-child > a[href!="#"]')
    #update hash
    window.location.hash = $this.attr('href')
    #clear dom reference
    $this = null
  return


loadURL = (url, container) ->
  $.ajax
    type: 'GET'
    url: url
    dataType: 'html'
    cache: true
    success: (data) ->
      # dump data to container
      container.css(opacity: '0.0').html(data).delay(50).animate { opacity: '1.0' }, 300
      # clear data var
      data = null
      container = null
      return
    error: (xhr, status, thrownError, error) ->
      container.html '<h4 class="ajax-loading-error"><i class="fa fa-warning txt-color-orangeDark"></i> Error requesting <span class="txt-color-red">' + url + '</span>: ' + xhr.status + ' <span style="text-transform: capitalize;">' + thrownError + '</span></h4>'
      return
    async: true
  return


if $.navAsAjax
  if $('nav').length
    checkURL()

  $(document).on 'click', 'nav a[href!="#"]', (e) ->
    e.preventDefault()
    $this = $(e.currentTarget)

    # if parent is not active then get hash, or else page is assumed to be loaded
    if !$this.parent().hasClass('active') and !$this.attr('target')
      # update window with hash
      # you could also do here:  thisDevice === "mobile" - and save a little more memory
      if $.root_.hasClass('mobile-view-activated')
        $.root_.removeClass 'hidden-menu'
        $('html').removeClass 'hidden-menu-mobile-lock'
        window.setTimeout (->
          if window.location.search
            window.location.href = window.location.href.replace(window.location.search, '').replace(window.location.hash, '') + '#' + $this.attr('href')
          else
            window.location.hash = $this.attr('href')
          return
        ), 150
      # it may not need this delay...
      else
        if window.location.search
          window.location.href = window.location.href.replace(window.location.search, '').replace(window.location.hash, '') + '#' + $this.attr('href')
        else
          window.location.hash = $this.attr('href')
    return

  # fire links with targets on different window
  $(document).on 'click', 'nav a[target="_blank"]', (e) ->
    e.preventDefault()
    $this = $(e.currentTarget)
    window.open $this.attr('href')
    return

  # fire links with targets on same window
  $(document).on 'click', 'nav a[target="_top"]', (e) ->
    e.preventDefault()
    $this = $(e.currentTarget)
    window.location = $this.attr('href')
    return

  # all links with hash tags are ignored
  $(document).on 'click', 'nav a[href="#"]', (e) ->
    e.preventDefault()
    return

  # DO on hash change
  $(window).on 'hashchange', ->
    checkURL()
    return
