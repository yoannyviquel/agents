<?php
// Template Method — algorithm skeleton in a base class with overridable steps.
declare(strict_types=1);

abstract class ReportGenerator
{
    // The template method defines the invariant skeleton.
    final public function generate(array $rows): string
    {
        $out = $this->header();
        foreach ($rows as $row) {
            $out .= $this->formatRow($row);
        }
        $out .= $this->footer();
        return $out;
    }

    abstract protected function formatRow(string $row): string;

    // Steps with sensible defaults (hooks) subclasses may override.
    protected function header(): string { return ''; }
    protected function footer(): string { return ''; }
}

final class CsvReport extends ReportGenerator
{
    protected function header(): string { return "value\n"; }
    protected function formatRow(string $row): string { return $row . "\n"; }
}

final class HtmlReport extends ReportGenerator
{
    protected function header(): string { return "<ul>\n"; }
    protected function formatRow(string $row): string { return "  <li>$row</li>\n"; }
    protected function footer(): string { return "</ul>\n"; }
}

// Demo
$rows = ['alpha', 'beta'];
echo (new CsvReport())->generate($rows);
echo (new HtmlReport())->generate($rows);
