<?php
// Composite — compose objects into trees, treat leaf and container uniformly.
declare(strict_types=1);

interface Node
{
    public function size(): int;
    public function render(int $depth = 0): string;
}

final class FileLeaf implements Node
{
    public function __construct(private string $name, private int $bytes) {}

    public function size(): int
    {
        return $this->bytes;
    }

    public function render(int $depth = 0): string
    {
        return str_repeat('  ', $depth) . "- {$this->name} ({$this->bytes}b)" . PHP_EOL;
    }
}

final class FolderComposite implements Node
{
    /** @var Node[] */
    private array $children = [];

    public function __construct(private string $name) {}

    public function add(Node $child): static
    {
        $this->children[] = $child;
        return $this;
    }

    public function size(): int
    {
        return array_sum(array_map(static fn (Node $n) => $n->size(), $this->children));
    }

    public function render(int $depth = 0): string
    {
        $out = str_repeat('  ', $depth) . "+ {$this->name}/ ({$this->size()}b)" . PHP_EOL;
        foreach ($this->children as $child) {
            $out .= $child->render($depth + 1);
        }
        return $out;
    }
}

// Demo
$root = (new FolderComposite('root'))
    ->add(new FileLeaf('readme.txt', 12))
    ->add(
        (new FolderComposite('src'))
            ->add(new FileLeaf('main.php', 100))
            ->add(new FileLeaf('util.php', 50))
    );

echo $root->render();
