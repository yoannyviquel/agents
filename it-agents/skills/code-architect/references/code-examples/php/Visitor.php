<?php
// Visitor — separate algorithms from objects via accept/visit (double dispatch).
declare(strict_types=1);

interface Visitor
{
    public function visitText(TextElement $element): string;
    public function visitImage(ImageElement $element): string;
}

interface Element
{
    public function accept(Visitor $visitor): string;
}

final class TextElement implements Element
{
    public function __construct(public string $content) {}

    public function accept(Visitor $visitor): string
    {
        return $visitor->visitText($this);
    }
}

final class ImageElement implements Element
{
    public function __construct(public string $src) {}

    public function accept(Visitor $visitor): string
    {
        return $visitor->visitImage($this);
    }
}

// A new operation = a new visitor, no element changes needed.
final class HtmlExportVisitor implements Visitor
{
    public function visitText(TextElement $element): string
    {
        return "<p>{$element->content}</p>";
    }

    public function visitImage(ImageElement $element): string
    {
        return "<img src=\"{$element->src}\">";
    }
}

final class PlainTextVisitor implements Visitor
{
    public function visitText(TextElement $element): string { return $element->content; }
    public function visitImage(ImageElement $element): string { return "[image: {$element->src}]"; }
}

// Demo
$elements = [new TextElement('Hello'), new ImageElement('logo.png')];
foreach ([new HtmlExportVisitor(), new PlainTextVisitor()] as $visitor) {
    foreach ($elements as $element) {
        echo $element->accept($visitor) . PHP_EOL;
    }
}
