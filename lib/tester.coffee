
Snapshot = require './snapshot'

module.exports = class Tester
	constructor: (data, rules)->
		@setData(data)
		@root.applyRules(rules)
	setData: (data)->
		parent = children: root: data
		root = new Snapshot parent, 'root'
		@root = root
	canRead: (url)->
		parsed = @parseUrl url
		runningValue =
			value: false
			results: []
		runData =
			root: @root
			$variables: {}
			now: new Date().getTime()
			auth: {}
		@root.canRead parsed, runningValue
	canWrite: (url, newValue)->
		
	actuallyWrite: (url, newValue)->

	actuallyRead: (url)->

	parseUrl: (url)->
		url.split /\//
