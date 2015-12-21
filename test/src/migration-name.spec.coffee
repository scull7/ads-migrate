
assert          = require 'assert'
MigrationName   = require '../../src/migration-name'

testFileNames   = [
  'permission_level.js'
  'permission_level_records.js'
  'campaign-user-permission-level.js'
  'campaign-permission-timestamp-column.js'
  'create-role-object-permission.js'
  'create-role-object-permission-records.js'
  'role-client.js'
  'brand-to-client.js'
  'permission-init-omni.js'
  'permission-init.js'
  'remove-brand-roles.js'
  'change-request-review-client.js'
  'keyhole.js'
]


describe 'Migration Name Type', ->

  describe 'isValid', ->

    it 'should return false when the name does not include a timestamp', ->

      tests   = [
        'helpers.js'
        'db.js'
        '.'
        '..'
        '.git'
      ]

      tests.map (x) -> assert.equal false, MigrationName.isValid x


    it 'should return true when the name is in a valid format', ->

      testFileNames.map (x) ->
        name        = "#{(new Date()).getTime()}-#{x}"
        assert.ok MigrationName.isValid(name), "#{name} is not valid"


  describe 'parse', ->

    it 'should return a migration object from a file name', ->

      testFileNames.map (x) ->
        timestamp   = (new Date()).getTime()
        expected    =
          name      : x.replace('\.js', '')
          timestamp : timestamp
          hasRun    : false

        actual      = MigrationName.parse "#{timestamp}-#{x}"

        assert.deepEqual expected, actual


  describe 'fromObject', ->

    it 'should return a file name from a migration object', ->

      testFileNames.map (x) ->
        timestamp   = (new Date()).getTime()
        expected    = "#{timestamp}-#{x}"
        migration   = MigrationName.parse expected

        actual      = MigrationName.fromObject migration

        assert.equal expected, actual

