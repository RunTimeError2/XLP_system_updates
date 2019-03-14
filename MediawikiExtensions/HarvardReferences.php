<?php
// This extension provides references in Harvard (Author-date) style to MediaWiki.
// Instructions and samples see at http://www.mediawiki.org/wiki/Extension:HarvardReferences

if ( ! defined( 'MEDIAWIKI' ) )	die();

// function wfHarvardReferences - see below 
if ( defined( 'MW_SUPPORTS_PARSERFIRSTCALLINIT' ) ) {
	$wgHooks['ParserFirstCallInit'][] = 'wfHarvardReferences';
} else {
	$wgExtensionFunctions[] = 'wfHarvardReferences';
}
 
// Extension credits that will show up on the page [[Special:Version]]    
$wgExtensionCredits['parserhook'][] = array(
	'path'         => __FILE__,
	'name'         => 'HarvardReferences',
	'version'      => '1.6',
	'author'       => 'X-romix',
	'url'          => 'https://www.mediawiki.org/wiki/Extension:HarvardReferences',
	'description'  => 'Allows to use the author-date ("Harvard system") referencing style'
);

$wgHarvardReferencesOn = false;
 
// Main class 
class HarvardReferences {
	var $refs = array();
	var $refs_count = array();
	var $cntParserBeforeStrip = 0;
 
	function HarvardReferences() { // Constructor
		$this->setHooks();
	}
 
	function setHooks() {
		global $wgParser, $wgHooks;
		
		// Hook to ParserBeforeStrip event - "Used to process the raw wiki code before any internal processing is applied"
		// See http://www.mediawiki.org/wiki/Manual:Hooks/ParserBeforeStrip
		// http://www.mediawiki.org/wiki/Manual:Hooks
		$wgHooks['ParserBeforeStrip'][] = array( &$this, 'hookParserBeforeStrip' );
		// function hookParserBeforeStrip() - is below

		// Hook to ParserBeforeTidy event - "Used to process the nearly-rendered html code for the page (but before any html tidying occurs)"
		// See http://www.mediawiki.org/wiki/Manual:Hooks/ParserBeforeTidy
		// http://www.mediawiki.org/wiki/Manual:Hooks
		$wgHooks['ParserBeforeTidy'][] = array( &$this, 'hookParserBeforeTidy' );
		// function hookParserBeforeTidy() - is below

		// Hook for new tag <HarvardReferences> 
		// see http://www.mediawiki.org/wiki/Manual:Tag_extensions for details
		$wgParser->setHook( 'HarvardReferences' , array( &$this, 'hookHarvardReferences' ) );
		// function hookHarvardReferences) - is below

	}
 
	// Hook for tag <HarvardReferences>  - setup see above
	function hookHarvardReferences( $str, $argv, $parser ) {
                global $wgHarvardReferencesOn;

		$wgHarvardReferencesOn = true;
		$str = $parser->recursiveTagParse( $str );
		// Comments, nowiki-blocks and wiki-links are already processed and is not visible here
		return $str;
	}
	
	// Hook for mediawiki event - setup see above
	// We need to prevent processing of <nowiki>[xxx]</nowiki> sequences, so we replace it to <nowiki>&#91;xxx&#93;</nowiki>
	function hookParserBeforeStrip( &$parser, &$text, &$strip_state ) {
		$this->cntParserBeforeStrip++;
		if ( $this->cntParserBeforeStrip > 1 ) return true; // as recommended in the documentation
		// Not do anything if there is not explicit switch-on tag
		$p = strpos( $text, "<HarvardReferences" );
		if ( $p === false ) return true;
		
		$p = strpos( $text, "<nowiki>" );
		if ( $p === false ) return true;
		
		$text = preg_replace_callback( "/
			(<nowiki>) 	#open tag
			(.*?)		#lazy search
			(<\/nowiki>)	#close tag.
			/x",
			array( __CLASS__, 'hookParserBeforeStripCallback' ),
			$text );

		$text = preg_replace_callback( "/
			(<\!\-\-) 	#open comment
			(.*?)		#lazy search
			(\-\-\>)	#close comment.
			/x",
			array( __CLASS__, 'hookParserBeforeStripCallback_1' ),
			$text );

		return true;
	}
 
 	// Callback function for preg_replace_callback - see it above
	// Replacing [ ] chars to &#91; &#93; HTML-equivalents in the nowiki block
	function hookParserBeforeStripCallback( $matches ) {
		$s = $matches[2];
		$s = str_replace ( "[", "&#91;", $s );
		$s = str_replace ( "]", "&#93;", $s );
		return "<nowiki>" . $s . "</nowiki>";
	
	}
	
	function hookParserBeforeStripCallback_1( $matches ) {
		$s = $matches[2];
		$s = str_replace ( "[", "&#91;", $s );
		$s = str_replace ( "]", "&#93;", $s );
		return "<!--" . $s . "-->";
	
	}
 
	// Hook for mediawiki event - setup see above
	function hookParserBeforeTidy( &$parser, &$text ) {
                global $wgHarvardReferencesOn;

		if($wgHarvardReferencesOn == false) return true;
		preg_match_all( "/
			(\[\*)    # [* characters
			([^\]]+)  # any text, e.g. Smith 2010
			(\])      # ] character
			/x", $text, $matches, PREG_SET_ORDER );
 
		foreach ( $matches as $match ) {
			$s = $match[2];
			$this->refs[] = $s; // fill global array refs[]  with names of labels ( e.g. "Smith 2010") 
		}
	
		// process links
		$text = preg_replace_callback( "/
			(\[)				# [ character
			([^\]\:\*\|]+)			# any text, e.g. Smith 2010 without ] * : | characters
			(\] | \:[^\]]+\] | \|[^\]]+\])	# ] character or  :page number or |page number etc. and ] character.
			/x",
			array( __CLASS__, 'refCallback' ),
			$text );
 
		// process anchors	
		$text = preg_replace_callback( "/
			(\[\*)      	# [* characters
			([^\]]+)	# any text, e.g. Smith 2010 without ] characters
			(\])        	# ] character 
			/x",
			array( __CLASS__, 'anchorsCallback' ),
			$text );
 
		return true;
	}
 
	// deletes some chars from link and replaces it for _

	// Callback function for preg_replace_callback - see it above
	// Processing references
	function refCallback( $matches ) {
		$s = $matches[2];

		if ( !in_array( $s, $this->refs ) ) {
			return $matches[0]; // not do any changes
		}
 
		$pages = $matches[3];
		$pages = str_replace( ']', '', $pages );
		$pages = str_replace( '|', '', $pages );
		$pages = str_replace( ':', '', $pages );
		$pages = trim( $pages );
		if ( $pages ) {
			$pages = ':' . $pages;
		}

		if ( !isset( $this->refs_count[$s] ) ) {
			$this->refs_count[$s] = 1;
		} else {
			$this->refs_count[$s]++;
		}
 
		$cnt = $this->refs_count[$s];
		// convert non-latin chars in link into dot-form
		$name = Sanitizer::escapeId( $s );
 
		$r = '<sup id="harv_ref-' . $name . '-' . $cnt . '" class="reference">' .
		"<a href='#harv_note-" . $name . "'>" .
		"[" . $s . "]" . "</a>" . $pages . "</sup>";
 
		return $r;
	}
 
	// Callback function for preg_replace_callback - see it above
	// Processing anchors
	function anchorsCallback( $matches ) {
		$s = $matches[2];
 		if ( !in_array( $s, $this->refs ) ) {
			return $matches[0]; // not do any changes
		}
 
		if ( !isset( $this->refs_count[$s] ) ) {
			$cnt = 0;
		} else {
			$cnt = $this->refs_count[$s];
		}
 
		// convert non-latin chars in link into dot-form
		$name = Sanitizer::escapeId( $s );
 
		if ( $cnt == 0 ) { // no links to this anchor
			$r = "<sup>[$s]</sup>";
		} else if ( $cnt == 1 ) { // 1 link to anchor
			$r = '<sup id="harv_note-' . $name . '" class="reference">' .
			'<a href="#harv_ref-' . $name . '-1">[' . $s . ']</a> ^</sup>';
		} else if ( $cnt >= 2 ) { // more than 1 link to anchor
			$r = '<sup id="harv_note-' . $name . '" class="reference">' .
			'<a href="#harv_ref-' . $name . '-1">[' . $s . ']</a> ^ </sup> ';
 
			for ( $i = 1; $i <= $cnt; $i++ ) {
				$r .= ' <sup id="harv_note-' . $name . '-' . $i . '" class="reference">' .
				'<a href="#harv_ref-' . $name . '-' . $i . '" class="reference">' . $i . '</a></sup> ';
			}
		}
		return $r;
	}
}
// Creates main object
function wfHarvardReferences() {
	new HarvardReferences;
	return true;
}
