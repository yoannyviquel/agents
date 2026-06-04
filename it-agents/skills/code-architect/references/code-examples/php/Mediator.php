<?php
// Mediator — centralize communication between components.
declare(strict_types=1);

interface Mediator
{
    public function notify(Component $sender, string $event): void;
}

abstract class Component
{
    public function __construct(protected ?Mediator $mediator = null) {}

    public function setMediator(Mediator $mediator): void
    {
        $this->mediator = $mediator;
    }
}

final class TextField extends Component
{
    public string $value = '';

    public function type(string $value): void
    {
        $this->value = $value;
        $this->mediator?->notify($this, 'changed');
    }
}

final class SubmitButton extends Component
{
    public bool $enabled = false;

    public function setEnabled(bool $enabled): void
    {
        $this->enabled = $enabled;
        echo 'Button ' . ($enabled ? 'enabled' : 'disabled') . PHP_EOL;
    }
}

// Concrete mediator wires components together without them knowing each other.
final class FormMediator implements Mediator
{
    public function __construct(private TextField $field, private SubmitButton $button)
    {
        $field->setMediator($this);
        $button->setMediator($this);
    }

    public function notify(Component $sender, string $event): void
    {
        if ($sender === $this->field && $event === 'changed') {
            $this->button->setEnabled($this->field->value !== '');
        }
    }
}

// Demo
$field = new TextField();
$button = new SubmitButton();
new FormMediator($field, $button);

$field->type('hello');
$field->type('');
