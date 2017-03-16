const {detransliterate} = require('./ParsersAndFormatters.js')

require('node_erlastic').server(function(term,from,current_amount,done){
  if (term[0] == "detransliterate") return done("reply", detransliterate("ru--tekhnologiya", false));
  throw new Error("unexpected request")
});
