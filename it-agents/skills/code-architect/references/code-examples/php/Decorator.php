<?php
// Decorator — attach responsibilities by wrapping objects at runtime.
declare(strict_types=1);

interface TextStream
{
    public function output(string $data): string;
}

final class RawStream implements TextStream
{
    public function output(string $data): string
    {
        return $data;
    }
}

abstract class StreamDecorator implements TextStream
{
    public function __construct(protected TextStream $wrapped) {}
}

final class UppercaseDecorator extends StreamDecorator
{
    public function output(string $data): string
    {
        return strtoupper($this->wrapped->output($data));
    }
}

final class BracketDecorator extends StreamDecorator
{
    public function output(string $data): string
    {
        return '[' . $this->wrapped->output($data) . ']';
    }
}

final class RepeatDecorator extends StreamDecorator
{
    public function __construct(TextStream $wrapped, private int $times)
    {
        parent::__construct($wrapped);
    }

    public function output(string $data): string
    {
        return str_repeat($this->wrapped->output($data), $this->times);
    }
}

// Demo — stack decorators in any order.
$stream = new RepeatDecorator(new BracketDecorator(new UppercaseDecorator(new RawStream())), 2);
echo $stream->output('hi') . PHP_EOL;
