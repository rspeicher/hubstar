(function() {
  var base, clickHandler, getRepo, initStat, setStat, successHandler;
  base = "http://hubstar.herokuapp.com";
  getRepo = function() {
    return document.location.href.replace(/https:\/\/github.com\/([^\/\#]+)\/([^\/\#]+).*/i, "$1/$2").trim();
  };
  successHandler = function(result) {
    if (result != null) {
      if (result.error != null) {
        return alert("HubStar error: " + result.error);
      } else {
        return setStat(result.stars, result.hubstarred);
      }
    } else {
      return setStat(0, false);
    }
  };
  clickHandler = function(starred) {
    var method;
    method = starred ? 'DELETE' : 'PUT';
    return $.ajax("" + base + "/star.json", {
      type: method,
      data: $.param({
        id: getRepo()
      }),
      success: successHandler
    });
  };
  initStat = function() {
    var li;
    li = $('<li class="hubstars"></li>');
    li.html("<img src='" + (chrome.extension.getURL("images/octocat-spinner-16px.gif")) + "'/>");
    $('ul.repo-stats').prepend(li);
    return $('li.hubstars a').live('click', function() {
      clickHandler($(this).parent().hasClass('hubstarred'));
      return false;
    });
  };
  setStat = function(stars, starred) {
    var a, li;
    li = $('li.hubstars');
    if (starred) {
      li.addClass('hubstarred');
    } else {
      li.removeClass('hubstarred');
    }
    a = $("<a href='" + base + "/repositories/" + (getRepo()) + "' class='tooltipped downwards' title='HubStars'>" + stars + "</a>");
    a.css("background-image", "url('" + (chrome.extension.getURL("images/stars.png")) + "')");
    return li.html(a);
  };
  if ($('body.vis-public').length > 0 && $('div.repohead').length > 0) {
    initStat();
    $.getJSON("" + base + "/repositories/" + (getRepo()) + ".json", successHandler);
  }
}).call(this);
