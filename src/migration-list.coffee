Bluebird            = require 'bluebird'
MigrationFile       = require './migration-file'
MigrationFileName   = require './migration-file-name'


# isBefore :: MigrationFile -> MigrationFile -> Bool
isBefore = (migrationA, migrationB) ->
  if migrationA.timestamp < migrationB.timestamp then true else false


# isSame :: MigrationFile -> MigrationFile -> Bool
isSame  = (migrationA, migrationB) ->

  sameName  = migrationA.name is migrationB.name
  sameTime  = migrationA.timestamp is migrationB.timestamp

  return if sameName and sameTime then true else false



# nameListToObjectList :: Array String -> Array MigrationFile
nameListToObjectList  = (nameList) ->
  nameList.filter(isMigrationFile).map(MigrationFileName.parse)


# getListFromPath :: String -> Promise Array MigrationFile
getListFromPath = (path) -> new Bluebird (resolve, reject) ->

  fs.readdir path, (err, list) ->

    if err
      reject err

    else
      resolve nameListToObjectList list


# toHash :: Array MigrationFile -> {
#   String : MigrationFile
# }
toHash  = (list) ->
  reducer = (acc, x) ->
    acc[(MigrationFileName.fromObject x)] = x
    return acc

  return list.reduce(reducer, {})


# getListDiff ::
#   Array MigrationFile -> Array MigrationFile -> {
#   add: Array MigrationFile
#   del: Array MigrationFile
# }
getListDiff   = (listA, listB) ->
  
  left  = toHash listA
  right = toHash listB

  return {
    add   : (value for key, value of right when not left[key])
    del   : (value for key, value of left when not right[key])
  }


module.exports  =
  MigrationFile         : MigrationFile
  getListDiff           : getListDiff
  getListFromPath       : getListFromPath
  nameListToObjectList  : nameListToObjectList
  isMigrationFileName   : isMigrationFile
  fileNameToFileObject  : fileNameToFileObject

