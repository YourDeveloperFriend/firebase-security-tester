// Generated by CoffeeScript 1.6.3
(function() {
  var Rule, Snapshot, Tester;

  Rule = require('./rule');

  Snapshot = require('./snapshot');

  module.exports = Tester = (function() {
    function Tester(data, rules) {
      this.setData(data);
      this.root.applyRules(rules);
      return;
    }

    Tester.prototype.setData = function(data) {
      this.originalData = data;
      return this.root = this.createRoot(data);
    };

    Tester.prototype.createRoot = function(data) {
      var parent;
      parent = {
        _data: {
          root: data
        }
      };
      return new Snapshot(parent, 'root');
    };

    Tester.prototype.setAuth = function(auth) {
      return this.auth = auth;
    };

    Tester.prototype.canRead = function(url) {
      return this.canAccess(url);
    };

    Tester.prototype.canWrite = function(url, newValue) {
      var newData, newRoot, parsed;
      parsed = this.parseUrl(url);
      newRoot = this.createRoot(this.originalData);
      newData = newRoot.actuallyWrite(parsed, newValue);
      return this.canAccess(url, newData);
    };

    Tester.prototype.canAccess = function(url, newData) {
      var parsed, runData, runningValue;
      parsed = this.parseUrl(url);
      runningValue = {
        value: false,
        results: []
      };
      runData = {
        root: this.root,
        $variables: {},
        now: new Date().getTime(),
        auth: this.auth,
        newData: newData
      };
      this.root.canAccess(runData, parsed, runningValue);
      return runningValue;
    };

    Tester.prototype.actuallyWrite = function(url, newValue) {
      return this.root.actuallyWrite(url, newValue);
    };

    Tester.prototype.actuallyRead = function(url) {
      return this.root.actuallyRead(this.parseUrl(url));
    };

    Tester.prototype.parseUrl = function(url) {
      return url.substr(1).split(/\//);
    };

    return Tester;

  })();

}).call(this);
