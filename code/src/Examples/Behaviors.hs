{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE RecursiveDo #-}
module Examples.Behaviors (
    attachBehaviorExamples
  ) where

import Reflex.Dom.Core
import GHCJS.DOM.Types (MonadJSM)

import Colour

import Util.Reflex
import Util.Attach
import Util.Grid

attachBehaviorExamples ::
  MonadJSM m =>
  m ()
attachBehaviorExamples = do
  attachId_ "examples-behaviors-sampleBlue1" $
    wrapDemo sampleBlue1 mkRedBlueInput
  attachId_ "examples-behaviors-sampleBlue2" $
    wrapDemo sampleBlue2 mkRedBlueInput
  attachId_ "examples-behaviors-sampleFlipBlue" $
    wrapDemo sampleFlipBlue mkRedBlueInput
  attachId_ "examples-behaviors-sampleAlwaysBlue" $
    wrapDemo (const $ pure . sampleAlwaysBlue) mkRedBlueInput
  attachId_ "examples-behaviors-samplePair" $
    wrapDemo2 samplePair mkRedBlueInput

sampleBlue1 :: (Reflex t, MonadHold t m)
            => Event t Colour
            -> Event t ()
            -> m (Event t Colour)
sampleBlue1 eColour eSample = do
  bColour <- hold Blue eColour
  pure $ tag bColour eSample

sampleBlue2 :: (Reflex t, MonadHold t m)
            => Event t Colour
            -> Event t ()
            -> m (Event t Colour)
sampleBlue2 eColour eSample = do
  bColour <- hold Blue eColour
  let eAny = leftmost [() <$ eColour, eSample]
  pure $ tag bColour eAny

sampleFlipBlue :: (Reflex t, MonadHold t m)
               => Event t Colour
               -> Event t ()
               -> m (Event t Colour)
sampleFlipBlue eColour eSample = do
  bColour <- hold Blue eColour
  let bFlippedColour = flipColour <$> bColour
  pure $ tag bFlippedColour eSample

sampleAlwaysBlue :: Reflex t
                 => Event t ()
                 -> Event t Colour
sampleAlwaysBlue eSample =
  tag (pure Blue) eSample

samplePair :: (Reflex t, MonadHold t m)
           => Event t Colour
           -> Event t Colour
           -> Event t ()
           -> m (Event t (Colour, Colour))
samplePair eInput1 eInput2 eSample = do
  bColour1 <- hold Blue eInput1
  bColour2 <- hold Blue eInput2
  let bPair = (,) <$> bColour1 <*> bColour2
  pure $ tag bPair eSample

wrapDemo ::
  ( MonadWidget t m
  , Square a
  , Square b) =>
  (Event t a -> Event t () -> m (Event t b)) ->
  m (Event t a) ->
  m ()
wrapDemo guest mkIn = divClass "panel panel-default" . divClass "panel-body" $ mdo
  let w = runDemo guest eInput eSample
  _ <- widgetHold w (w <$ eReset)
  (eInput, eSample, eReset) <- el "div" $ do
    eInput <- mkIn
    eSample <- buttonClass "btn btn-default" "Sample"
    eReset <- buttonClass "btn btn-default pull-right" "Reset"
    return (eInput, eSample, eReset)
  return ()

runDemo ::
  ( MonadWidget t m
  , Square a
  , Square b
  ) =>
  (Event t a -> Event t () -> m (Event t b)) ->
  Event t a ->
  Event t () ->
  m ()
runDemo guest eInput eSample = do
  eOutput <- guest eInput eSample

  dInputs <- foldDyn (:) [] .
             leftmost $ [
                 Just <$> eInput
               , Nothing <$ eOutput
               ]

  dOutputs <- foldDyn (:) [] .
              leftmost $ [
                  Just <$> eOutput
                , Nothing <$ eInput
                ]

  drawGrid
    defaultGridConfig
    [ Row "eInput" 1 dInputs
    , Row "eOutput" 3 dOutputs
    ]

wrapDemo2 ::
  ( MonadWidget t m
  , Square a
  , Square b) =>
  (Event t a -> Event t a -> Event t () -> m (Event t b)) ->
  m (Event t a) ->
  m ()
wrapDemo2 guest mkIn = divClass "panel panel-default" . divClass "panel-body" $ mdo
  let w = runDemo2 guest eInput1 eInput2 eSample
  _ <- widgetHold w (w <$ eReset)
  (eInput1, eInput2, eSample, eReset) <- el "div" $ do
    eInput1 <- mkIn
    eInput2 <- mkIn
    eSample <- buttonClass "btn btn-default" "Sample"
    eReset <- buttonClass "btn btn-default pull-right" "Reset"
    return (eInput1, eInput2, eSample, eReset)
  return ()

runDemo2 ::
  ( MonadWidget t m
  , Square a
  , Square b
  ) =>
  (Event t a -> Event t a -> Event t () -> m (Event t b)) ->
  Event t a ->
  Event t a ->
  Event t () ->
  m ()
runDemo2 guest eInput1 eInput2 eSample = do
  eOutput <- guest eInput1 eInput2 eSample

  dInput1 <- foldDyn (:) [] .
             leftmost $ [
                 Just <$> eInput1
               , Nothing <$ eInput2
               , Nothing <$ eOutput
               ]

  dInput2 <- foldDyn (:) [] .
             leftmost $ [
                 Just <$> eInput2
               , Nothing <$ eInput1
               , Nothing <$ eOutput
               ]

  dOutputs <- foldDyn (:) [] .
              leftmost $ [
                  Just <$> eOutput
                , Nothing <$ eInput1
                , Nothing <$ eInput2
                ]

  drawGrid
    (defaultGridConfig { _gcRows = 7})
    [ Row "eInput1" 1 dInput1
    , Row "eInput2" 3 dInput2
    , Row "eOutput" 5 dOutputs
    ]

