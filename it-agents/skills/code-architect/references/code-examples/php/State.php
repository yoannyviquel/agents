<?php
// State — let an object alter behavior when its state changes (state objects).
declare(strict_types=1);

interface TrafficState
{
    public function next(TrafficLight $light): void;
    public function signal(): string;
}

final class TrafficLight
{
    private TrafficState $state;

    public function __construct()
    {
        $this->state = new RedState();
    }

    public function setState(TrafficState $state): void
    {
        $this->state = $state;
    }

    public function advance(): void
    {
        $this->state->next($this);
    }

    public function signal(): string
    {
        return $this->state->signal();
    }
}

final class RedState implements TrafficState
{
    public function next(TrafficLight $light): void { $light->setState(new GreenState()); }
    public function signal(): string { return 'RED — stop'; }
}

final class GreenState implements TrafficState
{
    public function next(TrafficLight $light): void { $light->setState(new YellowState()); }
    public function signal(): string { return 'GREEN — go'; }
}

final class YellowState implements TrafficState
{
    public function next(TrafficLight $light): void { $light->setState(new RedState()); }
    public function signal(): string { return 'YELLOW — slow'; }
}

// Demo
$light = new TrafficLight();
for ($i = 0; $i < 4; $i++) {
    echo $light->signal() . PHP_EOL;
    $light->advance();
}
