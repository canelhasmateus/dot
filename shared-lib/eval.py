#! /opt/homebrew/bin/python3
import fileinput

if __name__ == "__main__":
    cmd = "\n".join( fileinput.input() )
    output = eval( cmd ) 
    if ( output ):
        print( output )
 

