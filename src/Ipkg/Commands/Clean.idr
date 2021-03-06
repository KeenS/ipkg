module Ipkg.Commands.Clean

import Ipkg.Files
import System

export
perform: IO ()
perform = do
  Right ipkgs <- findIpkgsIn "."
  for_ ipkgs $ \ipkg =>
    system $ "idris --clean " ++ ipkg

