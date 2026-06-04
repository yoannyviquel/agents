// State — let an object alter behavior when its internal state changes.

interface DoorState {
  open(door: Door): void;
  close(door: Door): void;
  label(): string;
}

class ClosedState implements DoorState {
  open(door: Door): void {
    console.log("opening door");
    door.setState(new OpenState());
  }
  close(): void {
    console.log("door already closed");
  }
  label(): string {
    return "closed";
  }
}

class OpenState implements DoorState {
  open(): void {
    console.log("door already open");
  }
  close(door: Door): void {
    console.log("closing door");
    door.setState(new ClosedState());
  }
  label(): string {
    return "open";
  }
}

// Context delegates behavior to the current state object.
class Door {
  private state: DoorState = new ClosedState();

  setState(state: DoorState): void {
    this.state = state;
  }
  open(): void {
    this.state.open(this);
  }
  close(): void {
    this.state.close(this);
  }
  get status(): string {
    return this.state.label();
  }
}

function demo(): void {
  const door = new Door();
  console.log(`status: ${door.status}`);
  door.open();
  door.open();
  door.close();
  console.log(`status: ${door.status}`);
}

demo();
