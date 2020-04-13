"use strict";
exports.__esModule = true;
var dep_1 = require("./dep");
var str = process.argv[2];
var obj = {
    a: '1',
    b: 2
};
dep_1.fn(1);
console.log('test', str);
setInterval(function () {
    console.log('Working');
}, 5000);
console.log('test', str);
//throw new Error('fds')
