module Main

data DirTemplate = File String String | Dir String (List DirTemplate)

data Command : Type where
  New : (name : String) -> Command
  Help : Command
  Unknown : Command

printError : FileError -> IO ()
printError err = printLn err

interpretTemplate : DirTemplate -> IO (Either FileError ())
interpretTemplate tmpl = inner "./" tmpl
where
  inner : String -> DirTemplate -> IO (Either FileError ())
  inner dir (File name content) = writeFile (dir ++ "/" ++ name) content
  inner dir (Dir name children) = do
    let dir = dir ++ "/" ++ name
    result <- createDir dir
    foldlM (\prev, tmpl => case prev of
        Right () => inner dir tmpl
        Left err => pure <$> printError err) result children

binProjectTemplate : String -> DirTemplate
binProjectTemplate name = Dir name [
  File (name ++ ".ipkg") ("package " ++ name ++ "

version = \"0.1.0\"

sourcedir = src
modules = Main
main = Main
executable = " ++ name ++ "
pkgs = contrib
"),
  Dir "src" [
    File "Main.idr" "module Main

main : IO ()
main = putStrLn \"Hello, World\"
"
  ]
]

createProject : String -> IO ()
createProject name = do
  result <- interpretTemplate $ binProjectTemplate name
  case result of
    Right () => pure ()
    Left err => printError err

help : String
help = "
pkg -- Command line utility for Idris *.ipkg

new NAME   create a new project
help       print this message
"

runCommand : Command -> IO ()
runCommand (New name) = createProject name
runCommand Help = putStrLn help
runCommand Unknown = putStrLn help


parseArg : List String -> Command
parseArg ["new", name] = New name
parseArg ("help" :: _) = Help
parseArg _ = Unknown

main : IO ()
main = do
  (exe :: args) <- getArgs
  runCommand $ parseArg args

