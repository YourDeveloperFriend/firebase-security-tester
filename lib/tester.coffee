
Snapshot = require './snapshot'

module.exports = class Tester
	constructor: (data, rules)->
		@setData(data)
		@root.applyRules(rules)
	setData: (data)->
		@originalData = data
		@root = @createRoot data
	createRoot: (data)->
		parent = _data: root: data
		new Snapshot parent, 'root'
	setAuth: (auth)->
		@auth = auth
	canRead: (url)->
		@canAccess url
	canWrite: (url, newValue)->
		parsed = @parseUrl url
		# should I create a new tree? Yes
		newRoot = @createRoot(@originalData)
		newData = newRoot.actuallyWrite(parsed, newValue)
		@canAccess url, newData
	canAccess: (url, newData)->
		parsed = @parseUrl url
		runningValue =
			value: false
			results: []
		runData =
			root: @root
			$variables: {}
			now: new Date().getTime()
			auth: @auth
			newData: newData
		@root.canAccess runData, parsed, runningValue
		runningValue
		
	actuallyWrite: (url, newValue)->
		@root.actuallyWrite url, newValue

	actuallyRead: (url)->
		@root.actuallyRead @parseUrl url

	parseUrl: (url)->
		url.substr(1).split /\//
