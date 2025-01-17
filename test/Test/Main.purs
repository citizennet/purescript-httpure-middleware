module Test.Main where

import Prelude

import Data.Time.Duration as Data.Time.Duration
import Effect as Effect
import Effect.Aff as Effect.Aff
import Effect.Class as Effect.Class
import Effect.Uncurried as Effect.Uncurried
import Foreign.Object as Foreign.Object
import HTTPure as HTTPure
import HTTPure.Middleware as HTTPure.Middleware
import HTTPure.Version as HTTPure.Version
import Node.Buffer as Node.Buffer
import Node.Encoding as Node.Encoding
import Node.Stream as Node.Stream
import Test.Unit as Test.Unit
import Test.Unit.Assert as Test.Unit.Assert
import Test.Unit.Main as Test.Unit.Main

main :: Effect.Effect Unit
main = Test.Unit.Main.runTest do
  Test.Unit.suite "HTTPure.Middleware" do
    Test.Unit.suite "combinedLogFormat" do
      Test.Unit.test "Doesn't alter the request" do
        request <- mockRequest
        originalResponse <- router request
        newResponse <- HTTPure.Middleware.combinedLogFormat router request
        Test.Unit.Assert.equal originalResponse.headers newResponse.headers
        Test.Unit.Assert.equal originalResponse.status newResponse.status

    Test.Unit.suite "commonLogFormat" do
      Test.Unit.test "Doesn't alter the request" do
        request <- mockRequest
        originalResponse <- router request
        newResponse <- HTTPure.Middleware.commonLogFormat router request
        Test.Unit.Assert.equal originalResponse.headers newResponse.headers
        Test.Unit.Assert.equal originalResponse.status newResponse.status

    Test.Unit.suite "developmentLogFormat" do
      Test.Unit.test "Doesn't alter the request" do
        request <- mockRequest
        originalResponse <- router request
        newResponse <- HTTPure.Middleware.developmentLogFormat router request
        Test.Unit.Assert.equal originalResponse.headers newResponse.headers
        Test.Unit.Assert.equal originalResponse.status newResponse.status

    Test.Unit.suite "log" do
      Test.Unit.test "Doesn't alter the request" do
        request <- mockRequest
        originalResponse <- router request
        newResponse <- HTTPure.Middleware.log logLifecycle router request
        Test.Unit.Assert.equal originalResponse.headers newResponse.headers
        Test.Unit.Assert.equal originalResponse.status newResponse.status

    Test.Unit.suite "timeout" do
      Test.Unit.test "Doesn't alter the request if it completes quickly" do
        request <- mockRequest
        originalResponse <- router request
        newResponse <- timeout router request
        Test.Unit.Assert.equal originalResponse.headers newResponse.headers
        Test.Unit.Assert.equal originalResponse.status newResponse.status

      Test.Unit.test "Aborts the request if it takes too long" do
        request <- mockRequest
        response <- timeout slowRouter request
        Test.Unit.Assert.equal 500 response.status

logLifecycle :: HTTPure.Middleware.LogLifecycle Unit
logLifecycle = { after: mempty, before: mempty }

mockRequest :: Effect.Aff.Aff HTTPure.Request
mockRequest = do
  buffer <-
    Effect.Class.liftEffect
      $ Node.Buffer.fromString "Testing" Node.Encoding.UTF8
  body <- Effect.Class.liftEffect (readableFromBuffer buffer)
  pure
    { body
    , headers: HTTPure.header "Content-Type" "text/plain"
    , httpVersion: HTTPure.Version.HTTP1_1
    , method: HTTPure.Patch
    , path: ["foo", "bar", "baz.html"]
    , query: Foreign.Object.fromHomogeneous { qux: "gar" }
    , url: "/foo/bar/baz.html"
    }

router :: HTTPure.Request -> HTTPure.ResponseM
router _ = HTTPure.notFound' (HTTPure.header "content-length" "0")

slowRouter :: HTTPure.Request -> HTTPure.ResponseM
slowRouter _ = do
  Effect.Aff.delay (Data.Time.Duration.Milliseconds 1000.0)
  HTTPure.noContent

timeout :: HTTPure.Middleware.Middleware
timeout = HTTPure.Middleware.timeout (Data.Time.Duration.Milliseconds 100.0)

foreign import _readableFromBuffer ::
  Effect.Uncurried.EffectFn1
    Node.Buffer.Buffer
    (Node.Stream.Readable ())

readableFromBuffer :: Node.Buffer.Buffer -> Effect.Effect (Node.Stream.Readable ())
readableFromBuffer buffer = Effect.Uncurried.runEffectFn1 _readableFromBuffer buffer
  
