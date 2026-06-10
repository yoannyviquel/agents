<?php
// Adapter — make an incompatible interface usable via a wrapper.
declare(strict_types=1);

// Interface the client expects.
interface JsonSource
{
    public function fetchJson(): string;
}

// Existing incompatible class we cannot change.
final class LegacyXmlProvider
{
    public function getXml(): string
    {
        return '<item id="42"><name>Widget</name></item>';
    }
}

// Adapter bridges LegacyXmlProvider to JsonSource.
final class XmlToJsonAdapter implements JsonSource
{
    public function __construct(private LegacyXmlProvider $provider) {}

    public function fetchJson(): string
    {
        $xml = simplexml_load_string($this->provider->getXml());
        return json_encode([
            'id' => (string) $xml['id'],
            'name' => (string) $xml->name,
        ]);
    }
}

function consume(JsonSource $source): void
{
    echo $source->fetchJson() . PHP_EOL;
}

// Demo
consume(new XmlToJsonAdapter(new LegacyXmlProvider()));
