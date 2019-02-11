module Ipkg.Commands.Help

help : String
help = "
pkg -- Command line utility for Idris *.ipkg

new NAME   create a new package
build      build a package
help       print this message
"


export
perform : IO ()
perform = putStrLn help
