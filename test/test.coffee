
Tester = require '../lib/tester'
assert = require 'assert'
RuleParser = require '../lib/rule'

rules = require('./rules.json').rules
test_data =
	readAnything:
		booya: 'one'
	cantRead:
		canRead:
			stillCanRead: 'booya'
		other:
			child: 'gee'
	logic:
		readVal: 11
		dontReadVal: 11
		testChild:
			booya: 5
	newOnly:
		shouldntRead: true

describe 'Tester', ->
	tester = null
	beforeEach (done)->
		tester = new Tester test_data, rules
		tester.ready().then ->
			done()
		.fail done
	describe 'RuleParser', ->
		it 'should be able to add', ->
			assert.equal 10, RuleParser.executeRule({$variables: []}, '5+5')
		it 'should be able to multiply', ->
			assert.equal 25, RuleParser.executeRule({$variables: []}, '5*5')
		it 'should be able to do complex math', ->
			assert.equal 59, RuleParser.executeRule({$variables: []}, '5+9*(8-2)')
		it 'should be able to do complex boolean logic', ->
			assert.equal false, RuleParser.executeRule({$variables: []}, '(5+5)*32==55||(true && false)')
			assert.equal true, RuleParser.executeRule({$variables: []}, '(5+5)*32==320||(true && false)')
			assert.equal false, RuleParser.executeRule({$variables: []}, '!((5+5)*32==320)||(true && false)')
		it 'should be able to call complex string logic', ->
			assert.equal 'BOOYA', RuleParser.executeRule({$variables: []}, '"booya".toUpperCase()')
		it 'should be able to access the inherent objects', ->
			assert.equal 'g', RuleParser.executeRule({data: {booya: 'g'}, $variables: []}, 'data.booya')
			assert.equal 'g', RuleParser.executeRule({data: {booya: 'g'}, $variables: []}, 'data["booya"]')
			assert.equal 'g', RuleParser.executeRule({data: {booya: ->'g'}, $variables: []}, 'data.booya()')
	describe 'canRead', ->
		it 'shouldn\'t be able to read root', ->
			assert.equal false, tester.canRead('/').value
		it 'should be able to read something permitted', ->
			assert.ok tester.canRead('/readAnything').value
		it 'should be able to read the child of something permitted', ->
			assert.ok tester.canRead('/readAnything/booya').value
		it 'shouldnt be able to read a child', ->
			assert.equal false, tester.canRead('/cantRead').value
		it 'should be able to read a child even if the parent is forbiddent', ->
			assert.equal true, tester.canRead('/cantRead/canRead').value
		it 'should be able to read a child of an allowed even if that child is forbidden', ->
			assert.equal true, tester.canRead('/cantRead/canRead/stillCanRead').value
		it 'should be able to read through a variable', ->
			assert.equal true, tester.canRead('/cantRead/other').value
		it 'should be able to read a variables child as well', ->
			assert.equal true, tester.canRead('/cantRead/other/child').value
		it 'should be able to read a variable even if the variable doesnt exist', ->
			assert.equal true, tester.canRead('/cantRead/doesntexist').value
		it 'should be able to handle simple addition', ->
			assert.equal true, tester.canRead('/logic/simple').value
			assert.equal false, tester.canRead('/logic/simplefail').value
		it 'should be able to access the data', ->
			assert.equal true, tester.canRead('/logic/readVal').value
		it 'shouldnt be able to access the data', ->
			assert.equal false, tester.canRead('/logic/dontReadVal').value
		it 'should be able to access the child', ->
			assert.equal true, tester.canRead('/logic/testChild').value
	describe 'canWrite', ->
		it 'shouldn\'t be able to write root', ->
			assert.equal false, tester.canWrite('/', 5).value
		it 'should be able to write something permitted', ->
			assert.ok tester.canWrite('/readAnything', 5).value
		it 'should be able to read the child of something permitted', ->
			assert.ok tester.canRead('/readAnything/booya').value
		it 'shouldnt be able to read a child', ->
			assert.equal false, tester.canRead('/cantRead').value
		it 'should be able to read a child even if the parent is forbiddent', ->
			assert.equal true, tester.canRead('/cantRead/canRead').value
		it 'should be able to write a child of an allowed even if that child is forbidden', ->
			assert.equal true, tester.canWrite('/cantRead/canRead/stillCanRead', 5).value
		it 'should be able to write through a variable', ->
			assert.equal true, tester.canWrite('/cantRead/other', booya: 3).value
		it 'should be able to read a variables child as well', ->
			assert.equal true, tester.canWrite('/cantRead/other/child').value
		it 'should be able to write a variable even if the variable doesnt exist', ->
			assert.equal true, tester.canWrite('/cantRead/doesntexist', 55).value
		it 'should be able to handle simple addition', ->
			assert.equal true, tester.canWrite('/logic/simple', 9).value
			assert.equal false, tester.canWrite('/logic/simplefail', 5).value
		it 'should be able to access the data', ->
			assert.equal true, tester.canWrite('/logic/readVal', 83).value
		it 'shouldnt be able to access the data', ->
			assert.equal false, tester.canWrite('/logic/dontReadVal', lll: bbb: 5).value
		it 'should be able to access the child', ->
			assert.equal true, tester.canWrite('/logic/testChild', lll: ppp: 'hahaha').value
		it 'should only be able to add new children', ->
			assert.equal false, tester.canWrite('/newOnly/shouldntRead', booya: 'gee').value
			assert.equal true, tester.canWrite('/newOnly/otherValue', booya: 'gee').value



