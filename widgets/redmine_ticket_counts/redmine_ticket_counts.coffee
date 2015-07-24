class Dashing.RedmineTicketCounts extends Dashing.Widget

  ready: ->
    @keyList = [ 'immediate', 'urgent', 'high', 'normal' ]
    @currentIndex = 0
    @valueContainer = $(@node).find('.value')
    @nextCount()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "15" if not interval
    setInterval(@nextCount, parseInt( interval ) * 1000)

  nextCount: =>
    @valueContainer.fadeOut =>
      @currentIndex = (@currentIndex + 1) % @keyList.length
      valueKey = @keyList[@currentIndex]
      @set 'current', @get(valueKey)
      @set 'priority', valueKey
      @valueContainer.fadeIn()