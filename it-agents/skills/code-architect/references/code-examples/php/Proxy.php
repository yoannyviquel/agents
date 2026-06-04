<?php
// Proxy — a placeholder controlling access to a real object (lazy load + caching).
declare(strict_types=1);

interface DataService
{
    public function query(string $key): string;
}

// Real subject — assumed expensive to create and call.
final class RemoteDataService implements DataService
{
    public function __construct()
    {
        echo "[RemoteDataService connected]" . PHP_EOL;
    }

    public function query(string $key): string
    {
        return "result-for-$key";
    }
}

// Proxy delays creation and caches results.
final class CachingDataServiceProxy implements DataService
{
    private ?RemoteDataService $real = null;

    /** @var array<string, string> */
    private array $cache = [];

    public function query(string $key): string
    {
        if (isset($this->cache[$key])) {
            return $this->cache[$key] . ' (cached)';
        }
        $this->real ??= new RemoteDataService();
        return $this->cache[$key] = $this->real->query($key);
    }
}

// Demo
$service = new CachingDataServiceProxy();
echo $service->query('a') . PHP_EOL;
echo $service->query('a') . PHP_EOL;
echo $service->query('b') . PHP_EOL;
