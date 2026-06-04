<?php
// Memento — capture and restore an object's state without breaking encapsulation.
declare(strict_types=1);

// Memento exposes nothing mutable to the outside world.
final class Snapshot
{
    public function __construct(private readonly string $state) {}

    // Only the originator reads the stored state.
    public function state(): string
    {
        return $this->state;
    }
}

// Originator creates and restores from snapshots.
final class Editor
{
    private string $content = '';

    public function write(string $text): void
    {
        $this->content .= $text;
    }

    public function content(): string
    {
        return $this->content;
    }

    public function save(): Snapshot
    {
        return new Snapshot($this->content);
    }

    public function restore(Snapshot $snapshot): void
    {
        $this->content = $snapshot->state();
    }
}

// Caretaker keeps history but never inspects memento internals.
final class History
{
    /** @var Snapshot[] */
    private array $stack = [];

    public function push(Snapshot $snapshot): void { $this->stack[] = $snapshot; }
    public function pop(): ?Snapshot { return array_pop($this->stack); }
}

// Demo
$editor = new Editor();
$history = new History();

$editor->write('Hello');
$history->push($editor->save());
$editor->write(' World');

echo $editor->content() . PHP_EOL; // Hello World
$editor->restore($history->pop());
echo $editor->content() . PHP_EOL; // Hello
