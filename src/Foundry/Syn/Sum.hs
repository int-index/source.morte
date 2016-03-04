module Foundry.Syn.Sum where

import Control.Lens
import Data.Foldable

import Source.Syntax
import Foundry.Syn.Common

data SynAdd s1 s2 = SynAugend s1 | SynAddend s2
  deriving (Eq, Ord, Show)

makePrisms ''SynAdd

instance (SynSelection s1 sel1, SynSelection s2 sel2)
      => SynSelection (SynAdd s1 s2) () where
  synSelection = \case
    SynAugend s -> () <$ synSelection s
    SynAddend s -> () <$ synSelection s

instance (UndoEq s1, UndoEq s2)
      => UndoEq (SynAdd s1 s2) where
  undoEq (SynAugend s1) (SynAugend s2) = undoEq s1 s2
  undoEq (SynAddend s1) (SynAddend s2) = undoEq s1 s2
  undoEq  _              _             = False

instance (SyntaxLayout n la lctx s1, SyntaxLayout n la lctx s2)
      => SyntaxLayout n la lctx (SynAdd s1 s2) where
  layout = \case
    SynAugend s -> layout s
    SynAddend s -> layout s

instance (SyntaxReact n la s1, SyntaxReact n la s2)
      => SyntaxReact n la (SynAdd s1 s2) where
  react = asum [reactRedirect _SynAugend, reactRedirect _SynAddend]
  subreact = asum [subreactRedirect _SynAugend, subreactRedirect _SynAddend]

type family SynSum (s :: [*]) :: * where
  SynSum '[s] = s
  SynSum (s ': ss) = SynAdd s (SynSum ss)
