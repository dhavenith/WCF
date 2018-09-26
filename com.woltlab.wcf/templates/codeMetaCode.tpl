<div class="codeBox collapsibleBbcode jsCollapsibleBbcode {if $lines > 10} collapsed{/if}">
	<div>
		<div class="codeBoxHeader">
			<div class="codeBoxHeadline">{lang}wcf.bbcode.code.{$language}.title{/lang}{if $filename}: {$filename}{/if}</div>
		</div>
		
		{assign var='lineNumber' value=$startLineNumber}
		<pre><code class="language-{$language}" data-start-number="{$startLineNumber}">{foreach from=$content item=line}{*
			*}{assign var='codeLineID' value='codeLine_'|concat:$lineNumber:'_':$codeID}{*
			*}<div class="codeBoxLine" id="{$codeLineID}"><a href="{@$__wcf->getAnchor($codeLineID)}" class="lineAnchor" data-number="{@$lineNumber}"></a><span>{$line}</span></div>{*
			*}{assign var='lineNumber' value=$lineNumber+1}{*
		*}{/foreach}</code></pre>
	</div>
	<script data-relocate="true">
		require(['WoltLabSuite/Core/Prism', 'prism/components/prism-{$language}'], function (prism) {
			elBySelAll('.codeBox code.language-{$language}', document, function (el) {
				var highlighted = prism.highlightSeparateLines(el.textContent, '{$language}');
				var offset = elData(el, 'start-number') - 1;
				
				elBySelAll('[data-number]', highlighted, function (line) {
					var number = ~~elData(line, 'number') + offset;
					var replace = elBySel('[data-number="' + number + '"] + span', el);
					replace.parentNode.replaceChild(line, replace);
				})
			})
		});
	</script>
	
	{if $lines > 10}
		<span class="toggleButton" data-title-collapse="{lang}wcf.bbcode.button.collapse{/lang}" data-title-expand="{lang}wcf.bbcode.button.showAll{/lang}">{lang}wcf.bbcode.button.showAll{/lang}</span>
		
		{if !$__overlongBBCodeBoxSeen|isset}
			{assign var='__overlongBBCodeBoxSeen' value=true}
			<script data-relocate="true">
				require(['WoltLabSuite/Core/Bbcode/Collapsible'], function(BbcodeCollapsible) {
					BbcodeCollapsible.observe();
				});
			</script>
		{/if}
	{/if}
</div>
