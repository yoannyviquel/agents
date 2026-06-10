<?php
// Factory Method — subclasses decide which product class to instantiate via a factory method.
declare(strict_types=1);

interface Transport
{
    public function describeRoute(): string;
}

final class LandTransport implements Transport
{
    public function describeRoute(): string
    {
        return 'delivering over roads';
    }
}

final class WaterTransport implements Transport
{
    public function describeRoute(): string
    {
        return 'delivering across the sea';
    }
}

abstract class Dispatcher
{
    // The factory method: each subclass returns its own product.
    abstract protected function createTransport(): Transport;

    public function planDelivery(): string
    {
        $transport = $this->createTransport();
        return 'Dispatcher is ' . $transport->describeRoute();
    }
}

final class RoadDispatcher extends Dispatcher
{
    protected function createTransport(): Transport
    {
        return new LandTransport();
    }
}

final class SeaDispatcher extends Dispatcher
{
    protected function createTransport(): Transport
    {
        return new WaterTransport();
    }
}

function clientCode(Dispatcher $dispatcher): void
{
    echo $dispatcher->planDelivery() . PHP_EOL;
}

// Demo
clientCode(new RoadDispatcher());
clientCode(new SeaDispatcher());
