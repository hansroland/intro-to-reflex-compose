
# `DomBuilder`

## 

<!--
We layout DOM elements using a monad that is supplied by `reflex-dom`

## 

We'll be introducing some pieces of TodoMVC as we go

##
-->

```haskell
el :: DomBuilder t m 
   => Text 
   -> m a 
   -> m a
```

```haskell
text :: DomBuilder t m 
     => Text 
     -> m ()
```

## 

```haskell
el "div" $
  text "TODO"
```

<div class="demo" id="examples-dom-todo"></div>

<!--
##

We can use Dynamics to set up the JS to listen for changes and to make them happen, at the elements that need to change

##

Thanks to some internal magic, if you don't use an `Event` from a component then no listeners are set up for that `Event` 

##

The end result is doing the same thing a virtual DOM framework would do, but is eliding the diffs and patches

##

And we have finer grain control of what undergoes rendering changes
-->

##

```haskell
button :: DomBuilder t m 
       => Text 
       -> m (Event t ())
```

##

```haskell
todoItem :: MonadWidget t m 
         => Text 
         -> m (Event t ())
todoItem placeholder =
  el "div" $ do
    el "div" $ text placeholder
    button "Remove"
```

<div class="demo" id="examples-dom-todoitem-1"></div>

##

```haskell
dynText :: (PostBuild t m, DomBuilder t m) 
        => Dynamic t Text 
        -> m ()
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  el "div" $ do
    el "div" $ dynText dText
    button "Remove"
```

##

```haskell
el "div" $ mdo

  eRemove <- todoItem $ dText




  pure ()
```

##

```haskell
el "div" $ mdo

  eRemove <- todoItem $ dText

  dLabel <- holdDyn "" $ 
    " (Removed)" <$ eRemove

  pure ()
```

##

```haskell
el "div" $ mdo

  eRemove <- todoItem $ dText <> dLabel

  dLabel <- holdDyn "" $ 
    " (Removed)" <$ eRemove

  pure ()
```

##

```haskell
el "div" $ mdo

  eRemove <- todoItem $ dText <> dLabel

  dLabel <- holdDyn "" $ 
    " (Removed)" <$ eRemove

  pure ()
```

<div class="demo" id="examples-dom-todoitem-2"></div>

##

```haskell
elAttr    ::  DomBuilder t m 
          => Text 
          ->            Map Text Text 
          -> m a 
          -> m a
```

##

```haskell
elDynAttr :: (DomBuilder t m, PostBuild t m) 
          => Text 
          -> Dynamic t (Map Text Text) 
          -> m a 
          -> m a
```

##

```haskell
elClass    ::  DomBuilder t m 
           => Text 
           ->           Text 
           -> m a 
           -> m a
```

##

```haskell
elDynClass :: (DomBuilder t m, PostBuild t m) 
           => Text 
           -> Dynamic t Text 
           -> m a 
           -> m a
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  el      "div"             $  do

    el         "div"              $
      dynText dText

    eRemove <- button "Remove"




    pure eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  elClass "div"             $  do

    el         "div"              $
      dynText dText

    eRemove <- button "Remove"




    pure eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  elClass "div" "todo-item" $  do

    el         "div"              $
      dynText dText

    eRemove <- button "Remove"




    pure eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  elClass "div" "todo-item" $  do

    el         "div"              $
      dynText dText

    eRemove <- button "Remove"

    dRemoveClass <- holdDyn "" $
      "removed" <$ eRemove

    pure eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo

    el         "div"              $
      dynText dText

    eRemove <- button "Remove"

    dRemoveClass <- holdDyn "" $
      "removed" <$ eRemove

    pure eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"

    dRemoveClass <- holdDyn "" $
      "removed" <$ eRemove

    pure eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"

    dRemoveClass <- holdDyn "" $
      "removed" <$ eRemove

    pure eRemove
```

<div class="demo" id="examples-dom-todoitem-3"></div>

##

```haskell
data CheckboxConfig t = 
  CheckboxConfig { 
      _checkboxConfig_setValue   :: Event   t Bool
    , _checkboxConfig_attributes :: Dynamic t (Map Text Text)
    }
```

```haskell
instance Reflex t => Default (CheckboxConfig t) where ...
```

## 

```haskell
checkbox :: (...) 
         => Bool 
         -> CheckboxConfig t 
         -> m (Checkbox t)
```

## 

```haskell
data Checkbox t = 
  Checkbox { 
     _checkbox_value  :: Dynamic t Bool
   , _checkbox_change :: Event   t Bool
   }
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (              Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo
  

  

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"
    dRemoveClass <- holdDyn "" $ 
      "removed" <$ eRemove

    pure             eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (              Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo
    cb <- checkbox False def
  


    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"
    dRemoveClass <- holdDyn "" $ 
      "removed" <$ eRemove

    pure             eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (              Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo
    cb <- checkbox False def
    let
      eComplete = cb ^. checkbox_change

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"
    dRemoveClass <- holdDyn "" $ 
      "removed" <$ eRemove

    pure             eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t Bool, Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo
    cb <- checkbox False def
    let
      eComplete = cb ^. checkbox_change

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"
    dRemoveClass <- holdDyn "" $ 
      "removed" <$ eRemove

    pure             eRemove
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t Bool, Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo
    cb <- checkbox False def
    let
      eComplete = cb ^. checkbox_change

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"
    dRemoveClass <- holdDyn "" $ 
      "removed" <$ eRemove

    pure (eComplete, eRemove)
```

##

```haskell
todoItem :: MonadWidget t m 
         => Dynamic t Text 
         -> m (Event t Bool, Event t ())
todoItem dText =
  elClass "div" "todo-item" $ mdo
    cb <- checkbox False def
    let
      eComplete = cb ^. checkbox_change

    elDynClass "div" dRemoveClass $
      dynText dText

    eRemove <- button "Remove"
    dRemoveClass <- holdDyn "" $ 
      "removed" <$ eRemove

    pure (eComplete, eRemove)
```

<div class="demo" id="examples-dom-todoitem-4"></div>

##

```haskell
  ...
    let
      eComplete = cb ^. checkbox_change







    elDynClass "div"                    dRemoveClass  $ 
      dynText dText
  ...
```

##

```haskell
  ...
    let
      eComplete = cb ^. checkbox_change
      dComplete = cb ^. checkbox_value






    elDynClass "div"                    dRemoveClass  $ 
      dynText dText
  ...
```

##

```haskell
  ...
    let
      eComplete = cb ^. checkbox_change
      dComplete = cb ^. checkbox_value

      mkCompleteClass False = ""
      mkCompleteClass True  = "completed "



    elDynClass "div"                    dRemoveClass  $ 
      dynText dText
  ...
```

##

```haskell
  ...
    let
      eComplete = cb ^. checkbox_change
      dComplete = cb ^. checkbox_value

      mkCompleteClass False = ""
      mkCompleteClass True  = "completed "

      dCompleteClass = mkCompleteClass <$> dComplete

    elDynClass "div"                    dRemoveClass  $ 
      dynText dText
  ...
```

##

```haskell
  ...
    let
      eComplete = cb ^. checkbox_change
      dComplete = cb ^. checkbox_value

      mkCompleteClass False = ""
      mkCompleteClass True  = "completed "

      dCompleteClass = mkCompleteClass <$> dComplete

    elDynClass "div" (dCompleteClass <> dRemoveClass) $ 
      dynText dText
  ...
```

##

```haskell
  ...
    let
      eComplete = cb ^. checkbox_change
      dComplete = cb ^. checkbox_value

      mkCompleteClass False = ""
      mkCompleteClass True  = "completed "

      dCompleteClass = mkCompleteClass <$> dComplete

    elDynClass "div" (dCompleteClass <> dRemoveClass) $ 
      dynText dText
  ...
```

<div class="demo" id="examples-dom-todoitem-5"></div>

##

```haskell
clearComplete :: MonadWidget t m 
              => Dynamic t Bool 
              -> m (Event t ())
clearComplete dAnyComplete =
  let
    mkClass False = "hide"
    mkClass True  = ""
    dClass = mkClass <$> dAnyComplete
  in
    elDynClass "div" dClass $
      button "Clear complete"
```

<div class="demo" id="examples-dom-clear-complete"></div>

##

```haskell
markAllComplete :: MonadWidget t m 
                => Dynamic t Bool 
                -> m (Event t Bool)
markAllComplete dAllComplete = do
  cb <- checkbox False $
    def & checkboxConfig_setValue .~ updated dAllComplete

  text "Mark all as complete"

  pure $ cb ^. checkbox_change
```

<div class="demo" id="examples-dom-mark-all-complete"></div>

##

```haskell
data TextInputConfig t = 
  TextInputConfig { 
      _textInputConfig_inputType    :: Text
    , _textInputConfig_initialValue :: Text
    , _textInputConfig_setValue     :: Event t Text
    , _textInputConfig_attributes   :: 
        Dynamic t (Map Text Text)
    }
```

```haskell
instance Reflex t => Default (TextInputConfig t) where ...
```

##

```haskell
textInput :: (...) 
          => TextInputConfig t 
          -> m (TextInput t)
```

## 

```haskell
data TextInput t = 
  TextInput { 
      _textInput_value          :: Dynamic t Text
    , _textInput_input          :: Event t Text
    , _textInput_keypress       :: Event t Word
    , _textInput_keydown        :: Event t Word
    , _textInput_keyup          :: Event t Word
    , _textInput_hasFocus       :: Dynamic t Bool
    , _textInput_builderElement :: 
        InputElement EventResult GhcjsDomSpace t
    }
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def                                                      









  
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")








  
```

## 


```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")



  let
    bValue = current (ti ^. textInput_value)



  
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")



  let
    bValue = current (ti ^. textInput_value)
    eAtEnter = bValue <@ getKey ti Enter


  
```


## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")



  let
    bValue = current (ti ^. textInput_value)
    eAtEnter = bValue <@ getKey ti Enter
    eDone = ffilter (not . Text.null) eAtEnter

  
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")



  let
    bValue = current (ti ^. textInput_value)
    eAtEnter = bValue <@ getKey ti Enter
    eDone = ffilter (not . Text.null) eAtEnter

  pure eDone
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem =  do
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")
        & textInputConfig_setValue .~
            ("" <$ eDone)

  let
    bValue = current (ti ^. textInput_value)
    eAtEnter = bValue <@ getKey ti Enter
    eDone = ffilter (not . Text.null) eAtEnter

  pure eDone
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem = mdo
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")
        & textInputConfig_setValue .~
            ("" <$ eDone)

  let
    bValue = current (ti ^. textInput_value)
    eAtEnter = bValue <@ getKey ti Enter
    eDone = ffilter (not . Text.null) eAtEnter

  pure eDone
```

## 

```haskell
addItem :: MonadWidget t m 
        => m (Event t Text)
addItem = mdo
  ti <- textInput $
    def & textInputConfig_attributes .~
            pure ("placeholder" =: "What shall we do today?")
        & textInputConfig_setValue .~
            ("" <$ eDone)

  let
    bValue = current (ti ^. textInput_value)
    eAtEnter = bValue <@ getKey ti Enter
    eDone = ffilter (not . Text.null) eAtEnter

  pure eDone
```

<div class="demo" id="examples-dom-todoitem-6"></div>
