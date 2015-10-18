{include file='header' pageTitle='wcf.acp.style.'|concat:$action}

<link href="{@$__wcf->getPath()}acp/style/acpStyleEditor.css" type="text/css" rel="stylesheet">

{js application='wcf' acp='true' file='WCF.ACP.Style'}
{js application='wcf' file='WCF.ColorPicker' bundle='WCF.Combined'}
<script data-relocate="true">
	require(['WoltLab/WCF/Acp/Ui/Style/Editor'], function(AcpUiStyleEditor) {
		AcpUiStyleEditor.setup({
			isTainted: {if $isTainted}true{else}false{/if},
			styleId: {if $action === 'edit'}{@$style->styleID}{else}0{/if},
			styleRuleMap: styleRuleMap
		});
	});
	
	$(function() {
		new WCF.ColorPicker('.jsColorPicker');
		
		WCF.Language.addObject({
			'wcf.style.colorPicker': '{lang}wcf.style.colorPicker{/lang}',
			'wcf.style.colorPicker.new': '{lang}wcf.style.colorPicker.new{/lang}',
			'wcf.style.colorPicker.current': '{lang}wcf.style.colorPicker.current{/lang}',
			'wcf.style.colorPicker.button.apply': '{lang}wcf.style.colorPicker.button.apply{/lang}',
			'wcf.acp.style.image.error.invalidExtension': '{lang}wcf.acp.style.image.error.invalidExtension{/lang}'
		});
		new WCF.ACP.Style.ImageUpload({if $action == 'add'}0{else}{@$style->styleID}{/if}, '{$tmpHash}');
		new WCF.ACP.Style.LogoUpload('{$tmpHash}', '{@$__wcf->getPath()}images/');
		
		{if $action == 'edit'}
			new WCF.ACP.Style.CopyStyle({@$style->styleID});
			
			WCF.Language.addObject({
				'wcf.acp.style.copyStyle.confirmMessage': '{@"wcf.acp.style.copyStyle.confirmMessage"|language|encodeJS}'
			});
		{/if}
		
		$('.jsUnitSelect').change(function(event) {
			var $target = $(event.currentTarget);
			$target.prev().attr('step', ($target.val() == 'em' ? '0.01' : '1'));
		}).trigger('change');
	});
</script>
<header class="boxHeadline">
	<h1>{lang}wcf.acp.style.{$action}{/lang}</h1>
	{if $action == 'edit'}<p>{$styleName}</p>{/if}
</header>

{include file='formError'}

{if $success|isset}
	<p class="success">{lang}wcf.global.success.{$action}{/lang}</p>
{/if}

<div class="contentNavigation">
	<nav>
		<ul>
			{if $action == 'edit'}
				<li><a href="{link controller='StyleExport' id=$style->styleID}{/link}" class="button"><span class="icon icon16 fa-download"></span> <span>{lang}wcf.acp.style.exportStyle{/lang}</span></a></li>
				<li><a class="jsCopyStyle button"><span class="icon icon16 fa-copy"></span> <span>{lang}wcf.acp.style.copyStyle{/lang}</span></a></li>
			{/if}
			
			<li><a href="{link controller='StyleList'}{/link}" class="button"><span class="icon icon16 fa-list"></span> <span>{lang}wcf.acp.menu.link.style.list{/lang}</span></a></li>
			
			{event name='contentNavigationButtons'}
		</ul>
	</nav>
</div>

<form method="post" action="{if $action == 'add'}{link controller='StyleAdd'}{/link}{else}{link controller='StyleEdit' id=$styleID}{/link}{/if}">
	<div class="tabMenuContainer" data-active="{$activeTabMenuItem}" data-store="activeTabMenuItem" id="styleTabMenuContainer">
		<nav class="tabMenu">
			<ul>
				<li><a href="{@$__wcf->getAnchor('general')}">{lang}wcf.acp.style.general{/lang}</a></li>
				<li><a href="{@$__wcf->getAnchor('globals')}">{lang}wcf.acp.style.globals{/lang}</a></li>
				<li><a href="{@$__wcf->getAnchor('colors')}">{lang}wcf.acp.style.colors{/lang}</a></li>
				<li><a href="{@$__wcf->getAnchor('advanced')}">{lang}wcf.acp.style.advanced{/lang}</a></li>
				
				{event name='tabMenuTabs'}
			</ul>
		</nav>
		
		{* general *}
		<div id="general" class="container containerPadding tabMenuContent">
			<p class="info">{lang}wcf.acp.style.protected{/lang}</p>
			
			<fieldset class="marginTop">
				<legend>{lang}wcf.acp.style.general.data{/lang}</legend>
				
				<dl{if $errorField == 'styleName'} class="formError"{/if}>
					<dt><label for="styleName">{lang}wcf.acp.style.styleName{/lang}</label></dt>
					<dd>
						<input type="text" name="styleName" id="styleName" value="{$styleName}" class="long" />
						{if $errorField == 'styleName'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.styleName.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'authorName'} class="formError"{/if}>
					<dt><label for="authorName">{lang}wcf.acp.style.authorName{/lang}</label></dt>
					<dd>
						<input type="text" name="authorName" id="authorName" value="{$authorName}" class="long"{if !$isTainted} readonly{/if} />
						{if $errorField == 'authorName'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.authorName.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'copyright'} class="formError"{/if}>
					<dt><label for="copyright">{lang}wcf.acp.style.copyright{/lang}</label></dt>
					<dd>
						<input type="text" name="copyright" id="copyright" value="{$copyright}" class="long"{if !$isTainted} readonly{/if} />
						{if $errorField == 'copyright'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.copyright.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'styleVersion'} class="formError"{/if}>
					<dt><label for="styleVersion">{lang}wcf.acp.style.styleVersion{/lang}</label></dt>
					<dd>
						<input type="text" name="styleVersion" id="styleVersion" value="{$styleVersion}" class="small"{if !$isTainted} readonly{/if} />
						{if $errorField == 'styleVersion'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.styleVersion.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'styleDate'} class="formError"{/if}>
					<dt><label for="styleDate">{lang}wcf.acp.style.styleDate{/lang}</label></dt>
					<dd>
						<input type="date" name="styleDate" id="styleDate" value="{$styleDate}" class="small"{if !$isTainted} readonly{/if} />
						{if $errorField == 'styleDate'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.styleDate.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'license'} class="formError"{/if}>
					<dt><label for="license">{lang}wcf.acp.style.license{/lang}</label></dt>
					<dd>
						<input type="text" name="license" id="license" value="{$license}" class="long"{if !$isTainted} readonly{/if} />
						{if $errorField == 'license'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.license.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'authorURL'} class="formError"{/if}>
					<dt><label for="authorURL">{lang}wcf.acp.style.authorURL{/lang}</label></dt>
					<dd>
						<input type="text" name="authorURL" id="authorURL" value="{$authorURL}" class="long"{if !$isTainted} readonly{/if} />
						{if $errorField == 'authorURL'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.authorURL.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'packageName'} class="formError"{/if}>
					<dt><label for="packageName">{lang}wcf.acp.style.packageName{/lang}</label></dt>
					<dd>
						<input type="text" name="packageName" id="packageName" value="{$packageName}" class="long"{if !$isTainted} readonly{/if} />
						{if $errorField == 'packageName'}
							<small class="innerError">{lang}wcf.acp.style.packageName.error.{$errorType}{/lang}</small>
						{/if}
					</dd>
				</dl>
				<dl{if $errorField == 'styleDescription'} class="formError"{/if}>
					<dt><label for="styleDescription">{lang}wcf.acp.style.styleDescription{/lang}</label></dt>
					<dd>
						<textarea name="styleDescription" id="styleDescription">{$i18nPlainValues['styleDescription']}</textarea>
						{if $errorField == 'styleDescription'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.styleDescription.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
						
						{include file='multipleLanguageInputJavascript' elementIdentifier='styleDescription' forceSelection=true}
					</dd>
				</dl>
				
				{event name='dataFields'}
			</fieldset>
			
			<fieldset>
				<legend>{lang}wcf.acp.style.general.files{/lang}</legend>
				
				<dl{if $errorField == 'image'} class="formError"{/if}>
					<dt><label for="image">{lang}wcf.acp.style.image{/lang}</label></dt>
					<dd class="framed">
						<img src="{if $action == 'add'}{@$__wcf->getPath()}images/stylePreview.png{else}{@$style->getPreviewImage()}{/if}" alt="" id="styleImage" />
						<div id="uploadImage"></div>
						{if $errorField == 'image'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.image.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
						<small>{lang}wcf.acp.style.image.description{/lang}</small>
					</dd>
				</dl>
				{if $availableTemplateGroups|count}
					<dl{if $errorField == 'templateGroupID'} class="formError"{/if}>
						<dt><label for="templateGroupID">{lang}wcf.acp.style.templateGroupID{/lang}</label></dt>
						<dd>
							<select name="templateGroupID" id="templateGroupID">
								<option value="0">{lang}wcf.acp.template.group.default{/lang}</option>
								{foreach from=$availableTemplateGroups item=templateGroup}
									<option value="{@$templateGroup->templateGroupID}"{if $templateGroup->templateGroupID == $templateGroupID} selected="selected"{/if}>{$templateGroup->templateGroupName}</option>
								{/foreach}
							</select>
							{if $errorField == 'templateGroupID'}
								<small class="innerError">
									{if $errorType == 'empty'}
										{lang}wcf.global.form.error.empty{/lang}
									{else}
										{lang}wcf.acp.style.templateGroupID.error.{$errorType}{/lang}
									{/if}
								</small>
							{/if}
						</dd>
					</dl>
				{/if}
				<dl{if $errorField == 'imagePath'} class="formError"{/if}>
					<dt><label for="imagePath">{lang}wcf.acp.style.imagePath{/lang}</label></dt>
					<dd>
						<input type="text" name="imagePath" id="imagePath" value="{$imagePath}" class="long" />
						{if $errorField == 'imagePath'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.imagePath.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
						<small>{lang}wcf.acp.style.imagePath.description{/lang}</small>
					</dd>
				</dl>
				
				{event name='fileFields'}
			</fieldset>
			
			{event name='generalFieldsets'}
		</div>
		
		{* globals *}
		<div id="globals" class="container containerPadding tabMenuContent">
			{* layout *}
			<fieldset>
				<legend>{lang}wcf.acp.style.globals.layout{/lang}</legend>
				
				<dl>
					<dt></dt>
					<dd><label>
						<input type="checkbox" id="useFluidLayout" name="useFluidLayout" value="1"{if $variables[useFluidLayout]} checked="checked"{/if} />
						<span>{lang}wcf.acp.style.globals.useFluidLayout{/lang}</span>
					</label></dd>
				</dl>
				
				<dl id="fluidLayoutMinWidth">
					<dt><label for="wcfLayoutMinWidth">{lang}wcf.acp.style.globals.fluidLayoutMinWidth{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfLayoutMinWidth" name="wcfLayoutMinWidth" value="{@$variables[wcfLayoutMinWidth]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfLayoutMinWidth_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfLayoutMinWidth_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				<dl id="fluidLayoutMaxWidth">
					<dt><label for="wcfLayoutMaxWidth">{lang}wcf.acp.style.globals.fluidLayoutMaxWidth{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfLayoutMaxWidth" name="wcfLayoutMaxWidth" value="{@$variables[wcfLayoutMaxWidth]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfLayoutMaxWidth_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfLayoutMaxWidth_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				
				<dl id="fixedLayoutVariables">
					<dt><label for="wcfLayoutFixedWidth">{lang}wcf.acp.style.globals.fixedLayoutWidth{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfLayoutFixedWidth" name="wcfLayoutFixedWidth" value="{@$variables[wcfLayoutFixedWidth]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfLayoutFixedWidth_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfLayoutFixedWidth_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				
				{event name='layoutFields'}
			</fieldset>
			
			{* logo *}
			<fieldset>
				<legend>{lang}wcf.acp.style.globals.pageLogo{/lang}</legend>
				
				<dl>
					<dt><label for="pageLogo">{lang}wcf.acp.style.globals.pageLogo{/lang}</label></dt>
					<dd class="framed">
						<img src="" alt="" id="styleLogo" style="max-width: 100%" />
						<div id="uploadLogo"></div>
						{if $errorField == 'image'}
							<small class="innerError">
								{if $errorType == 'empty'}
									{lang}wcf.global.form.error.empty{/lang}
								{else}
									{lang}wcf.acp.style.image.error.{$errorType}{/lang}
								{/if}
							</small>
						{/if}
					</dd>
					<dd>
						<input type="text" name="pageLogo" id="pageLogo" value="{$variables[pageLogo]}" class="long" />
						<small>{lang}wcf.acp.style.globals.pageLogo.description{/lang}</small>
					</dd>
				</dl>
				
				{event name='logoFields'}
			</fieldset>
			
			{* font *}
			<fieldset>
				<legend>{lang}wcf.acp.style.globals.font{/lang}</legend>
				
				<dl>
					<dt><label for="wcfFontSizeDefault">{lang}wcf.acp.style.globals.fontSizeDefault{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfFontSizeDefault" name="wcfFontSizeDefault" value="{@$variables[wcfFontSizeDefault]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfFontSizeDefault_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfFontSizeDefault_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				<dl>
					<dt><label for="wcfFontSizeSmall">{lang}wcf.acp.style.globals.fontSizeSmall{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfFontSizeSmall" name="wcfFontSizeSmall" value="{@$variables[wcfFontSizeSmall]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfFontSizeSmall_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfFontSizeSmall_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				<dl>
					<dt><label for="wcfFontSizeHeadline">{lang}wcf.acp.style.globals.fontSizeHeadline{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfFontSizeHeadline" name="wcfFontSizeHeadline" value="{@$variables[wcfFontSizeHeadline]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfFontSizeHeadline_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfFontSizeHeadline_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				<dl>
					<dt><label for="wcfFontSizeTitle">{lang}wcf.acp.style.globals.fontSizeTitle{/lang}</label></dt>
					<dd>
						<input type="number" id="wcfFontSizeTitle" name="wcfFontSizeTitle" value="{@$variables[wcfFontSizeTitle]}" class="tiny" />
						<label class="selectDropdown">
							<select name="wcfFontSizeTitle_unit" class="jsUnitSelect">
								{foreach from=$availableUnits item=unit}
									<option value="{@$unit}"{if $variables[wcfFontSizeTitle_unit] == $unit} selected="selected"{/if}>{@$unit}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				
				<dl class="marginTop">
					<dt></dt>
					<dd><label>
						<input type="checkbox" id="useGoogleFont" name="useGoogleFont" value="1"{if $variables[useGoogleFont]} checked="checked"{/if} />
						<span>{lang}wcf.acp.style.globals.useGoogleFont{/lang}</span>
					</label></dd>
				</dl>
				<dl>
					<dt><label for="wcfFontFamilyGoogle">{lang}wcf.acp.style.globals.fontFamilyGoogle{/lang}</label></dt>
					<dd>
						<input type="text" id="wcfFontFamilyGoogle" name="wcfFontFamilyGoogle" value="{$variables[wcfFontFamilyGoogle]}" class="medium">
					</dd>
				</dl>
				<dl>
					<dt><label for="wcfFontFamilyFallback">{lang}wcf.acp.style.globals.fontFamilyFallback{/lang}</label></dt>
					<dd>
						<label class="selectDropdown">
							<select name="wcfFontFamilyFallback" id="wcfFontFamilyFallback">
								{foreach from=$availableFontFamilies key=fontFamily item=primaryFont}
									<option value='{@$fontFamily}'{if $variables[wcfFontFamilyFallback] == $fontFamily} selected="selected"{/if}>{@$primaryFont}</option>
								{/foreach}
							</select>
						</label>
					</dd>
				</dl>
				
				{event name='fontFields'}
			</fieldset>
			
			{event name='globalFieldsets'}
		</div>
		
		{* colors *}
		<div id="colors" class="container containerPadding tabMenuContainer tabMenuContent">
			<div id="spWrapper">
				<div id="spWindow">
					<div id="spHeader" data-region="wcfHeader">
						<div class="spBoundary">
							<div id="spLogo"><img src="{@$__wcf->getPath()}acp/images/wcfLogo.png"></div>
							<div id="spSearch"><input type="search" id="spSearchBox" placeholder="{lang}wcf.global.search.enterSearchTerm{/lang}" autocomplete="off" data-region="wcfHeaderSearchBox"></div>
							<div id="spMenu">
								<ol class="inlineList">
									<li><a>Lorem</a></li>
									<li><a>Ipsum Dolor</a></li>
									<li class="active">
										<a>Sit Amet</a>
										<ol id="spSubMenu" data-region="wcfHeaderMenu">
											<li><a>Lorem</a></li>
											<li><a>Ipsum</a></li>
											<li class="active"><a>Dolor Sit</a></li>
										</ol>
									</li>
								</ol>
							</div>
							<div id="spUser"></div>
						</div>
					</div>
					
					<div id="spNavigation" data-region="wcfNavigation">
						<div class="spBoundary">
							<ol class="inlineList">
								<li><a>Lorem</a></li>
								<li><a>Ipsum</a></li>
							</ol>
						</div>
					</div>
					
					<div id="spContent">
						<div class="spBoundary">
							<div id="spContentWrapper">
								<div class="spHeadline" data-region="wcfContentHeadline">Lorem Ipsum</div>
								
								<p data-region="wcfContent">
									Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. <a>At vero eos</a> et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.<br>
									<br>
									Stet clita kasd gubergren, no sea <a>takimata</a> sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor <a>invidunt</a> ut labore et dolore magna aliquyam erat, sed diam voluptua.
								</p>
								
								<div class="spHeadline">Tabular Box</div>
								
								<table id="spTable">
									<thead>
										<tr>
											<th><a>Lorem</a></th>
											<th><a>Ipsum</a></th>
											<th><a>Dolor Sit Amet</a></th>
										</tr>
									</thead>
									
									<tbody>
										<tr>
											<td>Lorem ipsum dolor</td><td>sit amet, consetetur sadipscing elitr</td><td>sed diam nonumy</td>
										</tr>
										<tr>
											<td>eirmod tempor</td><td>invidunt ut labore et dolore</td><td>magna aliquyam erat</td>
										</tr>
										<tr>
											<td>sed diam voluptua</td><td>At vero eos</td><td>et accusam et justo</td>
										</tr>
									</tbody>
								</table>
								
								<div class="spHeadline">Input</div>
								
								<dl>
									<dt><label for="spInput">Lorem Ipsum</label></dt>
									<dd><input type="text" id="spInput" class="long" value="Consetetur sadipscing elitr"></dd>
								</dl>
								<dl>
									<dt><label for="spInputDisabled">Dolor Sit Amet</label></dt>
									<dd><input type="text" id="spInputDisabled" class="long" value="Disabled" disabled></dd>
								</dl>
								
								<div class="spHeadline">Button</div>
								
								<ol id="spButton" class="inlineList" data-region="wcfButton">
									<li><a class="button">Button</a></li>
									<li><a class="button active">Button (Active)</a></li>
									<li><a class="button disabled" data-region="wcfButtonDisabled">Button (Disabled)</a></li>
								</ol>
								
								<ol id="spButtonPrimary" class="inlineList marginTop" data-region="wcfButtonPrimary">
									<li><a class="button buttonPrimary">Primary Button</a></li>
									<li><a class="button buttonPrimary active">Primary Button (Active)</a></li>
									<li><a class="button disabled">Primary Button (Disabled)</a></li>
								</ol>
								
								<div class="spHeadline">Dropdown</div>
								
								<div style="position: relative">
									<ul class="dropdownMenu" id="spDropdown">
										<li><a>Lorem Ipsum</a></li>
										<li class="active"><a>Dolor Sit Amet</a></li>
										<li><a>Consetetur Sadipscing</a></li>
										<li class="dropdownDivider"></li>
										<li><a>Sed diam nonumy</a></li>
									</ul>
								</div>
							</div>
							
							<div id="spContentSidebar">
								<div class="spContentSidebarBox">
									<div class="spContentSidebarHeadline">Sidebar</div>
									
									<p>
										Lorem ipsum dolor sit amet, consetetur sadipscing elitr, <a>sed diam nonumy eirmod tempor</a> invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam <a>et justo</a> duo dolores et ea rebum.
									</p>
								</div>
								
								<div class="spContentSidebarBox">
									<div class="spContentSidebarHeadline"><a>Dolor Sit Amet</a></div>
									
									<p>
										<a>Stet clita kasd gubergren</a>, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut <a>labore et dolore magna</a> aliquyam erat, sed diam voluptua.
									</p>
								</div>
							</div>
						</div>
					</div>
					
					<div id="spFooterBox">
						<div class="spBoundary">
							<div class="spFooterBoxItem">
								<div class="spFooterBoxHeadline">Lorem Ipsum</div>
								
								<p>
									Lorem ipsum dolor sit amet, consetetur <a>sadipscing elitr</a>, sed diam nonumy eirmod tempor <a>invidunt ut labore</a> et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
								</p>
							</div>
							
							<div class="spFooterBoxItem">
								<div class="spFooterBoxHeadline"><a>Dolor Sit Amet</a></div>
								
								<p>
									Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, <a>sed diam voluptua</a>.
								</p>
							</div>
						</div>
					</div>
					
					<div id="spFooter">
						<div class="spBoundary">
							Copyright &copy; 1970-2038 <a>Example Company</a>
						</div>
					</div>
				</div>
				<div id="spSidebar">
					<div class="spSidebarBox">
						<label class="selectDropdown">
							<select id="spCategories">
								<option value="none" selected>{lang}wcf.global.noSelection{/lang}</option>
								{foreach from=$colorCategories key=spName item=spCategory}
									<optgroup label="{$spName}">
										{if $spCategory|is_array}
											{foreach from=$spCategory item=spChildCategory}
												<option value="{$spChildCategory}">{$spChildCategory}</option>
											{/foreach}
										{else}
											<option value="{$spCategory}">{$spCategory}</option>
										{/if}
									</optgroup>
								{/foreach}
							</select>
						</label>
					</div>
					
					<div class="spSidebarBox" data-category="none" style="display: none;">
						foo
					</div>
					
					{foreach from=$colors key=spCategory item=spColors}
						<div class="spSidebarBox" data-category="{$spCategory}" style="display: none;">
							<ul>
								{foreach from=$spColors item=spType}
									{capture assign=spColor}{$spCategory}{$spType|ucfirst}{/capture}
									<li class="box24 spColor">
										<div class="spColorBox">
											<span class="styleVariableColor jsColorPicker" style="background-color: {$variables[$spColor]};" data-color="{$variables[$spColor]}" data-store="{$spColor}_value"></span>
											<input type="hidden" id="{$spColor}_value" name="{$spColor}" value="{$variables[$spColor]}" />
										</div>
										<div>
											<span class="spVariable">${$spColor}</span>
											<span class="spDescription">{$spType}</span>
										</div>
									</li>
								{/foreach}
							</ul>
						</div>
					{/foreach}
				</div>
			</div>
		</div>
		
		<script>
			var styleRuleMap = {
				'wcfHeaderBackground': '#spHeader { background-color: VALUE; }',
				'wcfHeaderLink': '#spHeader a { color: VALUE; }',
				'wcfHeaderLinkActive': '#spHeader a:hover { color: VALUE; }',
				'wcfHeaderSearchBoxBackground': '#spSearchBox { background-color: VALUE; }',
				'wcfHeaderSearchBoxText': '#spSearchBox { color: VALUE; }',
				'wcfHeaderSearchBoxBackgroundActive': '#spSearchBox:focus, #spSearchBox:hover { background-color: VALUE; }',
				'wcfHeaderSearchBoxTextActive': '#spSearchBox:focus, #spSearchBox:hover { color: VALUE; }',
				'wcfHeaderMenuBackground': '#spSubMenu { background-color: VALUE; }',
				'wcfHeaderMenuBorder': '#spSubMenu { border-color: VALUE; }',
				'wcfHeaderMenuLink': '#spSubMenu li > a { color: VALUE; }',
				'wcfHeaderMenuBackgroundActive': '#spSubMenu li.active > a, #spSubMenu li > a:hover { background-color: VALUE; }',
				'wcfHeaderMenuLinkActive': '#spSubMenu li.active > a, #spSubMenu li > a:hover { color: VALUE; }',
				'wcfNavigationBackground': '#spNavigation { background-color: VALUE; }',
				'wcfNavigationText': '#spNavigation { color: VALUE; }',
				'wcfNavigationLink': '#spNavigation a { color: VALUE; }',
				'wcfNavigationLinkActive': '#spNavigation a:hover { color: VALUE; }',
				'wcfContentBackground': '#spContent { background-color: VALUE; }',
				'wcfContentText': '#spContent { color: VALUE; }',
				'wcfContentLink': '#spContent a { color: VALUE; }',
				'wcfContentLinkActive': '#spContent a:hover { color: VALUE; }',
				'wcfContentHeadlineBorder': '.spHeadline { border-color: VALUE; }',
				'wcfContentHeadlineText': '.spHeadline { color: VALUE; }',
				'wcfContentHeadlineLink': '.spHeadline a { color: VALUE; }',
				'wcfContentHeadlineLinkActive': '.spHeadline a:hover { color: VALUE; }',
				'wcfTabularBoxBorderInner': '#spTable td { border-color: VALUE; }',
				'wcfTabularBoxHeadline': '#spTable { border-color: VALUE; } __COMBO_RULE__ #spTable th, #spTable th a { color: VALUE; }',
				'wcfTabularBoxBackgroundActive': '#spTable tr:hover > td { background-color: VALUE; }',
				'wcfTabularBoxHeadlineActive': '#spTable th a:hover { color: VALUE; }',
				'wcfInputBackground': '#spInput { background-color: VALUE; }',
				'wcfInputBorder': '#spInput { border-color: VALUE; }',
				'wcfInputText': '#spInput { color: VALUE; }',
				'wcfInputBackgroundActive': '#spInput:focus, #spInput:hover { background-color: VALUE; }',
				'wcfInputBorderActive': '#spInput:focus, #spInput:hover { border-color: VALUE; }',
				'wcfInputTextActive': '#spInput:focus, #spInput:hover { color: VALUE; }',
				'wcfInputDisabledBackground': '#spInputDisabled { background-color: VALUE; }',
				'wcfInputDisabledBorder': '#spInputDisabled { border-color: VALUE; }',
				'wcfInputDisabledText': '#spInputDisabled { color: VALUE; }',
				'wcfButtonBackground': '#spButton .button { background-color: VALUE; }',
				'wcfButtonBorder': '#spButton .button { border-color: VALUE; }',
				'wcfButtonText': '#spButton .button { color: VALUE; }',
				'wcfButtonBackgroundActive': '#spButton .button.active, #spButton .button:hover { background-color: VALUE; }',
				'wcfButtonBorderActive': '#spButton .button.active, #spButton .button:hover { border-color: VALUE; }',
				'wcfButtonTextActive': '#spButton .button.active, #spButton .button:hover { color: VALUE; }',
				'wcfButtonPrimaryBackground': '#spButtonPrimary .button { background-color: VALUE; }',
				'wcfButtonPrimaryBorder': '#spButtonPrimary .button { border-color: VALUE; }',
				'wcfButtonPrimaryText': '#spButtonPrimary .button { color: VALUE; }',
				'wcfButtonPrimaryBackgroundActive': '#spButtonPrimary .button.active, #spButtonPrimary .button:hover { background-color: VALUE; }',
				'wcfButtonPrimaryBorderActive': '#spButtonPrimary .button.active, #spButtonPrimary .button:hover { border-color: VALUE; }',
				'wcfButtonPrimaryTextActive': '#spButtonPrimary .button.active, #spButtonPrimary .button:hover { color: VALUE; }',
				'wcfButtonDisabledBackground': '#spButton .button.disabled, #spButtonPrimary .button.disabled { background-color: VALUE; }',
				'wcfButtonDisabledBorder': '#spButton .button.disabled, #spButtonPrimary .button.disabled { border-color: VALUE; }',
				'wcfButtonDisabledText': '#spButton .button.disabled, #spButtonPrimary .button.disabled { color: VALUE; }',
				'wcfDropdownBackground': '#spDropdown { background-color: VALUE; }',
				'wcfDropdownBorder': '#spDropdown { border-color: VALUE; }',
				'wcfDropdownBorderInner': '#spDropdown .dropdownDivider { border-color: VALUE; }',
				'wcfDropdownText': '#spDropdown { color: VALUE; }',
				'wcfDropdownLink': '#spDropdown a { color: VALUE; }',
				'wcfDropdownBackgroundActive': '#spDropdown li.active > a, #spDropdown a:hover { background-color: VALUE; }',
				'wcfDropdownLinkActive': '#spDropdown li.active > a, #spDropdown a:hover { color: VALUE; }',
				'wcfFooterBoxBackground': '#spFooterBox { background-color: VALUE; }',
				'wcfFooterBoxText': '#spFooterBox { color: VALUE; }',
				'wcfFooterBoxLink': '#spFooterBox a { color: VALUE; }',
				'wcfFooterBoxLinkActive': '#spFooterBox a:hover { color: VALUE; }',
				'wcfFooterBoxHeadlineText': '#spFooterBox .spFooterBoxHeadline { color: VALUE; }',
				'wcfFooterBoxHeadlineLink': '#spFooterBox .spFooterBoxHeadline a { color: VALUE; }',
				'wcfFooterBoxHeadlineLinkActive': '#spFooterBox .spFooterBoxHeadline a:hover { color: VALUE; }',
				'wcfFooterBackground': '#spFooter { background-color: VALUE; }',
				'wcfFooterText': '#spFooter { color: VALUE; }',
				'wcfFooterLink': '#spFooter a { color: VALUE; }',
				'wcfFooterLinkActive': '#spFooter a:active { color: VALUE; }',
				'wcfSidebarBackground': '#spContentSidebar .spContentSidebarBox { background-color: VALUE; }',
				'wcfSidebarText': '#spContentSidebar .spContentSidebarBox { color: VALUE; }',
				'wcfSidebarLink': '#spContentSidebar .spContentSidebarBox a { color: VALUE; }',
				'wcfSidebarLinkActive': '#spContentSidebar .spContentSidebarBox a:hover { color: VALUE; }',
				'wcfSidebarHeadlineText': '#spContentSidebar .spContentSidebarBox .spContentSidebarHeadline { color: VALUE; }',
				'wcfSidebarHeadlineLink': '#spContentSidebar .spContentSidebarBox .spContentSidebarHeadline a { color: VALUE; }',
				'wcfSidebarHeadlineLinkActive': '#spContentSidebar .spContentSidebarBox .spContentSidebarHeadline a:hover { color: VALUE; }',
			};
		</script>
		
		{* advanced *}
		<div id="advanced" class="container containerPadding tabMenuContainer tabMenuContent">
			{if !$isTainted}
				<nav class="menu">
					<ul>
						<li data-name="advanced-custom"><a href="{@$__wcf->getAnchor('advanced-custom')}">{lang}wcf.acp.style.advanced.custom{/lang}</a></li>
						<li data-name="advanced-original"><a href="{@$__wcf->getAnchor('advanced-original')}">{lang}wcf.acp.style.advanced.original{/lang}</a></li>
					</ul>
				</nav>
				
				<p class="info">{lang}wcf.acp.style.protected{/lang}</p>
				
				{* custom declarations *}
				<div id="advanced-custom" class="tabMenuContent">
					<fieldset class="marginTop">
						<legend>{lang}wcf.acp.style.advanced.individualLess{/lang}</legend>
						
						<dl class="wide">
							<dd>
								<textarea id="individualLessCustom" rows="20" cols="40" name="individualLessCustom">{$variables[individualLessCustom]}</textarea>
								<small>{lang}wcf.acp.style.advanced.individualLess.description{/lang}</small>
							</dd>
						</dl>
					</fieldset>
					
					<fieldset{if $errorField == 'overrideLessCustom'} class="formError"{/if}>
						<legend>{lang}wcf.acp.style.advanced.overrideLess{/lang}</legend>
						
						<dl class="wide">
							<dd>
								<textarea id="overrideLessCustom" rows="20" cols="40" name="overrideLessCustom">{$variables[overrideLessCustom]}</textarea>
								{if $errorField == 'overrideLessCustom'}
									<small class="innerError">
										{lang}wcf.acp.style.advanced.overrideLess.error{/lang}
										{implode from=$errorType item=error}{lang}wcf.acp.style.advanced.overrideLess.error.{$error.error}{/lang}{/implode}
									</small>
								{/if}
								<small>{lang}wcf.acp.style.advanced.overrideLess.description{/lang}</small>
							</dd>
						</dl>
					</fieldset>
					{include file='codemirror' codemirrorMode='text/x-less' codemirrorSelector='#individualLessCustom, #overrideLessCustom'}
					
					{event name='syntaxFieldsetsCustom'}
				</div>
				
				{* original declarations / tainted style *}
				<div id="advanced-original">
			{/if}
			
			<fieldset class="marginTop">
				<legend>{lang}wcf.acp.style.advanced.individualLess{/lang}{if !$isTainted} ({lang}wcf.acp.style.protected.less{/lang}){/if}</legend>
				
				<dl class="wide">
					<dd>
						<textarea id="individualLess" rows="20" cols="40" name="individualLess">{$variables[individualLess]}</textarea>
						<small>{lang}wcf.acp.style.advanced.individualLess.description{/lang}</small>
					</dd>
				</dl>
			</fieldset>
			
			<fieldset{if $errorField == 'overrideLess'} class="formError"{/if}>
				<legend>{lang}wcf.acp.style.advanced.overrideLess{/lang}{if !$isTainted} ({lang}wcf.acp.style.protected.less{/lang}){/if}</legend>
				
				<dl class="wide">
					<dd>
						<textarea id="overrideLess" rows="20" cols="40" name="overrideLess">{$variables[overrideLess]}</textarea>
						{if $errorField == 'overrideLess'}
							<small class="innerError">
								{lang}wcf.acp.style.advanced.overrideLess.error{/lang}
								{implode from=$errorType item=error}{lang}wcf.acp.style.advanced.overrideLess.error.{$error.error}{/lang}{/implode}
							</small>
						{/if}
						<small>{lang}wcf.acp.style.advanced.overrideLess.description{/lang}</small>
					</dd>
				</dl>
			</fieldset>
			{include file='codemirror' codemirrorMode='text/x-less' codemirrorSelector='#individualLess, #overrideLess' editable=$isTainted}
			
			{event name='syntaxFieldsetsOriginal'}
			
			{if !$isTainted}
				</div>
			{/if}
		</div>
		
		{event name='tabMenuContents'}
	</div>
	
	<div class="formSubmit">
		<input type="submit" value="{lang}wcf.global.button.submit{/lang}" accesskey="s" />
		<input type="hidden" name="tmpHash" value="{$tmpHash}" />
		{@SECURITY_TOKEN_INPUT_TAG}
	</div>
</form>

<div id="styleDisableProtection" class="jsStaticDialogContent" data-title="{lang}wcf.acp.style.protected.title{/lang}">
	<p>{lang}wcf.acp.style.protected.description{/lang}</p>
	
	<dl class="marginTop">
		<dt></dt>
		<dd><label for="styleDisableProtectionConfirm"><input type="checkbox" id="styleDisableProtectionConfirm"> {lang}wcf.acp.style.protected.confirm{/lang}</label></dd>
	</dl>
	
	<div class="formSubmit">
		<button id="styleDisableProtectionSubmit" disabled>{lang}wcf.global.button.submit{/lang}</button>
	</div>
</div>

{include file='footer'}
