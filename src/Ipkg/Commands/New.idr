module Ipkg.Commands.New

data DirTemplate = File String String | Dir String (List DirTemplate)

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

export
perform : String -> IO ()
perform name = do
  result <- interpretTemplate $ binProjectTemplate name
  case result of
    Right () => pure ()
    Left err => printError err

