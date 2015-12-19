
Migration   = require './migration'

# isValid :: String -> Bool
isValid     = (fileName) -> /\d+\-([a-z\-_]+)\.js$/.test fileName


# fromObject :: Migration -> String
fromObject  = (fileObject) ->
  "#{fileObject.timestamp}-#{fileObject.name}.js"


# fileNameToFileObject :: String -> Migration
parse       = (fileName) ->

  parsed  = /(\d{13})-([a-z\-_]+)\.js/.exec(fileName)

  return Migration parsed[2], parsed[1]


module.exports  =
  isValid       : isValid
  fromObject    : fromObject
  parse         : parse
