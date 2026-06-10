<?php
// Strategy — a family of interchangeable algorithms behind one interface.
declare(strict_types=1);

interface SortStrategy
{
    /**
     * @param int[] $items
     * @return int[]
     */
    public function sort(array $items): array;
}

final class AscendingStrategy implements SortStrategy
{
    public function sort(array $items): array
    {
        sort($items);
        return $items;
    }
}

final class DescendingStrategy implements SortStrategy
{
    public function sort(array $items): array
    {
        rsort($items);
        return $items;
    }
}

final class ByAbsoluteStrategy implements SortStrategy
{
    public function sort(array $items): array
    {
        usort($items, static fn (int $a, int $b) => abs($a) <=> abs($b));
        return $items;
    }
}

// Context delegates the algorithm to the injected strategy.
final class Sorter
{
    public function __construct(private SortStrategy $strategy) {}

    public function setStrategy(SortStrategy $strategy): void
    {
        $this->strategy = $strategy;
    }

    /**
     * @param int[] $items
     * @return int[]
     */
    public function run(array $items): array
    {
        return $this->strategy->sort($items);
    }
}

// Demo
$data = [3, -1, 2, -5];
$sorter = new Sorter(new AscendingStrategy());
echo implode(',', $sorter->run($data)) . PHP_EOL;
$sorter->setStrategy(new ByAbsoluteStrategy());
echo implode(',', $sorter->run($data)) . PHP_EOL;
