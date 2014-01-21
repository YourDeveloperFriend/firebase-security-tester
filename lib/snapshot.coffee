
_ = require 'underscore'
String.prototype.beginsWith = (string)->
	@indexOf(string) is 0
String.prototype.endsWith = (string)->
	@indexOf(string) is @length - string.length
String.prototype.contains = (string)->
	-1 isnt @indexOf(string)
module.exports = class Snapshot
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
			@children[child_name] = new Snapshot @, child_name
			if @dynamic_child_rules
				@children[child_name].applyRules @dynamic_child_rules.$val, @dynamic_child_rules.$key
		@children[child_name]
			
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
		@validateRule = rules['.validate'] or false
		$others = []
		keys = _.union Object.keys(@children), Object.keys(rules)
		for key in keys when -1 is ['.read', '.write', '.validate'].indexOf key
			if rules[key]?
				if key[0] is '$'
					throw new Error("Cannot have multiple default rules: ('#{$key}, #{key}')") if $val
					$key = key
					$val = rules[key]
				else
					@child(key).applyRules(rules[key])
			else
				$others.push @children[key]
		if $val
			@dynamic_child_rules =
				$val: $val
				$key: $key
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
		return rule if _.isBoolean rule
		return false if _.isUndefined rule
		auth = runData.auth
		$variables = runData.$variables
		now = runData.now
		root = runData.root
		data = @
		newRule = rule.replace /\$/, '$variables.$'
		result = eval(rule)
		console.log result, data.val()
		throw new Error "Rule '#{rule}' did not return a boolean" unless _.isBoolean result
		result

