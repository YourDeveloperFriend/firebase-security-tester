
Firebase Security Rules Tester

Writing firebase security rules is tough, and it's hard to know whether or not they're working properly. The last thing you want is to leave a hole in your system that other's can read or write what they shouldn't have access to. Unfortunately, the firebase simulator kind of sucks. It's tedious and time consuming, and difficult to maintain consistency.

To Install:

    npm install firebase-security-tester

Enter the Firebase Security Rules Tester. It's usage is simple:

    var Tester = require('firebase-security-tester'),
      rules = require('./rules.json').rules,
      tester = new Tester(test_data, rules);
    tester.canRead('/child1/child2');
    // Output:
    // {
    //   value: true,
    //   results: [{
    //     url: '/',
    //     rule: false,
    //     result: false
    //   }, {
    //     url: '/child1',
    //     rule: 'auth.id == data.child("user_id").val()',
    //     result: false
    //   }, {
    //     url: '/child1/child2',
    //     rule: '5+5==10',
    //     result: true
    //   }]
    // };


Note: Right now the rules are evaluated using the eval() statement, so the rules will have to be self-moderated somewhat. I am currently working on an evaluation system so that the rules can be analyzed just like the firebase api. (I'm trying to create a grammar here: http://pegjs.majda.cz/online, but it's kicking my butt. Any help would be appreciated.)

Coming Soon:
 - Validation handling
 - Rule parsing system for better analysis of rules

To find out more about firebase's rules system, read here: https://www.firebase.com/docs/security/rule-expressions/index.html
