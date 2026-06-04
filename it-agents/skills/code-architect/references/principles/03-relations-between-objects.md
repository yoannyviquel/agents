# Relations Between Objects

Beyond inheritance and implementation, objects can relate to each other through dependency, association, aggregation, and composition — listed here from the weakest to the strongest relation.

## Dependency

**Dependency** is the most basic and weakest relation between classes. There is a dependency between two classes if changes to the definition of one class might require modifications to another. It typically occurs when you use concrete class names in code — for example, specifying types in method signatures, or instantiating objects via constructor calls. You can make a dependency weaker by depending on interfaces or abstract classes instead of concrete classes.

A UML diagram doesn't show every dependency (there are far too many in real code). Be selective and show only those important to whatever you are communicating. (UML dependency example: a professor depends on the course materials.)

## Association

**Association** is a relationship in which one object uses or interacts with another. In UML it is shown by a simple arrow from an object pointing to the object it uses; a bi-directional association is normal and has a point at each end. Association is a specialized kind of dependency where an object always has access to the objects it interacts with, whereas a simple dependency doesn't establish a permanent link.

Generally, an association represents a field holding another object — that field is the link between the two objects. But it doesn't have to be a field: association can also be a method that returns some object. (Otherwise association couldn't exist between interfaces, since interfaces have no fields.) UML association example: a professor communicates with students.

## Dependency vs. Association — Combined Example

```
class Professor is
    field Student student
    method teach(Course c) is
        // ...
        this.student.remember(c.getKnowledge())
```

- The `teach` method takes a `Course` argument used in its body. If someone changes the signature of `getKnowledge`, this code breaks. So `Professor` **depends on** `Course`.
- The `student` field is used in `teach` too. If the signature of `remember` changes, `Professor`'s code breaks — so `Student` is a dependency. But since the `student` field is always accessible to any method of `Professor`, `Student` is not merely a dependency but also an **association**.

## Aggregation

**Aggregation** is a specialized association representing "one-to-many", "many-to-many", or "whole-part" relations between multiple objects. Under aggregation, an object "has" a set of other objects and serves as a container or collection. The component can exist without the container and can be linked to several containers at the same time. In UML it is shown by a line with an empty diamond at the container end and an arrow pointing toward the component. (Example: a department contains professors.)

Keep in mind that UML represents relations between *classes*: a university object might consist of multiple departments even though the diagram shows just one block per entity. UML can show quantities on both sides of relationships, but they may be omitted when clear from context.

## Composition

**Composition** is a specific kind of aggregation where one object is composed of one or more instances of another. The distinction is that the **component can only exist as part of the container**. In UML it is drawn like aggregation but with a *filled* diamond at the arrow's base. (Example: a university consists of departments.)

Note that many people say "composition" when they really mean both aggregation and composition — most famously in the principle "choose composition over inheritance." This is because the word "composition" (e.g. "object composition") simply sounds more natural in English, not because people are unaware of the difference.

## The Big Picture (weakest to strongest)

- **Dependency**: Class A can be affected by changes in class B.
- **Association**: Object A knows about object B. Class A depends on B.
- **Aggregation**: Object A knows about object B and consists of B. Class A depends on B.
- **Composition**: Object A knows about object B, consists of B, and manages B's life cycle. Class A depends on B.
- **Implementation**: Class A defines methods declared in interface B. Objects A can be treated as B. Class A depends on B.
- **Inheritance**: Class A inherits the interface and implementation of class B but can extend it. Objects A can be treated as B. Class A depends on B.
