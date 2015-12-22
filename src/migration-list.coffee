Bluebird            = require 'bluebird'
Migration           = require './migration'
MigrationName       = require './migration-name'


# fromNameList :: Array String -> Array Migration
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


# concatToHash :: MigrationHash = { String : Migration }
concatToHash  = (acc, x) ->
  acc[( MigrationName.fromObject x )] = x
  return acc


# toHash :: Array MigrationFile -> {
#   String : MigrationFile
# }
toHash  = (list) -> list.reduce concatToHash, {}


# getListDiff ::
#   Array Migration -> Array Migration -> {
#   add: Array Migration
#   del: Array Migration
# }
getDiff   = (listA, listB) ->
  
  left  = toHash listA
  right = toHash listB

  return {
    add   : (value for key, value of right when not left[key])
    del   : (value for key, value of left when not right[key])
  }


module.exports  =
  Migration     : Migration
  getDiff       : getDiff
  fromNameList  : fromNameList
  # @TODO - move into file that handles side effects.
  getFromPath   : getFromPath
