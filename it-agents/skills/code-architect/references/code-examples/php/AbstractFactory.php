<?php
// Abstract Factory — create families of related objects without specifying concrete classes.
declare(strict_types=1);

interface Button
{
    public function render(): string;
}

interface Checkbox
{
    public function toggle(): string;
}

interface WidgetFactory
{
    public function makeButton(): Button;
    public function makeCheckbox(): Checkbox;
}

final class LightButton implements Button
{
    public function render(): string { return '[ Light Button ]'; }
}

final class LightCheckbox implements Checkbox
{
    public function toggle(): string { return '( ) light checkbox'; }
}

final class DarkButton implements Button
{
    public function render(): string { return '[ Dark Button ]'; }
}

final class DarkCheckbox implements Checkbox
{
    public function toggle(): string { return '(x) dark checkbox'; }
}

final class LightThemeFactory implements WidgetFactory
{
    public function makeButton(): Button { return new LightButton(); }
    public function makeCheckbox(): Checkbox { return new LightCheckbox(); }
}

final class DarkThemeFactory implements WidgetFactory
{
    public function makeButton(): Button { return new DarkButton(); }
    public function makeCheckbox(): Checkbox { return new DarkCheckbox(); }
}

function buildScreen(WidgetFactory $factory): void
{
    echo $factory->makeButton()->render() . ' ' . $factory->makeCheckbox()->toggle() . PHP_EOL;
}

// Demo
buildScreen(new LightThemeFactory());
buildScreen(new DarkThemeFactory());
