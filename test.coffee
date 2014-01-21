
Tester = require './lib/tester'

rules = require('./rules.json').rules
test_data =
	booya: 'one'
	two: 'three'
	users:
		bob:
			name: "Haha"
			email: "gee"
			other: "onetwothree"
	syncedValue: "hahaha"

tester = new Tester(rules, test_data)
console.log tester.canRead('/booya')
console.log tester.canRead('/two')
console.log tester.canRead('/syncedValue')
