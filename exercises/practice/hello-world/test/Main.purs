module Test.Main where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

import HelloWorld (helloWorld)

main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
  describe "HelloWorld.helloWorld" do
    it "Hello, World!" do
       helloWorld `shouldEqual` "Hello, World!"
