const {detransliterate} = require('./ParsersAndFormatters.js')
const Bert = require('node_erlastic/bert')
Bert.convention = Bert.ELIXIR
Bert.all_binaries_as_string = true

require('node_erlastic').server(function(term,from,current_amount,done){
  if (term[0] == "detransliterate") return done("reply", detransliterate(term[1], false));
  throw new Error("unexpected request")
});
