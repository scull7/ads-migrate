
assert          = require 'assert'
MigrationList   = require '../../src/migration-list'


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

testInvalidFileNames  = [
  'helpers.js'
  'db.js'
  '.'
  '..'
  '.git'
]


describe 'Migration List Type', ->


  describe 'fromNameList', ->

    it 'should filter out invalid file names', ->

      testNameList  = testFileNames.concat testInvalidFileNames
      resultList    = MigrationList.fromNameList testNameList

      hasAllValid   = resultList.every (x) ->
        return testFileNames.some (y) -> y.replace('.js','') is x.name

      hasNoInvalid  = resultList.every (x) ->
        exists  = testInvalidFileNames.some (y) ->
          y.replace('.js', '') is x.name

        return not exists

      assert.ok hasAllValid
      assert.ok hasNoInvalid


  describe 'getDiff', ->

    it 'should include anything in the right that is not in the left ' +
      'in the `add` property', ->

      nameList  = testFileNames.map (x) -> "#{(new Date()).getTime()}-#{x}"
      left      = MigrationList.fromNameList nameList.slice(0, -2)
      right     = MigrationList.fromNameList nameList

      diff    = MigrationList.getDiff left, right

      assert.deepEqual [], diff.del
      assert.equal 'change-request-review-client', diff.add[0].name
      assert.equal 'keyhole', diff.add[1].name

    it 'should included any left items that are not in the right in the ' +
      '`del` property', ->

      nameList  = testFileNames.map (x) -> "#{(new Date()).getTime()}-#{x}"
      left      = MigrationList.fromNameList nameList
      right     = MigrationList.fromNameList nameList.filter (x) ->
        return  x.indexOf('role-client') is -1 and
                x.indexOf('brand-to-client') is -1

      diff    = MigrationList.getDiff left, right

      assert.deepEqual [], diff.add
      assert.equal 'role-client', diff.del[0].name
      assert.equal 'brand-to-client', diff.del[1].name


    it 'should handle additions and deletions in the same diff', ->

      nameList  = testFileNames.map (x) -> "#{(new Date()).getTime()}-#{x}"

      left      = MigrationList.fromNameList nameList.filter (x) ->
        return  x.indexOf('permission_level_records') is -1 and
                x.indexOf('remove-brand-roles') is -1

      right     = MigrationList.fromNameList nameList.filter (x) ->
        return  x.indexOf('role-client') is -1 and
                x.indexOf('brand-to-client') is -1

      diff      = MigrationList.getDiff left, right

      assert.equal 'permission_level_records', diff.add[0].name
      assert.equal 'remove-brand-roles', diff.add[1].name
      assert.equal 'role-client', diff.del[0].name
      assert.equal 'brand-to-client', diff.del[1].name

    it 'should return empty add and del arrays when the lists are the same', ->

      nameList  = testFileNames.map (x) -> "#{(new Date()).getTime()}-#{x}"
      left      = MigrationList.fromNameList nameList
      right     = MigrationList.fromNameList nameList

      diff    = MigrationList.getDiff left, right

      assert.deepEqual [], diff.del
      assert.deepEqual [], diff.add

