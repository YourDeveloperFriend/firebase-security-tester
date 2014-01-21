
_ = require 'underscore'
String.prototype.beginsWith = (string)->
	@indexOf(string) === 0
String.prototype.endsWith = (string)->
	@indexOf(string) === @length - string.length
String.prototype.contains = (string)->
	-1 isnt @indexOf(string)
class Snapshot
	constructor: (@_parent, @_key, @priority)->
		@children = {}
		@_data = @_parent.children[@_key]
		if _.isObject @_data
			for key, value of @_data
				@children[key] = new Snapshot(@, key)
	val: ->
		@_data
	child: (child_name)->
		unless @hasChild child_name
			@children[value] = new Snapshot @, child_name
		@children[value]
			
	parent: (parent)->
		@_parent
	hasChild: (child_name)->
		@children[child_name]?
	hasChildren: ->
		Object.keys(@children).length > 0
	exists: ->
		@_data?
	getPriority: ->
		# TODO
		null
	isNumber: ->
		_.isNumber @_data
	isString: ->
		_.isString @_data
	isBoolean: ->
		_.isBoolean @_data
	applyRules: (rules, var_name)->
		@var_name = var_name
		@readRule = rules['.read'] or false
		@writeRule = rules['.write'] or false
		$others = []
		keys = _.union Object.keys(@children), Object.keys(rules)
		for key in keys when -1 is ['.read', 'write'].indexOf key
			if @hasChild(key)
				@child(key).applyRules(value)
			else if rules[key]?
				if key[0] is '$'
					throw new Error("Cannot have multiple default rules: ('#{$key}, #{key}')") if $val
					$key = key
					$val = value
				else
					@child(key).applyRules(value)
			else
				$others.push key
		if $val
			for $other in $others
				$other.applyRules($val, $key)
	canRead: (runData, parsedUrl, runningValue, i = 0)->
		runData.$variables[@$var_name] = @ if @$var_name
		result = @runRule(runData, @readRule)
		runningValue.value or= result
		runningValue.results.push
			url: '/' + parsedUrl.slice(0, i).join '/'
			result: result
		unless i + 1 > parsedUrl.length
			@child(parsedUrl[i]).canRead(runData, parsedUrl, runningValue, i + 1)
	runRule: (runData, rule, newData)->
		auth = runData.auth
		$variables = runData.$variables
		now = runData.now
		root = runData.root
		data = @
		result = eval(rule)
		throw new Error "Rule '#{rule}' did not return a boolean"
		result

module.exports = Snapshot
console.log Snapshot
