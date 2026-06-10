// Proxy — a placeholder controlling access to a real object (lazy + caching).

interface ImageResource {
  fetch(): string;
}

// The real, expensive subject.
class RemoteImage implements ImageResource {
  constructor(private readonly url: string) {
    console.log(`loading heavy resource: ${url}`);
  }
  fetch(): string {
    return `<bytes of ${this.url}>`;
  }
}

// Proxy defers creation and caches the result.
class LazyImageProxy implements ImageResource {
  private real: RemoteImage | null = null;
  private cached: string | null = null;

  constructor(private readonly url: string) {}

  fetch(): string {
    if (this.real === null) {
      this.real = new RemoteImage(this.url);
    }
    if (this.cached === null) {
      this.cached = this.real.fetch();
    }
    return this.cached;
  }
}

function demo(): void {
  const image: ImageResource = new LazyImageProxy("photo.png");
  console.log("proxy created (nothing loaded yet)");
  console.log(image.fetch()); // triggers load
  console.log(image.fetch()); // served from cache
}

demo();
