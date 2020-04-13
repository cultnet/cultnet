// Type definitions for ramda
// Project: [https://github.com/types/npm-ramda]
// Definitions by: Erwin Poeze <https://github.com/donnut>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped
console.log('Big file TS here.');
function path11(path, d) {
    var ret = d;
    for (var _i = 0, path_1 = path; _i < path_1.length; _i++) {
        var k = path_1[_i];
        ret = ret[k];
    }
}
