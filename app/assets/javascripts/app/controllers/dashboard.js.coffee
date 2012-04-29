$ = jQuery.sub()

class Index extends App.Controller

  constructor: ->
    super
    
    # check authentication
    return if !@authenticate()

    # set title
    @title 'Dashboard'
    @navupdate '#/'

    @plugins = {
      main: {
        my_assigned: {
          controller: App.DashboardTicket,
          params: {
            view: 'my_assigned',
          },
        },
        all_unassigned: {
          controller: App.DashboardTicket,
          params: {
            view: 'all_unassigned',
          },
        },
      },
      side: {
        activity_stream: {
          controller: App.DashboardActivityStream,
        },
        rss_atom: {
          controller: App.DashboardRss,
          params: {
            head:  'Heise ATOM',
            url:   'http://www.heise.de/newsticker/heise-atom.xml',
            limit: 5,
          },
        },
#        rss_rdf: {
#          controller: App.DashboardRss,
#          params: {
#            head:  'Heise RDF',
#            url:   'http://www.heise.de/newsticker/heise.rdf',
#            limit: 5,
#          },
#        },

#        recent_viewed: {
#          controller: App.DashboardRecentViewed,
#        }
      }
    }

    # render page
    @render()

  render: ->
    
    @html App.view('dashboard')(
      head: 'Dashboard'
    )

    for area, plugins of @plugins
      for name, plugin of plugins
        target = area + '_' + name
        @el.find('.' + area + '-overviews').append('<div class="" id="' + target + '"></div>')
        if plugin.controller
          params = plugin.params || {}
          params.el = @el.find( '#' + target )
          new plugin.controller( params )


Config.Routes[''] = Index
Config.Routes['/'] = Index
