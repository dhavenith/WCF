<?php
declare(strict_types=1);
namespace wcf\system\form\builder\field;
use wcf\system\form\builder\field\validation\FormFieldValidationError;

/**
 * Implementation of a form field for boolean values.
 * 
 * @author	Matthias Schmidt
 * @copyright	2001-2018 WoltLab GmbH
 * @license	GNU Lesser General Public License <http://opensource.org/licenses/lgpl-license.php>
 * @package	WoltLabSuite\Core\System\Form\Builder\Field
 * @since	3.2
 */
class BooleanFormField extends AbstractFormField {
	/**
	 * @inheritDoc
	 */
	protected $templateName = '__booleanFormField';
	
	/**
	 * @inheritDoc
	 */
	public function getSaveValue() {
		return $this->__value ? 1 : 0;
	}
	
	/**
	 * @inheritDoc
	 */
	public function readValue(): IFormField {
		if ($this->getDocument()->hasRequestData($this->getPrefixedId())) {
			$this->__value = $this->getDocument()->getRequestData($this->getPrefixedId()) === '1';
		}
		
		return $this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function requiresLabel(): bool {
		return true;
	}
	
	/**
	 * @inheritDoc
	 */
	public function validate() {
		if ($this->isRequired() && !$this->getValue()) {
			$this->addValidationError(new FormFieldValidationError('empty'));
		}
		
		parent::validate();
	}
	
	/**
	 * @inheritDoc
	 * @return	static		this field
	 */
	public function value($value): IFormField {
		if (is_string($value) && in_array($value, ['0', '1', 'true', 'false'])) {
			$value = ($value === '1' || $value === 'true');
		}
		if (is_int($value) && ($value === 0 || $value === 1)) {
			$value = ($value === 1);
		}
		else if (!is_bool($value)) {
			throw new \InvalidArgumentException("Given value is no bool, " . gettype($value) . " given.");
		}
		
		return parent::value($value);
	}
}