<?php
// Bridge — split abstraction and implementation into independent hierarchies.
declare(strict_types=1);

// Implementation hierarchy.
interface Renderer
{
    public function drawShape(string $name, float $area): string;
}

final class VectorRenderer implements Renderer
{
    public function drawShape(string $name, float $area): string
    {
        return "Vector $name (area=$area)";
    }
}

final class RasterRenderer implements Renderer
{
    public function drawShape(string $name, float $area): string
    {
        return "Pixels of $name (area=$area)";
    }
}

// Abstraction hierarchy, holds a reference to an implementation.
abstract class Figure
{
    public function __construct(protected Renderer $renderer) {}
    abstract public function draw(): string;
}

final class Circle extends Figure
{
    public function __construct(Renderer $renderer, private float $radius)
    {
        parent::__construct($renderer);
    }

    public function draw(): string
    {
        return $this->renderer->drawShape('circle', M_PI * $this->radius ** 2);
    }
}

final class Square extends Figure
{
    public function __construct(Renderer $renderer, private float $side)
    {
        parent::__construct($renderer);
    }

    public function draw(): string
    {
        return $this->renderer->drawShape('square', $this->side ** 2);
    }
}

// Demo
echo (new Circle(new VectorRenderer(), 2.0))->draw() . PHP_EOL;
echo (new Square(new RasterRenderer(), 3.0))->draw() . PHP_EOL;
