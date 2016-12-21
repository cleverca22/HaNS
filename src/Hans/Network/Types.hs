{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE PatternSynonyms #-}

module Hans.Network.Types where

import Hans.Device.Types (Device,HasDeviceConfig(..))
import Hans.Lens

import Data.Serialize (Get,Put,getWord8,putWord8)
import Data.Word (Word8)


type NetworkProtocol = Word8

pattern PROT_ICMP4          = 0x1
pattern PROT_IP6            = 0x29 -- XXX: for implementing IPv6 encapsulation
pattern PROT_TCP            = 0x6
pattern PROT_UDP            = 0x11
pattern PROT_IP6_HOP_BY_HOP = 0x00
pattern PROT_IP6_ROUTING    = 0x2B
pattern PROT_IP6_FRAGMENT   = 0x2C
pattern PROT_IP6_ICMP       = 0x3A
pattern PROT_IP6_NO_NEXT    = 0x3B
pattern PROT_IP6_DEST_OPTS  = 0x3C

getNetworkProtocol :: Get NetworkProtocol
getNetworkProtocol  = getWord8

putNetworkProtocol :: NetworkProtocol -> Put
putNetworkProtocol  = putWord8


-- | Information about how to reach a specific destination address (source and
-- next-hop addresses, and device to use).
data RouteInfo addr = RouteInfo { riSource :: !addr
                                  -- ^ The source address to use when sending
                                , riNext :: !addr
                                  -- ^ The next-hop in the route
                                , riDev :: !Device
                                  -- ^ The device used for delivery
                                } deriving (Eq,Functor)

instance HasDeviceConfig (RouteInfo addr) where
  deviceConfig = to riDev . deviceConfig
