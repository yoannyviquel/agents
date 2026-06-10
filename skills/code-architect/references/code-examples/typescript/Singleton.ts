// Singleton — ensure one instance with a global access point.

class ConfigRegistry {
  private static instance: ConfigRegistry | null = null;
  private values = new Map<string, string>();

  // Private constructor blocks external instantiation.
  private constructor() {}

  static getInstance(): ConfigRegistry {
    if (ConfigRegistry.instance === null) {
      ConfigRegistry.instance = new ConfigRegistry();
    }
    return ConfigRegistry.instance;
  }

  set(key: string, value: string): void {
    this.values.set(key, value);
  }

  get(key: string): string | undefined {
    return this.values.get(key);
  }
}

function demo(): void {
  ConfigRegistry.getInstance().set("region", "eu-west");
  const sameInstance = ConfigRegistry.getInstance();
  console.log(`region = ${sameInstance.get("region")}`);
  console.log(`same instance: ${ConfigRegistry.getInstance() === sameInstance}`);
}

demo();
