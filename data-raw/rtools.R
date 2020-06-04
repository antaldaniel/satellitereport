

Sys.setenv(PATH = paste(Sys.getenv("PATH"),
                        "C:\\rtools40",
                        "C:\\rtools40\\mingw64\\bin",
                        sep = ";"))
Sys.getenv("PATH")
