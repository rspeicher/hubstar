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
    setStat(result.stars, result.hubstarred)
    setStarred(result.hubstarred)

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
#   starred   [Boolean]
setStarred = (starred) ->
  text  = if starred then 'Unstar' else 'Star'
  klass = if starred then 'starred' else 'unstarred'

  star = $("<a href='#{base}/repositories/#{getRepo()}' class='minibutton btn-star #{klass}' data-remote='true' rel='nofollow'></a>")
  star.html("<span><span class='icon'></span>#{text}</span>")

  $('li.hubstar-container').html(star)

# Creates the "Star" button, and places it next to Watch/Unwatch, Fork, Pull Request, etc.
initToggle = ->
  container = $("<li class='for-owner hubstar-container'></li>")
  $('ul.pagehead-actions').prepend(container)

  $('a.btn-star').live 'click', ->
    clickHandler(this)
    false

# Creates the repository stat for number of HubStars
initStat = ->
  li = $('<li class="hubstars"></li>')
  li.html("<img src='#{chrome.extension.getURL("images/octocat-spinner-16px.gif")}'/>")
  $('ul.repo-stats').prepend(li)

# Updates the repository stat for number of HubStars and toggles the image appropriately
setStat = (stars, starred) ->
  li = $('li.hubstars')

  if starred
    li.addClass('hubstarred')
  else
    li.removeClass('hubstarred')

  a = $("<a href='#{base}/repositories/#{getRepo()}' class='tooltipped downwards' title='HubStars'>#{stars}</a>")
  a.css("background-image", "url('#{chrome.extension.getURL("images/stars.png")}')")

  li.html(a)

# Don't do anything unless we're on a public repo page
if $('body.vis-public').length > 0 && $('div.repohead').length > 0
  initToggle()
  initStat()

  # For initial load, fetch the information about this repo and update the elements
  $.getJSON("#{base}/repositories/#{getRepo()}", {format: 'json'}, (result) ->
    if result?
      console.debug(result)
      successHandler(result)
    else
      setStat(0, false)
      setStarred(false)
  )
