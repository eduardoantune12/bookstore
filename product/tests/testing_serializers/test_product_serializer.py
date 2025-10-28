from django.test import TestCase

from product.factories import ProductFactory, CategoryFactory
from product.serializers.product_serializer import ProductSerializer


class TestProductSerializer(TestCase):
    def setUp(self) -> None:
        self.category = CategoryFactory(title="technology")
        self.product_1 = ProductFactory(
            title="mouse", price=5.00, category=[self.category]
        )
        self.product_serializer = ProductSerializer(self.product_1)

    def test_product_serializer(self):
        serializer_data = self.product_serializer.data
        self.assertEqual(serializer_data["price"], 100)
        self.assertEqual(serializer_data["title"], "mouse")
        self.assertEqual(serializer_data["category"][0]["title"], "technology")