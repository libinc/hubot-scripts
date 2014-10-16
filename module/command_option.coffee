class CommandOption

  constructor: (@args) ->
    self = this
    @params = {}
    if @args?
      for field in @args.split(/\s+/)
        o = self.parse(field)
        @params[o.label] = o.value

  parse: (field) ->
    separatorIndex = field.indexOf(':');
    l = field.slice(0, separatorIndex)
    v = field.slice(separatorIndex + 1)
    v = v.split(',') if v.indexOf(',') >= 0
    { label: l, value: v } 

  data: () ->
    args = Array.prototype.slice.call(arguments)
    data = {}
    for key of @params
      data[key] = @params[key] if args.indexOf(key) >= 0
    return data

  query: () ->
    args = Array.prototype.slice.call(arguments)
    list = []
    for key of @params
      list.push("#{key}=#{@params[key]}") if args.indexOf(key) >= 0
    return list.join("&")

  get: (name) ->
    @params[name]

module.exports = CommandOption
