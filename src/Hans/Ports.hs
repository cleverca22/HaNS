
module Hans.Ports (
    -- * Port Management
    PortManager
  , emptyPortManager
  , isReserved
  , reserve
  , unreserve
  , nextPort
  ) where

import Control.Monad (guard)
import Data.List (delete)
import qualified Data.Set as Set


-- Port Management -------------------------------------------------------------

data PortManager i = PortManager
  { portNext   :: [i]
  , portActive :: Set.Set i
  }

instance Show i => Show (PortManager i) where
  show pm = "<Active ports: " ++ show (portActive pm) ++ ">"

emptyPortManager :: [i] -> PortManager i
emptyPortManager range = PortManager
  { portNext   = range
  , portActive = Set.empty
  }

isReserved :: (Eq i, Ord i) => i -> PortManager i -> Bool
isReserved i pm = i `Set.member` portActive pm

reserve :: (Eq i, Ord i, Show i) => i -> PortManager i -> Maybe (PortManager i)
reserve i pm = do
  guard (not (isReserved i pm))
  return $! pm
    { portActive = Set.insert i (portActive pm)
    }

unreserve :: (Eq i, Ord i, Show i) => i -> PortManager i -> Maybe (PortManager i)
unreserve i pm = do
  guard (isReserved i pm)
  return $! pm
    { portNext   = i : portNext pm
    , portActive = Set.delete i (portActive pm)
    }

nextPort :: (Eq i, Ord i, Show i) => PortManager i -> Maybe (i, PortManager i)
nextPort pm = case span (`isReserved` pm) (portNext pm) of

  (_,i:rest) -> return (i, pm { portNext = rest
                              , portActive = Set.insert i (portActive pm) })

  _ -> Nothing
