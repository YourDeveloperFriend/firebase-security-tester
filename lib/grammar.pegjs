/*
 * Classic example grammar, which recognizes simple arithmetic expressions like
 * "2*(3+4)". The parser generated from this grammar then computes their value.
 */

start
  = result:logical _ ";"? { return result; }

logical
  = left:compare _ tail:(op:logicalOperator _ right:logical)* {
      tail.forEach(function(value) {
        right = value[2];
        if(left !== false && left !== true) {
          throw new Error("Left side of " + value[0] + " operation not a boolean.");
        }
        if(right !== false && right !== true) {
          throw new Error("Right side of " + value[0] + " operation not a boolean.");
        }
        switch(value[0]) {
          case "&&":
            left = left && right;
            break;
          case "||":
            left = left || right;
        }
      });
      return left;
    }

logicalOperator
  = "&&" / "||"

compare
  = left:additive _ tail:(op:equalizeOperator _ right:compare)* {
      tail.forEach(function(value) {
        right = value[2];
        switch(value[0]) {
          case "===":
          case "==":
            left = left === right;
            break;
          case "!==":
          case "!=":
            left = left !== right;
        }
      });
      return left;
    }

equalizeOperator
  = "===" / "==" / "!==" / "!="

additive
  = left:multiplicative _ tail:([+-] multiplicative)* {
      tail.forEach(function(value) {
        // value[0] is sign
        // value[1] is multiplicative rule result (our value)
        left += (value[0] == '-') ? -value[1] : value[1];
      });
      return left;
    }


multiplicative
  = left:unary _ tail:([*/%] unary)* {
      tail.forEach(function(value) {
        // value[0] is sign
        // value[2] is multiplicative rule result (our value)
        switch(value[0]) {
          case "*":
            left *= value[1];
            break;
          case "/":
            left /= value[1];
            break;
          case "%":
            left %= value[1];
            break;
        }
      });
      return left;
    }


unary
  = reverse:"!"? sign:[+-]? _ val:primary _ {
      val = sign == '-' ? -val : val;
      return reverse == '!' ? !val : val;
    }


primary
  = objectExpression
  / "(" start:start ")" { return start; }

objectExpression
  = value:rawValue _ tail:accessor* {
      tail.forEach(function(accessor) {
        if(accessor.params) {
          try {
            value = value[accessor.method].apply(value, accessor.params);
          } catch (e) {
            e.message = e.message.replace('apply', accessor.method).replace('undefined', '[object Object]');
            throw e;
          }
        } else {
          value = value[accessor.method];
        }
      });
      return value;
    }

accessor
  = method:method _ params:("(" _ (param1:start (_ "," _  param2:start)*)? _ ")")? { 
      if(params) {
        params = params[2];
        if(params && params.length > 0) {
          newParams = [params[0]].concat(params[1].map(function(param) { return param[3]; }));
        } else {
          newParams = []
        }
      } else {
        newParams = null;
      }
      return {method: method, params: newParams};
    }

method
  = "." _ method:[a-z,A-Z,0-9]* { return method.join(""); }
  / "[" method:start "]" { return method; }

rawObject
  = "data"    { return data; }
  / "auth"    { return auth; }
  / "newData" { return newData; }
  / "root"    { return root; }
  / "now" { return new Date(); }
  // $variables // fill in with variables later

rawValue
  = rawInteger / rawString / rawBoolean / rawObject

rawString
  = "'" str:[^']+ "'" { return str.join(""); }
  / '"' str:[^"]+ '"' { return str.join(""); }

rawBoolean
  = 'true' {return true;}
  / 'false' { return false;}


rawInteger "integer"
  = digits:[0-9]+ { return parseInt(digits.join(""), 10); }


_ "whitespace"
  = [ \n\r]*
