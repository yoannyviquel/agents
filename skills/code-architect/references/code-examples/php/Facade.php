<?php
// Facade — a simplified interface over a complex subsystem.
declare(strict_types=1);

// Subsystem parts.
final class Encoder
{
    public function encode(string $raw): string { return base64_encode($raw); }
}

final class Compressor
{
    public function compress(string $data): string { return "gz(" . strlen($data) . ")"; }
}

final class Uploader
{
    public function upload(string $payload): string { return "uploaded:$payload"; }
}

// Facade hides the orchestration of the subsystem.
final class MediaPipeline
{
    public function __construct(
        private Encoder $encoder = new Encoder(),
        private Compressor $compressor = new Compressor(),
        private Uploader $uploader = new Uploader(),
    ) {}

    public function publish(string $raw): string
    {
        $encoded = $this->encoder->encode($raw);
        $compressed = $this->compressor->compress($encoded);
        return $this->uploader->upload($compressed);
    }
}

// Demo — client deals with one simple call.
echo (new MediaPipeline())->publish('hello world') . PHP_EOL;
