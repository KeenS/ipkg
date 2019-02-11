module Ipkg.Commands.Test

import Ipkg.Files
import System

export
perform: IO ()
perform = do
  Right ipkgs <- findIpkgsIn "."
  for_ ipkgs $ \ipkg =>
    system $ "idris --testpkg " ++ ipkg

