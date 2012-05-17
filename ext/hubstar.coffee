base = "http://hubstar.me"

# Extracts the username/repo combination from the current pathname
getRepo = ->
  document.location.pathname.replace(/^\/([^\/\#]+)\/([^\/\#]+).*/i, "$1/$2").trim()

error = (msg) ->
  alert("HubStar error: #{msg}")

# Updates the Star elements based on the result of an AJAX request
successHandler = (result) ->
  if result.error?
    error(result.error)
  else
    setStarred(result.stars, result.hubstarred)

# Handles starring/unstarring a repository
clickHandler = (a) ->
  starred = $(a).hasClass('starred')
  method  = if starred then 'DELETE' else 'PUT'

  $.ajax("#{base}/star.json", {
    type: method
    data: $.param({
      id: getRepo()
    })
    success: successHandler
  })

# Replaces the Star/Unstar button with the button for the appropriate context
#
# Arguments:
#   stars     [Integer]
#   starred   [Boolean]
setStarred = (stars, starred) ->
  text  = if starred then 'Unstar' else 'Star'
  klass = if starred then 'starred' else 'unstarred'
  link  = "#{base}/repositories/#{getRepo()}"

  $('li.hubstar-container').html("""
  <span class="hubstar-button">
    <a href="#{link}" class="minibutton btn-star #{klass}" data-remote="true" rel="nofollow">
      <span><span class="mini-icon star"></span> #{text}</span>
    </a>
    <a class="social-count js-social-count" href="#{link}">#{stars}</a>
  </span>
  """)

# Creates the "Star" button, and places it next to Watch/Unwatch, Fork, Pull Request, etc.
initToggle = ->
  container = $("<li class='js-social-container hubstar-container'></li>")
  $('li.watch-button-container').before(container)

  $('a.btn-star').live 'click', ->
    clickHandler(this)
    false

# Don't do anything unless we're on a public repo page
if $('body.vis-public').length > 0 && $('div.repohead').length > 0
  # For initial load, fetch the information about this repo and update the elements
  $.getJSON("#{base}/repositories/#{getRepo()}", {format: 'json'}, (result) ->
    initToggle()

    if result?
      successHandler(result)
    else
      setStarred(0, false)
  )
