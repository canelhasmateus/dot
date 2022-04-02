import json
import pathlib
import sys
from typing import Mapping
from tqdm import tqdm

sys.path.append( "." )

from previews import getPreviewFromUrl

VAULT_LISTS = r"C:\Users\Mateus\OneDrive\vault\Canelhas\others\lists"
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


def iter_already_read( lists_path ):
	for filename in pathlib.Path( lists_path ).glob( "articles*.txt" ):
		if filename in ("articlesGood.txt", "articlesBad.txt", "articlesUnsure.txt", "articlesPremium.txt"):
			with open( filename, "r" ) as file:
				for line in file:
					yield parse_article_line( line )


def iter_read_queue( lists_path ):
	for filename in pathlib.Path( lists_path ).glob( "articlesReadQueue.txt" ):
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
	print("Downloading Missing Previews")
	previews: Mapping[ str, object ] = json.load( open( previews_path, "r" ) )

	for i, article_url in enumerate( tqdm( iter_all_articles( VAULT_LISTS ) ) ):
		if article_url not in previews:
			previews[ article_url ] = getPreviewFromUrl( article_url )

	json.dump( previews, open( previews_path, "w" ) )
	return previews

def remove_already_read( lists_path ):
	print("Removing read articles from the read list")
	list_archive = pathlib.Path( lists_path )
	temp_aux = list_archive / "temp_aux.txt"
	already_read = set( iter_already_read( lists_path ) )
	seen = set()
	with open( str( temp_aux ), "w" ) as temp_file:

		for article_to_read in iter_read_queue( lists_path ):
			if article_to_read:
				if article_to_read not in already_read and article_to_read not in seen:
					temp_file.write( article_to_read )
					seen.add( article_to_read)

	toRead = list_archive / "articlesReadQueue.txt"
	toRead.unlink()

	temp_aux.replace( str( toRead))


if __name__ == '__main__':
	previews = download_missing_previews( PREVIEW_ASSETS )
	remove_already_read( VAULT_LISTS )
