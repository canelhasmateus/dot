import json
import pathlib
import random
import subprocess
import sys
import time

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

def iter_articles( files_to_iter ):
	for filename in files_to_iter:
		filename = str( filename )
		print( "Yielding", filename )
		with open( filename, "r" ) as current_file:
			for line in current_file:
				try:
					article = parse_article_line( line )
					if article:
						yield article.strip( "/" )
				except Exception as e:
					print("Error parsing")

def download_missing_previews( previews_path ) -> Mapping[ str, object ]:
	print( "Downloading Missing Previews" )
	try :
		previews: Mapping[ str, object ] = json.load( open( previews_path, "r" ) )
	except Exception:
		previews = {}

	downloaded = 0
	files = [ i for i in pathlib.Path( VAULT_LISTS ).glob( "*.txt" ) ]

	for i, article_url in enumerate( tqdm( iter_articles( files ) ) ):
		if article_url not in previews:
			downloaded += 1
			previews[ article_url ] = getPreviewFromUrl( article_url )
			if (downloaded % 100) == 0:
				json.dump( previews, open( previews_path, "w" ) )
		
	print( f"Downloaded {downloaded} urls" )
	json.dump( previews, open( previews_path, "w" ) )
	return previews

def remove_already_read( lists_path: pathlib.Path ):
	print( "Removing read articles from the read list" )

	all_but_queue = [ str( file ) for file in lists_path.glob( "*.txt" ) if file.name not in { "articlesQueue.txt" } ]
	already_read = set( iter_articles( all_but_queue ) )

	article_queue = pathlib.Path( lists_path ) / "articlesQueue.txt"
	seen = set()

	removed = 0
	temp_aux = lists_path / "temp_aux.txt"
	with open( str( temp_aux ), "w" ) as temp_file:

		for queued_article in iter_articles( [ article_queue ] ):

			if queued_article:
				queued_article = queued_article.strip( "/" )
				if queued_article in seen or queued_article in already_read:
					removed += 1
				else:
					temp_file.writelines( queued_article + "\n" )
					seen.add( queued_article )

	temp_aux.replace( str( article_queue ) )
	print( f"Removed {removed} articles from the read queue." )

def generate_js_list( previews, lists_path ):
	print( f"Generating ts file." )
	queue = pathlib.Path( lists_path ) / "articlesQueue.txt"
	queued_articles = [ i for i in iter_articles( [ queue ] ) ]
	choosen_articles = random.choices( queued_articles, k = 300 )
	results = [ ]
	for article in choosen_articles:
		try:

			article_preview = previews[ article ]
			results.append( article_preview )

		except KeyError:
			continue

	preview_contents = json.dumps( results, indent = 4, sort_keys = True )
	preview_contents = """
	import type { Preview } from "./interface";
	
	export const list : Array< Preview > = """ + preview_contents

	project = r"C:\Users\Mateus\Desktop\workspace\canHome"
	ts_loc = pathlib.Path( r"C:\Users\Mateus\Desktop\workspace\canHome\src\lists\readlistA.ts" )
	with open( str( ts_loc ), "w" ) as ts_file:
		ts_file.write( preview_contents )

	process = subprocess.run( f"npm run --prefix {project} deploy" ,
	                          universal_newlines = True , shell = True)

	print( f"Generated HTML." )
if __name__ == '__main__':
	previews = download_missing_previews( PREVIEW_ASSETS )
	remove_already_read( VAULT_LISTS )
	generate_js_list( previews, VAULT_LISTS )
	input("Waiting to exit.")
