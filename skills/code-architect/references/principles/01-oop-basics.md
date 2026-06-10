# Basics of OOP

Object-oriented programming is a paradigm based on wrapping pieces of data, and the behavior related to that data, into special bundles called objects, which are constructed from a set of "blueprints" called classes (defined by a programmer).

## Objects and Classes

Say you have a cat named Oscar. Oscar is an object, an instance of the `Cat` class. Every cat has standard attributes: name, sex, age, weight, color, favorite food, etc. These are the class's **fields**.

All cats also behave similarly: they breathe, eat, run, sleep, and meow. These are the class's **methods**. Collectively, fields and methods are the **members** of their class.

- Data stored inside an object's fields is often called its **state**.
- All of an object's methods define its **behavior**.

Luna, a friend's cat, is also an instance of the `Cat` class. It has the same set of attributes as Oscar, but the values differ: its sex is female, it has a different color, and it weighs less. So a class is like a blueprint that defines the structure for objects, and objects are concrete instances of that class.

## Class Hierarchies

A real program contains more than a single class, and some classes may be organized into class hierarchies.

Say a neighbor has a dog called Fido. Dogs and cats have a lot in common: name, sex, age, and color are attributes of both; both can breathe, sleep, and run the same way. So we can define a base `Animal` class that lists the common attributes and behaviors.

- A parent class is called a **superclass**.
- Its children are **subclasses**.
- Subclasses inherit state and behavior from their parent, defining only the attributes or behaviors that differ. For example, `Cat` would have the `meow` method and `Dog` the `bark` method.

(A UML class diagram can show all classes belonging to a single hierarchy, such as the `Animal` hierarchy.)

If a related business requirement exists, we can go further and extract a more general class for all living `Organisms`, which becomes a superclass for `Animals` and `Plants`. Such a pyramid of classes is a **hierarchy**. In it, the `Cat` class inherits everything from both the `Animal` and `Organism` classes.

In a UML diagram, classes can be simplified (their contents omitted) when it is more important to show their relations than their contents.

## Overriding Inherited Behavior

Subclasses can **override** the behavior of methods they inherit from parent classes. A subclass can either completely replace the default behavior or just enhance it with some extra functionality.
