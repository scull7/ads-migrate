Bluebird            = require 'bluebird'
Migration           = require './migration'
MigrationName       = require './migration-name'


# fromNameList :: Array String -> Array MigrationFile
fromNameList  = (nameList) ->
  nameList
    .filter(MigrationName.isValid)
    .map(MigrationName.parse)


# getFromPath :: String -> Promise Array MigrationFile
# @TODO - move into file that handles side effects.
getFromPath = (path) -> new Bluebird (resolve, reject) ->

  fs.readdir path, (err, list) ->

    if err
      reject err

    else
      resolve nameListToObjectList list


# type alias MigrationHash = { String : Migration }


# _reducer :: MigrationHash -> Migration -> MigrationHash
_reducer = (acc, x) ->
  acc[(MigrationName.fromObject x)] = x
  return acc


# toHash :: Array Migration -> MigrationHash
toHash  = (list) -> list.reduce _reducer, {}


# getDiff ::
#   Array MigrationFile -> Array MigrationFile -> {
#   add: Array MigrationFile
#   del: Array MigrationFile
# }
getDiff   = (listA, listB) ->
  
  left  = toHash listA
  right = toHash listB

  return {
    add   : (value for key, value of right when not left[key])
    del   : (value for key, value of left when not right[key])
  }


module.exports  =
  getDiff       : getDiff
  fromNameList  : fromNameList
  # @TODO - move into file that handles side effects.
  getFromPath   : getFromPath

