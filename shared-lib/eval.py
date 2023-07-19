#! /opt/homebrew/bin/python3
import fileinput
import textwrap
import builtins

globaloutput = []
def print( x , **kwargs): 
    if x: 
        builtins.print( x , end = "") 
        globaloutput.append( x )

def id():
    import uuid
    return str(uuid.uuid4())

if __name__ == "__main__":
    cmd = textwrap.dedent( "\n".join( fileinput.input() ))
    size = len( cmd.split("\n") )

    try:
        output = eval( cmd ) 
    except SyntaxError:
        output = exec( cmd )

    if output and not globaloutput:
        print( output )
    elif globaloutput:
        ...
    else:
        print( cmd )

