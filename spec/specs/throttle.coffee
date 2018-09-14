require("../../src/throttle")
Bacon = require("../../src/core").default
expect = require("chai").expect

{
  expectStreamEvents,
  expectStreamTimings,
  expectPropertyEvents,
  error,
  semiunstable,
  lessThan,
  map,
  fromArray
  series,
  repeat,
  t,
  once
} = require("../SpecHelper")

describe "EventStream.throttle(delay)", ->
  describe "outputs at steady intervals, without waiting for quiet period", ->
    expectStreamTimings(
      -> series(2, [1, 2, 3]).throttle(t(3))
      [[5, 2], [8, 3]])
  describe "works with synchronous source", ->
    expectStreamEvents(
      -> fromArray([1, 2, 3]).throttle(t(3))
      [3])
  it "toString", ->
    expect(Bacon.never().throttle(1).toString()).to.equal("Bacon.never().throttle(1)")

describe "EventStream.throttleImmediate(delay)", ->
  describe "outputs first event immediately, then ignores events for given amount of milliseconds", ->
    expectStreamTimings(
      -> series(2, [1, 2, 3, 4]).throttleImmediate(t(3))
      [[2, 1], [5, 2], [8, 3], [11, 4]], semiunstable)
  describe "works with synchronous source", ->
    expectStreamEvents(
      -> fromArray([1, 2, 3, 4]).throttleImmediate(t(3))
      [1, 4], semiunstable)
  describe "does not emit double events with synchronous source", ->
    expectStreamEvents(
      -> fromArray([1]).throttleImmediate(t(1))
      [1], semiunstable)
  it "toString", ->
    expect(Bacon.never().throttleImmediate(1).toString()).to.equal("Bacon.never().throttleImmediate(1)")

describe "Property.throttle", ->
  describe "throttles changes, but not initial value", ->
    expectPropertyEvents(
      -> series(1, [1,2,3]).toProperty(0).throttle(t(4))
      [0,3])
  describe "works with Bacon.once (bug fix)", ->
    expectPropertyEvents(
      -> once(1).toProperty().throttle(1)
      [1])
  it "toString", ->
    expect(Bacon.constant(0).throttle(1).toString()).to.equal("Bacon.constant(0).throttle(1)")

describe "Property.throttleImmediate", ->
  describe "throttles changes, but not initial value", ->
    expectPropertyEvents(
      -> series(1, [1,2,3]).toProperty(0).throttleImmediate(t(4))
      [0,3], semiunstable)
  describe "works with Bacon.once", ->
    expectPropertyEvents(
      -> once(1).toProperty().throttleImmediate(1)
      [1], semiunstable)
  it "toString", ->
    expect(Bacon.constant(0).throttleImmediate(1).toString()).to.equal("Bacon.constant(0).throttleImmediate(1)")
