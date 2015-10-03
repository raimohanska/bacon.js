class Some
  _isSome: true

  constructor: (@value) ->
  getOrElse: -> @value
  get: -> @value
  filter: (f) ->
    if f @value
      new Some(@value)
    else
      None
  map: (f) ->
    new Some(f @value)
  forEach: (f) ->
    f @value
  isDefined: true
  toArray: -> [@value]
  inspect: -> "Some(" + @value + ")"
  toString: -> @inspect()

None = {
  _isNone: true
  getOrElse: (value) -> value
  filter: -> None
  map: -> None
  forEach: ->
  isDefined: false
  toArray: -> []
  inspect: -> "None"
  toString: -> @inspect()
}

toOption = (v) ->
  if v?._isSome or v?._isNone
    v
  else
    new Some(v)
