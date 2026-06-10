# Pillars of OOP

Object-oriented programming is based on four pillars — concepts that differentiate it from other programming paradigms: Abstraction, Encapsulation, Inheritance, and Polymorphism.

## Abstraction

When you build a program with OOP, you shape its objects based on real-world objects. However, program objects don't represent the originals with 100% accuracy (and that's rarely required). Instead, your objects model only the attributes and behaviors of real objects relevant to a specific context, ignoring the rest.

For example, an `Airplane` class could exist in both a flight simulator and a flight booking application. In the simulator it would hold details related to the actual flight, whereas in the booking app you would care only about the seat map and which seats are available — different models of the same real-world object.

**Abstraction** is a model of a real-world object or phenomenon, limited to a specific context, which represents all details relevant to that context with high accuracy and omits the rest.

## Encapsulation

To start a car engine, you only turn a key or press a button. You don't connect wires, rotate the crankshaft and cylinders, or initiate the power cycle — those details are hidden under the hood. You have only a simple interface: a start switch, a steering wheel, and pedals. Each object likewise has an **interface** — a public part open to interactions with other objects.

**Encapsulation** is the ability of an object to hide parts of its state and behaviors from other objects, exposing only a limited interface to the rest of the program.

- To encapsulate something means to make it **private**, accessible only from within the methods of its own class.
- A less restrictive mode, **protected**, makes a member available to subclasses as well.

Interfaces and abstract classes/methods of most languages are based on abstraction and encapsulation. In modern OOP languages the interface mechanism (the `interface` or `protocol` keyword) lets you define contracts of interaction between objects. Interfaces only care about the behaviors of objects, which is why you can't declare a field in an interface.

> Note: the word "interface" stands for the public part of an object, but most languages also have an interface *type* — this overlap is admittedly confusing.

For example, with a `FlyingTransport` interface containing `fly(origin, destination, passengers)`, an air-transport simulator's `Airport` class could be restricted to work only with objects that implement `FlyingTransport`. Then any object passed to an airport — an `Airplane`, a `Helicopter`, or even a `DomesticatedGryphon` — is guaranteed able to arrive or depart. You can change each class's implementation of `fly` however you want; as long as the method signature stays the same as declared in the interface, all `Airport` instances keep working with the flying objects.

## Inheritance

**Inheritance** is the ability to build new classes on top of existing ones. Its main benefit is **code reuse**: to create a class that's slightly different from an existing one, you don't duplicate code — you extend the existing class and put the extra functionality into a subclass, which inherits the superclass's fields and methods.

A consequence of inheritance: subclasses have the same interface as their parent class.

- You can't hide a method in a subclass if it was declared in the superclass.
- You must implement all abstract methods, even if they don't make sense for your subclass.

In most languages a subclass can extend only one superclass, but any class can implement several interfaces at the same time. And if a superclass implements an interface, all of its subclasses must also implement it.

## Polymorphism

Most `Animal`s can make sounds. Since we expect every subclass to override the base `makeSound` method to emit its correct sound, we can declare `makeSound` **abstract** in the superclass — omitting any default implementation while forcing all subclasses to provide their own.

Imagine putting several cats and dogs into a large bag, then pulling them out one by one with closed eyes. You don't know which animal you grabbed, but if you cuddle it, it emits a sound of joy specific to its concrete class:

```
bag = [new Cat(), new Dog()]
foreach (Animal a : bag)
    a.makeSound()
// Meow!
// Woof!
```

The program doesn't know the concrete type of the object in `a`, but thanks to polymorphism it traces the object's subclass and runs the appropriate behavior.

**Polymorphism** is the ability of a program to detect the real class of an object and call its implementation even when its real type is unknown in the current context. You can also think of it as an object's ability to "pretend" to be something else — usually a class it extends or an interface it implements. In the example, the dogs and cats in the bag were pretending to be generic animals.
