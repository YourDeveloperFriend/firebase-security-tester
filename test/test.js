// Generated by CoffeeScript 1.6.3
(function() {
  var Tester, assert, rules, test_data;

  Tester = require('../lib/tester');

  assert = require('assert');

  rules = require('./rules.json').rules;

  test_data = {
    readAnything: {
      booya: 'one'
    },
    cantRead: {
      canRead: {
        stillCanRead: 'booya'
      },
      other: {
        child: 'gee'
      }
    },
    logic: {
      readVal: 11,
      dontReadVal: 11,
      testChild: {
        booya: 5
      }
    },
    newOnly: {
      shouldntRead: true
    }
  };

  describe('Tester', function() {
    var tester;
    tester = null;
    beforeEach(function() {
      return tester = new Tester(test_data, rules);
    });
    describe('canRead', function() {
      it('shouldn\'t be able to read root', function() {
        return assert.equal(false, tester.canRead('/').value);
      });
      it('should be able to read something permitted', function() {
        return assert.ok(tester.canRead('/readAnything').value);
      });
      it('should be able to read the child of something permitted', function() {
        return assert.ok(tester.canRead('/readAnything/booya').value);
      });
      it('shouldnt be able to read a child', function() {
        return assert.equal(false, tester.canRead('/cantRead').value);
      });
      it('should be able to read a child even if the parent is forbiddent', function() {
        return assert.equal(true, tester.canRead('/cantRead/canRead').value);
      });
      it('should be able to read a child of an allowed even if that child is forbidden', function() {
        return assert.equal(true, tester.canRead('/cantRead/canRead/stillCanRead').value);
      });
      it('should be able to read through a variable', function() {
        return assert.equal(true, tester.canRead('/cantRead/other').value);
      });
      it('should be able to read a variables child as well', function() {
        return assert.equal(true, tester.canRead('/cantRead/other/child').value);
      });
      it('should be able to read a variable even if the variable doesnt exist', function() {
        return assert.equal(true, tester.canRead('/cantRead/doesntexist').value);
      });
      it('should be able to handle simple addition', function() {
        assert.equal(true, tester.canRead('/logic/simple').value);
        return assert.equal(false, tester.canRead('/logic/simplefail').value);
      });
      it('should be able to access the data', function() {
        return assert.equal(true, tester.canRead('/logic/readVal').value);
      });
      it('shouldnt be able to access the data', function() {
        return assert.equal(false, tester.canRead('/logic/dontReadVal').value);
      });
      return it('should be able to access the child', function() {
        return assert.equal(true, tester.canRead('/logic/testChild').value);
      });
    });
    return describe('canWrite', function() {
      it('shouldn\'t be able to write root', function() {
        return assert.equal(false, tester.canWrite('/', 5).value);
      });
      it('should be able to write something permitted', function() {
        return assert.ok(tester.canWrite('/readAnything', 5).value);
      });
      it('should be able to read the child of something permitted', function() {
        return assert.ok(tester.canRead('/readAnything/booya').value);
      });
      it('shouldnt be able to read a child', function() {
        return assert.equal(false, tester.canRead('/cantRead').value);
      });
      it('should be able to read a child even if the parent is forbiddent', function() {
        return assert.equal(true, tester.canRead('/cantRead/canRead').value);
      });
      it('should be able to write a child of an allowed even if that child is forbidden', function() {
        return assert.equal(true, tester.canWrite('/cantRead/canRead/stillCanRead', 5).value);
      });
      it('should be able to write through a variable', function() {
        return assert.equal(true, tester.canWrite('/cantRead/other', {
          booya: 3
        }).value);
      });
      it('should be able to read a variables child as well', function() {
        return assert.equal(true, tester.canWrite('/cantRead/other/child').value);
      });
      it('should be able to write a variable even if the variable doesnt exist', function() {
        return assert.equal(true, tester.canWrite('/cantRead/doesntexist', 55).value);
      });
      it('should be able to handle simple addition', function() {
        assert.equal(true, tester.canWrite('/logic/simple', 9).value);
        return assert.equal(false, tester.canWrite('/logic/simplefail', 5).value);
      });
      it('should be able to access the data', function() {
        return assert.equal(true, tester.canWrite('/logic/readVal', 83).value);
      });
      it('shouldnt be able to access the data', function() {
        return assert.equal(false, tester.canWrite('/logic/dontReadVal', {
          lll: {
            bbb: 5
          }
        }).value);
      });
      it('should be able to access the child', function() {
        return assert.equal(true, tester.canWrite('/logic/testChild', {
          lll: {
            ppp: 'hahaha'
          }
        }).value);
      });
      return it('should only be able to add new children', function() {
        assert.equal(false, tester.canWrite('/newOnly/shouldntRead', {
          booya: 'gee'
        }).value);
        return assert.equal(true, tester.canWrite('/newOnly/otherValue', {
          booya: 'gee'
        }).value);
      });
    });
  });

}).call(this);