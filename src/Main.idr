module Main

import Ipkg.Commands

data Command : Type where
  New : (name : String) -> Command
  Help : Command
  Unknown : Command


runCommand : Command -> IO ()
runCommand (New name) = Commands.New.perform name
runCommand Help = Commands.Help.perform
runCommand Unknown = Commands.Help.perform


parseArg : List String -> Command
parseArg ["new", name] = New name
parseArg ("help" :: _) = Help
parseArg _ = Unknown

main : IO ()
main = do
  (exe :: args) <- getArgs
  runCommand $ parseArg args

