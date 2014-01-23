
PEG = require 'pegjs'
overrideAction = require 'pegjs-override-action'
fs = require 'fs'
Q = require 'q'
_ = require 'underscore'
uuid = require 'uuid'
cache = require './cache'

module.exports = class RuleParser
	@setData = (data)-> @data = data
	@executeRule: (ruleData, rule)->
		throw new Error 'Tester is not ready. Please check tester.ready()' unless @data
		id = uuid.v4()
		# First replace the fillin with the variables
		replaceWith = []
		cache[id] = ruleData
		variableSet = ''
		variableValues = [undefined, undefined, undefined, undefined, undefined]
		for $variable, $value in ruleData.$variables
			replaceWith.push "/ '#{$variable}' "
			variableValues.push $variable
			variableSet += "\t\t#{$variable} = cache.$variables['#{variable}'],\n"

		newData = @data.replace "// $variables", replaceWith
		parser = PEG.buildParser newData,
			plugins: [overrideAction]
			overrideActionPlugin:
				initializer: "
					var cache = require('#{__dirname}/cache')['#{id}'],
						data = cache.data,
						newData = cache.newData,
						auth = cache.auth,
						#{variableSet}
						root = cache.root;
					"
				rules:
					rawObject: variableValues

		parser.parse rule
	@ready: Q.nfcall(fs.readFile, __dirname + '/grammar.pegjs', 'utf8').then (data)->
		RuleParser.setData data
