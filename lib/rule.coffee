
module.exports = class Rule
	constructor: (ruleString)->
	
	@createRule: (ruleValue)->
		
		rule = new Rule()
		rule.value = ruleValue
		

# An expression is either a boolean, or an operation between
# Two values that results in a boolean
class Expression
	constructor: (@value1, @value2, @operation)->
		@values[0] =
			raw: value1
			type: @extractType value1


	operate: (data)->
		@

class RulePart
	constructor: (@testContext, @value)->
	notEquals: (other)->
		@equals(other).not()
	
class RuleString extends RulePart
	equals: (string)->
		new RuleBoolean string instanceof RuleString and string.resolve() is @resolve()
	check: (string)->
		unless string instanceof RuleString
			throw new Error 'IncorrectTypes'
	resolve: ->
		if _.isString @value
			@value
		else
			@testContext.evaluate @value, RuleString
	concat: (string)->
		@check(string)
		new RuleString @resolve() + string.resolve()
	lessThan: (string)->
		@check string
		new RuleBoolean @resolve() < string.resolve()
	lessThanOrEquals: (string)->
		@greaterThan(string).not()
	greaterThan: (string)->
		@check string
		new RuleBoolean @resolve() < string.resolve()
	greaterThanOrEquals: (string)->
		@lessThan(string).not()

class RuleInt extends RulePart

class RuleObject extends RulePart
	dotAccess: (accessor)->

class RuleAuth extends RulePart

class RuleBoolean extends RulePart
	equals: (boolean)->
		new RuleBoolean boolean instanceof RuleBoolean and boolean.resolve() is @resolve()
	and: (boolean)->
		@check(boolean)
		new RuleBoolean @resolve() and boolean.resolve()
	or: (boolean)->
		@check(boolean)
		new RuleBoolean @resolve() or boolean.resolve()
	not: ->
		new RuleBoolean not @resolve()
	check: (boolean)->
		unless boolean instanceof RuleBoolean
			throw new Error 'IncorrectTypes'
	@resolve: ->
		if _.isBoolean @value
			@value
		else
			@testContext.evaluate(@value, RuleBoolean)
				
