<?php
// Observer — subscription mechanism to notify subscribers of events.
declare(strict_types=1);

interface Observer
{
    public function update(string $event): void;
}

interface Subject
{
    public function subscribe(Observer $observer): void;
    public function unsubscribe(Observer $observer): void;
    public function publish(string $event): void;
}

final class EventHub implements Subject
{
    /** @var Observer[] */
    private array $observers = [];

    public function subscribe(Observer $observer): void
    {
        $this->observers[spl_object_id($observer)] = $observer;
    }

    public function unsubscribe(Observer $observer): void
    {
        unset($this->observers[spl_object_id($observer)]);
    }

    public function publish(string $event): void
    {
        foreach ($this->observers as $observer) {
            $observer->update($event);
        }
    }
}

final class LoggingObserver implements Observer
{
    public function __construct(private string $name) {}

    public function update(string $event): void
    {
        echo "{$this->name} received: $event" . PHP_EOL;
    }
}

// Demo
$hub = new EventHub();
$a = new LoggingObserver('A');
$b = new LoggingObserver('B');

$hub->subscribe($a);
$hub->subscribe($b);
$hub->publish('order.created');

$hub->unsubscribe($a);
$hub->publish('order.shipped');
