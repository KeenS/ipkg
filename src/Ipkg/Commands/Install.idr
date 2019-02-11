module Ipkg.Commands.Install

import Ipkg.Files
import System

export
perform: IO ()
perform = do
  Right ipkgs <- findIpkgsIn "."
  for_ ipkgs $ \ipkg => do
    system $ "idris --install " ++ ipkg
    system $ "idris --installdoc " ++ ipkg

