from __future__ import annotations

import enum
import itertools
import json
import pathlib
from asyncio import coroutine
from typing import (Callable, Coroutine, Generator, Iterable, List, Mapping,
                    Optional, Protocol, Set, TypeAlias, TypeVar, Union,
                    overload, runtime_checkable)

import attr
import cattr

K = TypeVar( "K")
V = TypeVar( "V")
T = TypeVar( "T")

String = str
Json = Mapping[String , object]
Transformation =  None |  T | Iterable[ T ] 
Transformer = Callable[ [ K ] ,  Transformation[ K ] ]
Nested = T  |  Iterable[T]   | Iterable[ "Nested[T]" ]




class Directionals( enum.Enum ):
	UP = "up"
	LEFT = "left"
	DOWN = "down"
	RIGHT = "right"

class KeybindStatus( enum.Enum ):
	POSITIVE = "positive"
	NEGATIVE = "negative"
	

@attr.define()
class KeyBind:
	key: String
	command: String
	when: Optional[ String ]
	arguments: Optional[ Mapping ]

	evolve = attr.evolve
	
	
	
	@classmethod
	def of( cls, record: Json) -> KeyBind:
		return KeyBind( key = record.get( "key" ),
		                command = record.get( "command" ),
		                when = record.get( "when", None ),
		                arguments = record.get( "arguments", None )
		                )
	
	def status(self) -> Set( KeybindStatus ) :
		res = set()
		if self.command.startswith( "-"):
			res.add( KeybindStatus.NEGATIVE)
		else :
			res.add( KeybindStatus.POSITIVE)
		
		return res
	
		
	def context( self ) -> String:
		return self.key + " @ " + coalesce( self.when, "always" )


def contents( filepath : String ) -> List[Json]:
	path = pathlib.Path( filepath ) 
	file_handle = open( path , "r")
	return json.load( file_handle )
	

def negation( keybind : KeyBind ) -> KeyBind:
	
	if KeybindStatus.NEGATIVE in keybind.status():
		return keybind

	return KeyBind.evolve( keybind , command = "-" + keybind.command )


			


def fanout(*subscribers : Iterable[ Transformer[ T ] ] ) -> Callable[ [T ], Transformation[T]]:
	
	def gen( message : T):
		for transformation  in subscribers:
			result = transformation( message ) 
			
			if not result:
				continue
			
			if isinstance( result , Iterable):
				for element in result:
					yield element
			else:
				yield result
			return
			
	return gen

	



	


if __name__ == '__main__':
	
	path = r"C:\Users\Mateus\OneDrive\dot\software\vscode\default-keybindings.json"
	default_keybinds = map( KeyBind.of, 
							contents(  path ) )
	
	distribute = fanout( negation )


	for element in default_keybinds :
		for reply in distribute( element ):
			print( type(reply) ) 
			
			
	
		
