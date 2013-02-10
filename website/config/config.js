var path = require('path');
console.log(__dirname);
console.log(path.normalize(__dirname+"/../dist"));
module.exports = {
  ManbagAppPath :path.normalize(__dirname+"/../dist")
};
