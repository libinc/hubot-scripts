source = '../scripts/lgtm'
expect = require('chai').expect

Robot       = require('hubot/src/robot')  
TextMessage = require('hubot/src/message').TextMessage

describe 'lgtm', ->  
  robot = null
  user = null
  adapter = null

  beforeEach (done) ->
    robot = new Robot(null, 'mock-adapter', false, 'hubot')

    robot.adapter.on 'connected', ->
      require(source)(robot)
      user = robot.brain.userForId '1',
        name: 'mocha'
        room: '#mocha'
      adapter = robot.adapter
      done()
    robot.run()

  afterEach -> robot.shutdown()

  it 'should respond to a LGTM image', (done) ->
    adapter.on 'send', (envelope, strings) ->
      try
        expect(strings[0]).to.match(/^https?:\/\//)
        done()
      catch e
        done e

    adapter.receive(new TextMessage(user, 'lgtm'))

  it 'should respond to a tiqav image', (done) ->
    adapter.on 'send', (envelope, strings) ->
      try
        expect(strings[0]).to.match(/^https?:\/\/tiqav\.com\//)
        done()
      catch e
        done e

    adapter.receive(new TextMessage(user, 'hubot reply thanks'))

