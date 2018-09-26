<?php
namespace wcf\system\html\output\node;
use wcf\system\bbcode\highlighter\BashHighlighter;
use wcf\system\bbcode\highlighter\CHighlighter;
use wcf\system\bbcode\highlighter\DiffHighlighter;
use wcf\system\bbcode\highlighter\HtmlHighlighter;
use wcf\system\bbcode\highlighter\JavaHighlighter;
use wcf\system\bbcode\highlighter\JsHighlighter;
use wcf\system\bbcode\highlighter\PerlHighlighter;
use wcf\system\bbcode\highlighter\PhpHighlighter;
use wcf\system\bbcode\highlighter\PlainHighlighter;
use wcf\system\bbcode\highlighter\PythonHighlighter;
use wcf\system\bbcode\highlighter\SqlHighlighter;
use wcf\system\bbcode\highlighter\TexHighlighter;
use wcf\system\bbcode\highlighter\XmlHighlighter;
use wcf\system\html\node\AbstractHtmlNodeProcessor;
use wcf\system\Regex;
use wcf\system\WCF;
use wcf\util\StringUtil;

/**
 * Processes code listings.
 * 
 * @author      Alexander Ebert
 * @copyright   2001-2018 WoltLab GmbH
 * @license     GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package     WoltLabSuite\Core\System\Html\Output\Node
 * @since       3.0
 */
class HtmlOutputNodePre extends AbstractHtmlOutputNode {
	/**
	 * @inheritDoc
	 */
	protected $tagName = 'pre';
	
	/**
	 * already used ids for line numbers to prevent duplicate ids in the output
	 * @var	string[]
	 */
	private static $codeIDs = [];
	
	/**
	 * @inheritDoc
	 */
	public function process(array $elements, AbstractHtmlNodeProcessor $htmlNodeProcessor) {
		/** @var \DOMElement $element */
		foreach ($elements as $element) {
			if ($element->getAttribute('class') === 'woltlabHtml') {
				$nodeIdentifier = StringUtil::getRandomID();
				$htmlNodeProcessor->addNodeData($this, $nodeIdentifier, ['rawHTML' => $element->textContent]);
				
				$htmlNodeProcessor->renameTag($element, 'wcfNode-' . $nodeIdentifier);
				continue;
			}
			
			switch ($this->outputType) {
				case 'text/html':
					$nodeIdentifier = StringUtil::getRandomID();
					$htmlNodeProcessor->addNodeData($this, $nodeIdentifier, [
						'content' => $element->textContent,
						'file' => $element->getAttribute('data-file'),
						'highlighter' => $element->getAttribute('data-highlighter'),
						'line' => $element->hasAttribute('data-line') ? $element->getAttribute('data-line') : 1,
						'skipInnerContent' => true
					]);
					
					$htmlNodeProcessor->renameTag($element, 'wcfNode-' . $nodeIdentifier);
					break;
				
				case 'text/simplified-html':
				case 'text/plain':
					$htmlNodeProcessor->replaceElementWithText(
						$element,
						WCF::getLanguage()->getDynamicVariable('wcf.bbcode.code.simplified', ['lines' => substr_count($element->nodeValue, "\n") + 1]),
						true
					);
					break;
			}
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function replaceTag(array $data) {
		// HTML bbcode
		if (isset($data['rawHTML'])) {
			return $data['rawHTML'];
		}
		
		$content = preg_replace('/^\s*\n/', '', $data['content']);
		$content = preg_replace('/\n\s*$/', '', $content);
		
		$file = $data['file'];
		$highlighter = $data['highlighter'];
		$line = ($data['line'] < 1) ? 1 : $data['line'];
		
		switch ($highlighter) {
			case 'js':
				$highlighter = 'javascript';
		}

		$splitContent = explode("\n", $content);
		$last = array_pop($splitContent);
		$splitContent = array_map(function ($item) {
			return $item."\n";
		}, $splitContent);
		$splitContent[] = $last;
		
		// show template
		/** @noinspection PhpUndefinedMethodInspection */
		WCF::getTPL()->assign([
			'codeID' => $this->getCodeID($content),
			'startLineNumber' => $line,
			'content' => $splitContent,
			'language' => $highlighter,
			'filename' => $file,
			'lines' => count($splitContent)
		]);
		
		return WCF::getTPL()->fetch('codeMetaCode');
	}
	
	/**
	 * Returns a unique ID for this code block.
	 *
	 * @param	string		$code
	 * @return	string
	 */
	protected function getCodeID($code) {
		$i = -1;
		// find an unused codeID
		do {
			$codeID = mb_substr(StringUtil::getHash($code), 0, 6).(++$i ? '_'.$i : '');
		}
		while (isset(self::$codeIDs[$codeID]));
		
		// mark codeID as used
		self::$codeIDs[$codeID] = true;
		
		return $codeID;
	}
}
