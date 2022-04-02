import json
import pathlib
import sys
from typing import Mapping
from tqdm import tqdm

sys.path.append( "." )

from previews import getPreviewFromUrl

VAULT_LISTS = pathlib.Path( r"C:\Users\Mateus\OneDrive\vault\Canelhas\others\lists" )
PREVIEW_ASSETS = r"C:\Users\Mateus\OneDrive\Assets\previews.json"


def parse_article_line( line ):
	line = line.strip()
	if line:
		components = line.split( " ", )
		article = ""
		if len( components ) == 1:
			article = components[ 0 ]
		elif len( components ) == 2:
			article = components[ 1 ]
		else:
			article = ""

		return article.strip()


def iter_articles( *files_to_iter ):
	for filename in files_to_iter:
		with open( filename, "r" ) as current_file:
			for line in current_file:
				article = parse_article_line( line )
				if article:
					yield article.strip( "/" )


def iter_all_but_queue( lists_path ):
	for filename in pathlib.Path( lists_path ).glob( "*.txt" ):

		if str( filename.name ) not in { "articlesQueue.txt" }:


def iter_read_queue( lists_path ):
	for filename in pathlib.Path( lists_path ).glob( "articlesQueue.txt" ):
		with open( filename, "r" ) as file:
			for line in file:
				yield parse_article_line( line )


def iter_all_articles( lists_path ):
	for filename in pathlib.Path( lists_path ).glob( "articles*.txt" ):
		print( "Yielding", filename )
		with open( str( filename ), "r" ) as article_list:
			for line in article_list:
				yield parse_article_line( line )


def download_missing_previews( previews_path ) -> Mapping[ str, object ]:
	print( "Downloading Missing Previews" )
	previews: Mapping[ str, object ] = json.load( open( previews_path, "r" ) )
	downloaded = 0
	for i, article_url in enumerate( tqdm( iter_all_articles( VAULT_LISTS ) ) ):
		if article_url not in previews:
			downloaded += 1
			previews[ article_url ] = getPreviewFromUrl( article_url )

	print( f"Downloaded {downloaded} urls" )
	json.dump( previews, open( previews_path, "w" ) )
	return previews


def remove_already_read( lists_path: pathlib.Path ):
	print( "Removing read articles from the read list" )

	all_but_queue = [ file for file in lists_path.glob( "article*.txt" ) if file.name not in { "articlesQueue.txt" } ]
	already_read = set( iter_articles( all_but_queue ) )

	seen = set()
	removed = 0
	temp_aux = lists_path / "temp_aux.txt"

	with open( str( temp_aux ), "w" ) as temp_file:

		for article_to_read in iter_read_queue( lists_path ):

			if article_to_read:
				article_to_read = article_to_read.strip( "/" )
				if article_to_read in seen or article_to_read in already_read:
					removed += 1
				else:
					temp_file.writelines( article_to_read + "\n" )
					seen.add( article_to_read )

	temp_aux.replace( list_archive / "articlesQueue.txt" )
	print( f"Removed {removed} articles from the read queue." )


def generate_js_list( lists_path ):
	queue = pathlib.Path( lists_path ) / "articlesQueue.txt"


if __name__ == '__main__':
	previews = download_missing_previews( PREVIEW_ASSETS )
	remove_already_read( VAULT_LISTS )
	generate_js_list( previews, )
