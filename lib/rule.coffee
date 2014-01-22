
PEG = require 'pegjs'
overrideAction = require 'pegjs-override-action'
fs = require 'fs'
Q = require 'q'
_ = require 'underscore'
module.exports = class RuleParser
	@setData = (data)-> @data = data
	@executeRule: (ruleData, rule)->
		throw new Error 'Tester is not ready. Please check tester.ready()' unless @data
		# First replace the fillin with the variables
		replaceWith = []
		variableValues = [
			-> ruleData.data
			-> ruleData.auth
			-> ruleData.newData
			-> ruleData.root
			undefined
		]
		for $variable, $value in ruleData.$variables
			replaceWith.push "/ '#{$variable}' "
			variableValues.push -> $value

		newData = @data.replace "// $variables", replaceWith
		parser = PEG.buildParser newData,
			plugins: [overrideAction]
			overrideActionPlugin:
				rules:
					rawObject: variableValues

		parser.parse rule
	@ready: Q.nfcall(fs.readFile, __dirname + '/grammar.pegjs', 'utf8').then (data)->
		RuleParser.setData data
