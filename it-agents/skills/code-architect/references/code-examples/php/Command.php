<?php
// Command — encapsulate a request as an object, support undo.
declare(strict_types=1);

// Receiver holding the state.
final class Counter
{
    public int $value = 0;
}

interface Command
{
    public function execute(): void;
    public function undo(): void;
}

final class AddCommand implements Command
{
    public function __construct(private Counter $counter, private int $by) {}

    public function execute(): void { $this->counter->value += $this->by; }
    public function undo(): void { $this->counter->value -= $this->by; }
}

// Invoker records history to support undo.
final class CommandRunner
{
    /** @var Command[] */
    private array $history = [];

    public function run(Command $command): void
    {
        $command->execute();
        $this->history[] = $command;
    }

    public function undoLast(): void
    {
        $command = array_pop($this->history);
        $command?->undo();
    }
}

// Demo
$counter = new Counter();
$runner = new CommandRunner();
$runner->run(new AddCommand($counter, 5));
$runner->run(new AddCommand($counter, 3));
echo "value={$counter->value}" . PHP_EOL; // 8
$runner->undoLast();
echo "value={$counter->value}" . PHP_EOL; // 5
