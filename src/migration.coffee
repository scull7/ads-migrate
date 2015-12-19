

# @type = MigrationFile {
#   name      : String
#   timestamp : Integer
#   hasRun    : Bool
# }
Migration     = (name, timestamp, hasRun = false) ->
  name        : name
  timestamp   : timestamp
  hasRun      : hasRun


# isBefore :: Migration -> Migration -> Bool
isBefore  = (a, b) -> if a.timestamp < b.timestamp then yes else no


# isSame  :: Migration -> Migration -> Bool
isSame    = (a, b) ->
  if a.name is b.name and a.timestamp is b.timestamp then yes else no


Migration.isBefore  = isBefore
Migration.isSame    = isSame


module.exports = Migration
