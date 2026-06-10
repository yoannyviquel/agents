<?php
// Chain of Responsibility — pass a request along a chain of handlers.
declare(strict_types=1);

abstract class Handler
{
    private ?Handler $next = null;

    public function setNext(Handler $next): Handler
    {
        $this->next = $next;
        return $next; // allow fluent chaining
    }

    public function handle(int $amount): string
    {
        return $this->next?->handle($amount) ?? "unhandled: $amount";
    }
}

final class SmallApprover extends Handler
{
    public function handle(int $amount): string
    {
        return $amount <= 100 ? "SmallApprover approved $amount" : parent::handle($amount);
    }
}

final class TeamLeadApprover extends Handler
{
    public function handle(int $amount): string
    {
        return $amount <= 1000 ? "TeamLeadApprover approved $amount" : parent::handle($amount);
    }
}

final class DirectorApprover extends Handler
{
    public function handle(int $amount): string
    {
        return $amount <= 10000 ? "DirectorApprover approved $amount" : parent::handle($amount);
    }
}

// Demo — build chain, then send requests through the head.
$head = new SmallApprover();
$head->setNext(new TeamLeadApprover())->setNext(new DirectorApprover());

foreach ([50, 500, 5000, 50000] as $amount) {
    echo $head->handle($amount) . PHP_EOL;
}
