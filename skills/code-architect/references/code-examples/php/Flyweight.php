<?php
// Flyweight — share intrinsic state across many objects to save memory.
declare(strict_types=1);

// Intrinsic, shareable state.
final class GlyphStyle
{
    public function __construct(
        public readonly string $font,
        public readonly int $size,
    ) {}
}

// Factory caches and reuses flyweights.
final class GlyphStyleFactory
{
    /** @var array<string, GlyphStyle> */
    private array $pool = [];

    public function get(string $font, int $size): GlyphStyle
    {
        $key = "$font:$size";
        return $this->pool[$key] ??= new GlyphStyle($font, $size);
    }

    public function count(): int
    {
        return count($this->pool);
    }
}

// Context combines extrinsic state with a shared flyweight.
final class Character
{
    public function __construct(
        public string $char,
        public GlyphStyle $style,
    ) {}

    public function render(): string
    {
        return "{$this->char}<{$this->style->font}/{$this->style->size}>";
    }
}

// Demo — many characters, few shared styles.
$factory = new GlyphStyleFactory();
$text = [];
foreach (str_split('aaab') as $c) {
    $text[] = new Character($c, $factory->get('serif', 12));
}
$text[] = new Character('!', $factory->get('mono', 14));

echo implode(' ', array_map(static fn (Character $c) => $c->render(), $text)) . PHP_EOL;
echo "distinct styles: {$factory->count()}" . PHP_EOL;
