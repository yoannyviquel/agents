<?php
// Singleton — ensure one instance with a global access point.
declare(strict_types=1);

final class Registry
{
    private static ?Registry $instance = null;

    /** @var array<string, string> */
    private array $store = [];

    // Prevent external construction and copying.
    private function __construct() {}
    private function __clone() {}

    public static function instance(): self
    {
        return self::$instance ??= new self();
    }

    public function set(string $key, string $value): void
    {
        $this->store[$key] = $value;
    }

    public function get(string $key): ?string
    {
        return $this->store[$key] ?? null;
    }
}

// Demo
Registry::instance()->set('env', 'prod');
echo Registry::instance()->get('env') . PHP_EOL;
echo (Registry::instance() === Registry::instance() ? 'same instance' : 'different') . PHP_EOL;
