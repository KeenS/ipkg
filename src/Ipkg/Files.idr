module Ipkg.Files

ls : String -> IO (Either FileError (List String))
ls dir = do
  Right d <- dirOpen dir | Left err => pure (Left err)
  ret <- f d
  () <- dirClose d
  pure ret
where
  f : Directory -> IO (Either FileError (List String))
  f dir = do
    Right e <- dirEntry dir
      | Left err => pure (Right [])
    Right es <- f dir | Left err => pure (Left err)
    pure $ Right $ e :: es


export
findIpkgsIn : String -> IO (Either FileError (List String))
findIpkgsIn dir = do
  Right files <- ls dir | Left err => pure (Left err)
  pure $ Right $ filter (isSuffixOf ".ipkg") files
