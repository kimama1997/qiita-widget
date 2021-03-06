class ViewQiitaWidget
  constructor: (@selector="[data-qiita-widget]") ->
    if typeof window.XMLHttpRequest != "undefined"
      xhr = XMLHttpRequest
    else if typeof window.XDomainRequest != "undefined"
      xhr = XDomainRequest

  #  else if window.ActiveXObject
  #    xhr = ActiveXObject "Microsoft.XMLHTTP"
    else return
    @xhr = xhr

  # @onload :(res)->
  #   response = JSON.parse @responseText
  #   return

  parsepush = (data,target) ->
    #data = JSON.parse res
    s = document.createElement "div"
    u = document.createElement "ul"
    for d in data
      link = document.createElement "a"
      link.href = d.url
      link.textContent = d.title
      link.target = "_blank"
      li = document.createElement "li"
      li.appendChild link
      u.appendChild li
    title = document.createElement "h2"
    title.textContent = "#{data[0].user.url_name}さんの投稿"
    s.appendChild title
    s.appendChild u
    s.className = "qiita-widget"
    while target.firstChild
      target.removeChild target.firstChild
    target.appendChild s


    return

  get : =>
    area = document.querySelectorAll @selector
    for n in area
      do (n) =>
        i = n
        screen_name = i.getAttribute("data-name")
        urlbase = "https://qiita.com"
        uri = "/api/v1/users/#{screen_name}/items"
        count = i.getAttribute("data-count") or "10"
        i.removeAttribute "data-qiita-widget"


        req = new @xhr()
        req.onload = ->
          res = JSON.parse @responseText
          parsepush res,i
          return
        req.onerror = (e) ->
          console.log i
          i.textContent = "Error"
          console.error e
          return

        req.open "GET","#{urlbase}#{uri}?per_page=#{count}",true
        req.send()
        return
    return

  @get = (s) ->
    i = new this s
    i.get()
    i

ViewQiitaWidget.get()
