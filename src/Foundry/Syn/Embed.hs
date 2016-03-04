module Foundry.Syn.Embed where

import Data.Void

import Source.Syntax

import Foundry.Syn.Text
import Foundry.Syn.Common

data SynEmbed
  = SynEmbedFilePath SynText
  | SynEmbedURL SynText
  deriving (Eq, Ord, Show)

instance SynSelection SynEmbed Void

instance UndoEq SynEmbed where
  undoEq (SynEmbedFilePath t1) (SynEmbedFilePath t2) = undoEq t1 t2
  undoEq (SynEmbedURL      t1) (SynEmbedURL      t2) = undoEq t1 t2
  undoEq  _                     _                    = False

instance n ~ Int => SyntaxLayout n ActiveZone LayoutCtx SynEmbed where
  layout _ = pure (text "Embed")

instance n ~ Int => SyntaxReact n ActiveZone SynEmbed where
