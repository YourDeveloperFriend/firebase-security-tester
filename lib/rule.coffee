
PEG = require 'pegjs'
overrideAction = require 'pegjs-override-action'
fs = require 'fs'
module.exports = {}
fs.readFile __dirname + '/ruleFormat.pegjs', (err, data)->
	parser = PEG.buildParser data,
		plugins: [overrideAction]
		overrideActionPlugin:
			
			object: [
				-> auth
				-> data
				-> newData
				-> root
				undefined
			]
	module.exports.parser = parser
