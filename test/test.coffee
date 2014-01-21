
Tester = require '../lib/tester'
assert = require 'assert'

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

describe 'Tester', ->
	tester = null
	beforeEach ->
		tester = new Tester test_data, rules
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



