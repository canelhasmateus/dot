from __future__ import annotations
import pathlib
import hashlib

def checksum( file : pathlib.Path ):
    with open( file , "rb") as handle:
        content = handle.read()

    return hashlib.md5(content).hexdigest()

if __name__ == "__main__":

    path = pathlib.Path("C:/Users/Mateus/Downloads/to_upload")
    seen = set()
    for file in path.glob("**/*.*"):
        hash = checksum( file )
        if hash in seen:
            print( str( file ))
            file.unlink()
        else:
            seen.add( hash )