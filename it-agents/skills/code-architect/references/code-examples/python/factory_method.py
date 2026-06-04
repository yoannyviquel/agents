"""Factory Method — subclasses decide which product class to instantiate via a factory method."""

from abc import ABC, abstractmethod


class Product(ABC):
    @abstractmethod
    def describe(self) -> str:
        ...


class StandardProduct(Product):
    def describe(self) -> str:
        return "a standard product"


class PremiumProduct(Product):
    def describe(self) -> str:
        return "a premium product"


class Creator(ABC):
    """Declares the factory method; relies on the product through its interface."""

    @abstractmethod
    def make_product(self) -> Product:
        ...

    def deliver(self) -> str:
        product = self.make_product()
        return f"Delivering {product.describe()}."


class StandardCreator(Creator):
    def make_product(self) -> Product:
        return StandardProduct()


class PremiumCreator(Creator):
    def make_product(self) -> Product:
        return PremiumProduct()


if __name__ == "__main__":
    for creator in (StandardCreator(), PremiumCreator()):
        print(creator.deliver())
