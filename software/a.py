from __future__ import annotations

import enum
import itertools
import json
from typing import Mapping, Optional, overload, Protocol, runtime_checkable

import attr
import cattr
from multipledispatch import dispatch

String = str


@runtime_checkable
class Iterable( Protocol ):

	def __iter__( self ):
		...


class Directionals( enum.Enum ):
	UP = "up"
	LEFT = "left"
	DOWN = "down"
	RIGHT = "right"


def coalesce( a, b ):
	if a is None:
		return b
	return a


@attr.define()
class KeyBind:
	key: String
	command: String
	when: Optional[ String ]
	arguments: Optional[ Mapping ]

	evolve = attr.evolve

	@classmethod
	def of( cls, record: Mapping[ String, String ] ) -> KeyBind:
		return KeyBind( key = record.get( "key" ),
		                command = record.get( "command" ),
		                when = record.get( "when", None ),
		                arguments = record.get( "arguments", None )
		                )

	def context( self ) -> String:
		return self.key + " @ " + coalesce( self.when, "always" )


@attr.define
class Comparison:
	default: KeyBind
	current: KeyBind
	imported: KeyBind


def contains_directional_key( keybind: KeyBind ):
	for directional in Directionals:
		if directional.value in keybind.key:
			if 'page' not in keybind.key:
				return True
	return False


def in_editor( keybind: KeyBind ):
	if "editor" in keybind.command:
		return True
	return False


def in_cursor( keybind: KeyBind ):
	if "cursor" in keybind.command:
		return True
	return False


def moot( *args, **kwargs ):
	return True


def alternate_directional_key( bind: String ) -> String:
	if "alt" not in bind:

		mapping = {
				Directionals.DOWN.value : "alt+k",
				Directionals.UP.value   : "alt+i",
				Directionals.LEFT.value : "alt+j",
				Directionals.RIGHT.value: "alt+l",
				}

		for key, value in mapping.items():
			bind = bind.replace( key, value )

	return bind


def create_alt_directional( binds: Iterable[ KeyBind ] ) -> Iterable[ KeyBind ]:
	for bind in binds:

		if contains_directional_key( bind ) and in_cursor( bind ):
			new_bind = alternate_directional_key( bind.key )
			yield bind.evolve( key = new_bind )


def relevant( bind: KeyBind ) -> bool:
	return contains_directional_key( bind ) and in_cursor( bind )


def is_negation( bind: KeyBind ) -> bool:
	return bind.key.startswith( "-" )


def from_path( path: String ) -> Iterable[ KeyBind ]:
	with open( path ) as file:
		lines: String = file.read()
	return map( KeyBind.of, json.loads( lines ) )


@overload
def pretty_print( it: Iterable ) -> None:
	...


@overload
def pretty_print( bind: KeyBind ) -> None:
	...


@dispatch( Iterable )
def pretty_print( it: Iterable ) -> None:
	all = ", ".join( map( unstructure, it ) )
	print( all )


@dispatch( KeyBind )
def pretty_print( bind: KeyBind ) -> None:
	print( unstructure( bind ) )


def unstructure( bind: KeyBind ) -> str:
	d = cattr.unstructure( bind )

	dels = [ ]
	for name, value in d.items():
		if value is None:
			dels.append( name )

	for name in dels:
		del d[ name ]
	return json.dumps( d, allow_nan = False )


def partition_with( func: Callable[ [ 'V' ], 'K' ], it: Iterable ) -> Mapping[ 'K', Iterable[ 'V' ] ]:
	result = { }
	for element in it:
		key = func( element )
		value = result.get( key, [ ] )
		value.append( element )

		result[ key ] = value

	return result


def negate( bind: KeyBind ):
	if bind.command.startswith( "-" ):
		return bind
	return attr.evolve( bind, command = "-" + bind.command )


def modify_original_directional_keybinds():
	defaults = from_path( "./vscode/windows-default.json" )
	interesting = filter( contains_directional_key, defaults )
	result = interesting

	t = {
			"down"            : "alt+k",
			"shift+down"      : "shift+alt+k",
			"ctrl+shift+down" : "ctrl+shift+alt+k",

			"up"              : "alt+i",
			"shift+up"        : "shift+alt+i",
			"ctrl+shift+up"   : "ctrl+shift+alt+i",

			"left"            : "alt+j",
			"shift+left"      : "shift+alt+j",
			"ctrl+shift+left" : "ctrl+shift+alt+j",

			"right"           : "alt+l",
			"shift+right"     : "shift+alt+l",
			"ctrl+shift+right": "ctrl+shift+alt+l",
			}

	transform = lambda x: (attr.evolve( x, key = t[ x.key ] ) if x.key in t else
	                       negate( x ))
	transformed = map( transform, result )

	partitioned = partition_with( lambda x: x.command.startswith( "-" ), transformed )

	return itertools.chain.from_iterable( partitioned.values() )


def remove_alternative_directional_keybinds():
	currents = from_path( "./vscode/current.json" )
	ft = lambda x: all( [ "alt+k" not in x.key,
	                      "alt+i" not in x.key,
	                      "alt+j" not in x.key,
	                      "alt+l" not in x.key,
	                      ] )
	interestings = filter( ft, currents )

	return interestings


if __name__ == '__main__':
	# currents = from_path( "./vscode/current.json" )
	# imported = from_path( "./vscode/imported.json" )

	modified_directionals = modify_original_directional_keybinds()
	removed = remove_alternative_directional_keybinds()

	pretty_print( modified_directionals )

# print( contexts )
# print( keys )
