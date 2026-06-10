<?php
// Iterator — traverse a collection without exposing its representation.
declare(strict_types=1);

/** @implements IteratorAggregate<int, string> */
final class Ring implements IteratorAggregate
{
    /** @var string[] */
    private array $items = [];

    public function push(string $item): void
    {
        $this->items[] = $item;
    }

    // Custom iterator that walks the items in reverse order.
    public function getIterator(): Iterator
    {
        return new ReverseCursor($this->items);
    }
}

/** @implements Iterator<int, string> */
final class ReverseCursor implements Iterator
{
    private int $pos;

    /** @param string[] $items */
    public function __construct(private array $items)
    {
        $this->pos = count($items) - 1;
    }

    public function current(): string { return $this->items[$this->pos]; }
    public function key(): int { return $this->pos; }
    public function next(): void { $this->pos--; }
    public function rewind(): void { $this->pos = count($this->items) - 1; }
    public function valid(): bool { return $this->pos >= 0; }
}

// Demo — client iterates without knowing the underlying storage.
$ring = new Ring();
$ring->push('one');
$ring->push('two');
$ring->push('three');

foreach ($ring as $index => $value) {
    echo "$index => $value" . PHP_EOL;
}
