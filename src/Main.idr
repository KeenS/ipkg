module Main

import Ipkg.Commands

data Command : Type where
  New : (name : String) -> Command
  Build : Command
  Check : Command
  Test : Command
  Doc : Command
  Clean : Command
  Install : Command
  Help : Command
  Unknown : Command

help : String
help = "
pkg -- Command line utility for Idris *.ipkg

new NAME   Create a new package
build      Build package
check      Check package only
test       Run tests for package
doc        Generate IdrisDoc for package
clean      Clean package
install    Install package and the doc
help       Print this message
"




runCommand : Command -> IO ()
runCommand (New name) = Commands.New.perform name
runCommand Build = Commands.Build.perform
runCommand Check = Commands.Check.perform
runCommand Test = Commands.Test.perform
runCommand Doc = Commands.Doc.perform
runCommand Clean = Commands.Clean.perform
runCommand Install = Commands.Install.perform
runCommand Help = putStrLn help
runCommand Unknown = putStrLn help


total
parseArg : List String -> Command
parseArg ["new", name] = New name
parseArg ["build"] = Build
parseArg ["check"] = Check
parseArg ["test"] = Test
parseArg ["doc"] = Doc
parseArg ["clean"] = Clean
parseArg ["install"] = Install
parseArg ("help" :: _) = Help
parseArg _ = Unknown

main : IO ()
main = do
  (exe :: args) <- getArgs
  runCommand $ parseArg args

