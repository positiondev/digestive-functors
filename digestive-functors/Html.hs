{-# LANGUAGE OverloadedStrings #-}
module Html where

import Control.Monad (mplus)
import Data.Maybe (fromMaybe)

import Data.Text (Text)
import Text.Blaze (Html, (!))
import qualified Data.Text as T
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A

import Field

--------------------------------------------------------------------------------

fieldInput :: Text -> View v a -> Text
fieldInput ref view = fromMaybe "" $ mplus givenInput defaultInput
  where
    path         = toPath ref
    givenInput   = lookup path $ viewInput view
    defaultInput = case lookupForm path (viewForm view) of
        (SomeForm f : _) -> formDefaultInput f

--------------------------------------------------------------------------------

inputText :: Text -> View v a -> Html
inputText ref view = H.input
    ! A.type_ "text"
    ! A.id    (H.toValue ref)
    ! A.name  (H.toValue ref)
    ! A.value (H.toValue $ fieldInput ref view)

--------------------------------------------------------------------------------

test01_ :: View v a -> Html
test01_ = do
    inputText "name"
    inputText "age"
    inputText "sex"