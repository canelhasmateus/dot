from __future__ import annotations

import itertools
import json
import pathlib
import re
from typing import Mapping

import requests
from lxml import etree
from tqdm import tqdm

RESULT_PATH = pathlib.Path( __file__ ).parent.joinpath( "content.json" )

myList = [
"https://blog.acolyer.org/2015/03/20/out-of-the-tar-pit/"
		]
String = str
regex = re.compile( r"(.+?)(?=/|$)" )


def toText( e ):
	return map( lambda x: x.text, e )


def toAttrib( attr, e ):
	return map( lambda x: x.get( attr ), e )


def first( *args ):
	for i in itertools.chain.from_iterable( args ):
		if i:
			return i
	return ""


def getDuration(html : etree._Element):
	duration = toAttrib( "content",
	                      html.xpath( "//meta[@name='duration']" ) )


	return first( duration )

def getTitle( html: etree._Element ) -> String:
	ogTitle = toAttrib( "content",
	                    html.xpath( "//meta[@name='og:title']" ) )
	twitterTitle = toAttrib( "content",
	                         html.xpath( "//meta[@name='twitter:title']" ) )
	itemProp = toAttrib( "content",
	                     html.xpath( "//meta[@itemprop='name']" ) )

	articleTitle = toText( html.xpath( "//article/h1" ) )
	titleFromHead = toText( html.xpath( "//head/title" ) )
	titleFromAnywhere = toText( html.xpath( "//title" ) )

	return first(
			ogTitle, twitterTitle, itemProp,
			articleTitle, titleFromHead, titleFromAnywhere )


def getDescription( html: etree._Element ) -> String:
	metaDescr = toAttrib( "content",
	                      html.xpath( "//meta[@name='description']" ) )

	ogDescr = toAttrib( "content",
	                    html.xpath( "//meta[@name='og:description']" ) )

	twitterDescr = toAttrib( "content",
	                         html.xpath( "//meta[@name='twitter:description']" ) )

	itemProp = toAttrib( "content",
	                     html.xpath( "//meta[@itemprop='description']" ) )

	articleParagraph = toText( html.xpath( "//article//p" ) )
	anyParagraph = toText( html.xpath( "//p" ) )

	return first( ogDescr, twitterDescr, itemProp, metaDescr,
	              articleParagraph, anyParagraph )


def getImage( html: etree._Element ) -> String:
	ogImage = toAttrib( "content",
	                    html.xpath( "//meta[@property='og:image']" ) )
	twitterImage = toAttrib( "content",
	                         html.xpath( "//meta[@name='twitter:image']" ) )

	itemProp = toAttrib( "content",
	                     html.xpath( "//meta[@itemprop='image']" ) )

	headIcon = toAttrib( "href",
	                     html.xpath( "//head/link[@rel='icon']" ) )

	anyImage = toAttrib( "src",
	                     html.xpath( "//img" ) )

	return first( ogImage, twitterImage, itemProp, headIcon, anyImage )


def getDomain( response, html ):
	url = response.url
	for pattern in [ r"http://", r"https://", r"www\." ]:
		url = re.sub( pattern, "", url )

	return re.search( regex, url ).group( 0 )


def getHtmlPreview( response ) -> Mapping[ String, String ]:
	html: etree._Element = etree.HTML( response.content )
	preview = {
			"title"      : getTitle( html ),
			"description": getDescription( html ),
			"image"      : getImage( html ),
			"domain"     : getDomain( response, html ),
			"url"        : response.url,
			}
	return preview


def retry( f, n ):
	for i in range( n ):
		try:
			return f()
		except Exception as e:
			print( e )


def isEqual( a: Mapping[ String, String ], b: Mapping[ String, String ] ) -> bool:
	for aKey, aItem in a.items():
		bItem = b[ aKey ]
		if bItem.lower() != aItem.lower():
			return False
	for bKey, bItem in b.items():
		aItem = a[ bKey ]
		if bItem.lower() != aItem.lower():
			return False
		...

	return True


def testPreview( url, preview ):
	expected = None
	if url == 'https://www.atomiccommits.io/information-theory-with-monica-from-friends':
		expected = {
				"title"      : 'Information Theory with Monica from Friends',
				"description": 'I am a blog',
				"image"      : "/ships-lineal/png/007-barque.png",
				"domain"     : "atomiccommits.io",
				"url"        : url
				}
	if url == '12 Atomic Experiments in Deep Learning [Notebook]':
		expected = {
				"title"      : 'What Inception Net Doesn\'t See',
				"description": "Deep learning-based comuter vision models like Inception Net have achieved state-of-the-art performance on image recognition. However, that doesn't mean that they "
				               "don't have blindspots and biases. Here's a few of them, along with interactive aplications for you to try it out yourself.",
				"image"      : "https://abidlabs.github.io/images/posts/2021-02-12/geese1.png",
				"domain"     : 'abidlabs.github.io',
				"url"        : url
				}

	if expected:
		assert isEqual( preview, expected )


def getPreview( response ):
	headers = response.headers
	content = headers[ "content-type" ]

	if content.startswith( "text/html" ):
		return getHtmlPreview( response )
	else:
		return {
				"url": response.url
				}


def getPreviewFromUrl( url ):
	doIt = lambda: requests.get( url, headers = {
			"user-agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36 RuxitSynthetic/1.0 "
			              "v4483641760525505621 t4157550440124640339"
			} )

	response = retry( doIt, 3 )

	res = None
	if response:
		res = getPreview( response )
	return res


def getResults():
	if RESULT_PATH.exists():
		with open( str( RESULT_PATH ), "r" ) as file:
			return json.loads( file.read() )

	return [ ]


results = getResults()
for i, url in enumerate( tqdm( myList ) ):
	if i < len( results ):
		continue

	doIt = lambda: requests.get( url, headers = {
			"user-agent": "Mozilla/5.0 (X11; Ubuntu; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.87 Safari/537.36 RuxitSynthetic/1.0 "
			              "v4483641760525505621 t4157550440124640339"
			} )

	response = retry( doIt, 3 )

	if response:
		preview = getPreview( response )
		results.append( preview )

	if (i % 200 == 0):
		s = json.dumps( results )
		with open( str( RESULT_PATH ), "w" ) as f:
			f.write( s )
