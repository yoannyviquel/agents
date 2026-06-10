<?php
// Prototype — copy existing objects via a clone interface without coupling to classes.
declare(strict_types=1);

interface Cloneable
{
    public function duplicate(): static;
}

final class Tag
{
    public function __construct(public string $label) {}
}

final class Shape implements Cloneable
{
    /** @param Tag[] $tags */
    public function __construct(
        public string $kind,
        public int $size,
        public array $tags = [],
    ) {}

    public function duplicate(): static
    {
        $copy = clone $this;
        // Deep-copy mutable members so the clone is independent.
        $copy->tags = array_map(static fn (Tag $t) => clone $t, $this->tags);
        return $copy;
    }

    public function describe(): string
    {
        $labels = array_map(static fn (Tag $t) => $t->label, $this->tags);
        return "{$this->kind}({$this->size})[" . implode(',', $labels) . ']';
    }
}

// Demo
$original = new Shape('circle', 10, [new Tag('a'), new Tag('b')]);
$copy = $original->duplicate();
$copy->size = 20;
$copy->tags[0]->label = 'z';

echo $original->describe() . PHP_EOL; // unchanged
echo $copy->describe() . PHP_EOL;
