
assert      = require 'assert'
Migration   = require '../../src/migration'


describe 'Migration Type', ->


  describe 'type constructor', ->

    it 'should default hasRun to false', ->

      actual    = Migration 'test', (new Date()).getTime()
      assert.equal false, actual.hasRun


    it 'should set hasRun to true true is passed.', ->

      actual    = Migration 'test', (new Date()).getTime(), true
      assert.equal true, actual.hasRun


    it 'should return the given values in the proper fields.', ->

      timestamp = (new Date()).getTime()
      actual    = Migration 'test', timestamp
      expected  =
        name        : 'test'
        timestamp   : timestamp
        hasRun      : false

      assert.deepEqual actual, expected


  describe 'isBefore', ->

    it 'should return true when a.timestamp is before b.timestamp', ->

      timestampA  = (new Date()).getTime()
      timestampB  = (new Date()).getTime() + 1000
      migrationA  = Migration 'testA', timestampA
      migrationB  = Migration 'testB', timestampB

      assert.ok Migration.isBefore migrationA, migrationB


    it 'should return false when a.timestamp is after b.timestamp', ->

      timestampA  = (new Date()).getTime() + 1000
      timestampB  = (new Date()).getTime()
      migrationA  = Migration 'testA', timestampA
      migrationB  = Migration 'testB', timestampB

      assert.equal false, Migration.isBefore migrationA, migrationB


    it 'should return false when a.timestamp is equal to b.timestamp', ->

      timestamp   = (new Date()).getTime()
      migrationA  = Migration 'testA', timestamp
      migrationB  = Migration 'testB', timestamp

      assert.equal false, Migration.isBefore migrationA, migrationB


  describe 'isSame', ->

    it 'should return true when given an identical object', ->

      migration   = Migration 'test', (new Date()).getTime()
      assert.equal true, Migration.isSame migration, migration

    it 'should return true when the timestamp and name are equal', ->

      timestamp   = (new Date()).getTime()
      migrationA  = Migration 'test', timestamp
      migrationB  = Migration 'test', timestamp
      assert.equal true, Migration.isSame migrationA, migrationB

    
    it 'should return false when the timestamps are not equal', ->

      timestampA  = (new Date()).getTime() + 1000
      timestampB  = (new Date()).getTime()
      migrationA  = Migration 'test', timestampA
      migrationB  = Migration 'test', timestampB

      assert.equal false, Migration.isSame migrationA, migrationB


    it 'should return false when the names are not equal', ->

      timestamp   = (new Date()).getTime()
      migrationA  = Migration 'testA', timestamp
      migrationB  = Migration 'testB', timestamp

      assert.equal false, Migration.isSame migrationA, migrationB


    it 'should return false when the names and timestamps are not equal', ->

      timestampA  = (new Date()).getTime() + 1000
      timestampB  = (new Date()).getTime()
      migrationA  = Migration 'testA', timestampA
      migrationB  = Migration 'testB', timestampB

      assert.equal false, Migration.isSame migrationA, migrationB
