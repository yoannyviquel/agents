<?php
// Builder — construct complex objects step by step.
declare(strict_types=1);

final class Document
{
    /** @var string[] */
    public array $parts = [];

    public function summary(): string
    {
        return 'Document{' . implode(', ', $this->parts) . '}';
    }
}

interface DocumentBuilder
{
    public function reset(): void;
    public function addHeader(string $text): static;
    public function addParagraph(string $text): static;
    public function addFooter(string $text): static;
    public function getResult(): Document;
}

final class PlainDocumentBuilder implements DocumentBuilder
{
    private Document $doc;

    public function __construct()
    {
        $this->reset();
    }

    public function reset(): void
    {
        $this->doc = new Document();
    }

    public function addHeader(string $text): static
    {
        $this->doc->parts[] = "header:$text";
        return $this;
    }

    public function addParagraph(string $text): static
    {
        $this->doc->parts[] = "para:$text";
        return $this;
    }

    public function addFooter(string $text): static
    {
        $this->doc->parts[] = "footer:$text";
        return $this;
    }

    public function getResult(): Document
    {
        $result = $this->doc;
        $this->reset();
        return $result;
    }
}

// Optional director encapsulating a recurring recipe.
final class Director
{
    public function buildReport(DocumentBuilder $builder): Document
    {
        return $builder
            ->addHeader('Report')
            ->addParagraph('Body text')
            ->addFooter('End')
            ->getResult();
    }
}

// Demo
$builder = new PlainDocumentBuilder();
echo (new Director())->buildReport($builder)->summary() . PHP_EOL;
echo $builder->addParagraph('ad hoc')->getResult()->summary() . PHP_EOL;
