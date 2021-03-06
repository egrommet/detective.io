class ExploreCtrl
    # Injects dependancies
    @$inject: ['$scope', '$routeParams', 'Summary', '$location', '$timeout', '$filter', 'Page']

    constructor: (@scope, @routeParams, @Summary, @location, @timeout, @filter, @Page)->
        @scope.getTypeCount = @getTypeCount
        # Set page's title
        @Page.title @routeParams.scope
        # ──────────────────────────────────────────────────────────────────────
        # Scope attributes
        # ──────────────────────────────────────────────────────────────────────
        # Current individual scope
        @scope.scope           = @routeParams.scope
        # Temporary static app control
        # @TODO get applications list from server
        @location.path "/404" if @scope.scope isnt "energy" and @scope.scope isnt "common"
        # Build template url
        @scope.templateUrl     = "/partial/explore-#{@scope.scope}.html"
        # Countries info
        @scope.countries       = @Summary.get id:"countries"
        # Types info
        @scope.types           = @Summary.get id:"types"
        # Country where the user click
        @scope.selectedCountry = {}
        @scope.selectedIndividual = {}
        # ──────────────────────────────────────────────────────────────────────
        # Scope watchers
        # ──────────────────────────────────────────────────────────────────────
        @scope.$watch "selectedCountry", @selectCountry, true
        @scope.$watch "selectedIndividual", @selectIndividual, true

    # ──────────────────────────────────────────────────────────────────────────
    # Class methods
    # ──────────────────────────────────────────────────────────────────────────
    selectCountry: (val, old)=>
        @location.path "/common/country/#{val.id}" if val.id?

    selectIndividual: (val, old)=>
        # Single entity selected
        if val.predicate? and val.predicate.name is "<<INSTANCE>>"
            vals = val.object.split(":")
            @location.path "/#{vals[0]}/#{vals[1].toLowerCase()}/#{val.subject.name}"
        # Full RDF-formated research
        else if val.predicate? and val.object? and val.object != ""
            # Do not pass the label
            delete val.label
            # Create a JSON query to pass though the URL
            query = angular.toJson val
            @location.path "/search/"
            @location.search "q", query

    getTypeCount: ()=>
        tt = 0
        for type in arguments
            t   = @scope.types[type]
            tt += if t? and t.count? then t.count else 0
        tt



angular.module('detective').controller 'exploreCtrl', ExploreCtrl