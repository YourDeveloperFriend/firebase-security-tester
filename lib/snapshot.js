// Generated by CoffeeScript 1.6.3
(function() {
  var Snapshot, _;

  _ = require('underscore');

  String.prototype.beginsWith = function(string) {
    return this.indexOf(string) === 0;
  };

  String.prototype.endsWith = function(string) {
    return this.indexOf(string) === this.length - string.length;
  };

  String.prototype.contains = function(string) {
    return -1 !== this.indexOf(string);
  };

  module.exports = Snapshot = (function() {
    function Snapshot(_parent, _key, priority) {
      var _ref;
      this._parent = _parent;
      this._key = _key;
      this.priority = priority;
      this.children = {};
      this.setData((_ref = this._parent._data) != null ? _ref[this._key] : void 0);
    }

    Snapshot.prototype.setData = function(data) {
      var key, value, _ref, _results;
      this._data = data;
      if (_.isObject(this._data)) {
        _ref = this._data;
        _results = [];
        for (key in _ref) {
          value = _ref[key];
          _results.push(this.children[key] = new Snapshot(this, key));
        }
        return _results;
      }
    };

    Snapshot.prototype.val = function() {
      return this._data;
    };

    Snapshot.prototype.child = function(child_name) {
      if (!this.hasChild(child_name)) {
        this.children[child_name] = new Snapshot(this, child_name);
        if (this.dynamic_child_rules) {
          this.children[child_name].applyRules(this.dynamic_child_rules.$val, this.dynamic_child_rules.$key);
        }
      }
      return this.children[child_name];
    };

    Snapshot.prototype.parent = function(parent) {
      return this._parent;
    };

    Snapshot.prototype.hasChild = function(child_name) {
      return this.children[child_name] != null;
    };

    Snapshot.prototype.hasChildren = function(required) {
      var child, hasChildren, _i, _len;
      if (required) {
        return Object.keys(this.children).length > 0;
      } else {
        hasChildren = true;
        for (_i = 0, _len = required.length; _i < _len; _i++) {
          child = required[_i];
          hasChildren && (hasChildren = this.hasChild(child));
        }
        return hasChildren;
      }
    };

    Snapshot.prototype.actuallyRead = function(urlParts, i) {
      if (i == null) {
        i = 0;
      }
      if (i >= urlParts.length) {
        return this.val();
      } else {
        return this.child(urlParts[i], i + 1);
      }
    };

    Snapshot.prototype.actuallyWrite = function(urlParts, data, i) {
      if (i == null) {
        i = 0;
      }
      if (i >= urlParts.length) {
        return this.setData(data);
      } else {
        return this.child(urlParts[i], i + 1);
      }
    };

    Snapshot.prototype.exists = function() {
      return this._data != null;
    };

    Snapshot.prototype.getPriority = function() {
      return null;
    };

    Snapshot.prototype.isNumber = function() {
      return _.isNumber(this._data);
    };

    Snapshot.prototype.isString = function() {
      return _.isString(this._data);
    };

    Snapshot.prototype.isBoolean = function() {
      return _.isBoolean(this._data);
    };

    Snapshot.prototype.applyRules = function(rules, var_name) {
      var $key, $other, $others, $val, key, keys, _i, _j, _len, _len1, _results;
      this.var_name = var_name;
      this.readRule = rules['.read'] || false;
      this.writeRule = rules['.write'] || false;
      this.validateRule = rules['.validate'] || false;
      $others = [];
      keys = _.union(Object.keys(this.children), Object.keys(rules));
      for (_i = 0, _len = keys.length; _i < _len; _i++) {
        key = keys[_i];
        if (-1 === ['.read', '.write', '.validate'].indexOf(key)) {
          if (rules[key] != null) {
            if (key[0] === '$') {
              if ($val) {
                throw new Error("Cannot have multiple default rules: ('" + $key + ", " + key + "')");
              }
              $key = key;
              $val = rules[key];
            } else {
              this.child(key).applyRules(rules[key]);
            }
          } else {
            $others.push(this.children[key]);
          }
        }
      }
      if ($val) {
        this.dynamic_child_rules = {
          $val: $val,
          $key: $key
        };
        _results = [];
        for (_j = 0, _len1 = $others.length; _j < _len1; _j++) {
          $other = $others[_j];
          _results.push($other.applyRules($val, $key));
        }
        return _results;
      }
    };

    Snapshot.prototype.canAccess = function(runData, parsedUrl, runningValue, i) {
      var result, rule;
      if (i == null) {
        i = 0;
      }
      if (this.$var_name) {
        runData.$variables[this.$var_name] = this;
      }
      rule = runData.newData ? this.writeRule : this.readRule;
      result = this.runRule(runData, rule);
      runningValue.value || (runningValue.value = result);
      runningValue.results.push({
        url: '/' + parsedUrl.slice(0, i).join('/'),
        rule: rule,
        result: result
      });
      if (!(i + 1 > parsedUrl.length)) {
        return this.child(parsedUrl[i]).canAccess(runData, parsedUrl, runningValue, i + 1);
      }
    };

    Snapshot.prototype.runRule = function(runData, rule, newData) {
      var $variables, auth, data, newRule, now, result, root;
      if (_.isBoolean(rule)) {
        return rule;
      }
      if (_.isUndefined(rule)) {
        return false;
      }
      auth = runData.auth;
      $variables = runData.$variables;
      now = runData.now;
      root = runData.root;
      data = this;
      newRule = rule.replace(/\$/, '$variables.$');
      result = eval(rule);
      if (!_.isBoolean(result)) {
        throw new Error("Rule '" + rule + "' did not return a boolean");
      }
      return result;
    };

    return Snapshot;

  })();

}).call(this);