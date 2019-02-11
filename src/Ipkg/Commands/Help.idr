module Ipkg.Commands.Help

help : String
help = "
pkg -- Command line utility for Idris *.ipkg

new NAME   create a new project
help       print this message
"


export
perform : IO ()
perform = putStrLn help
