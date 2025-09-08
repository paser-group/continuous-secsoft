import unittest

# Assuming the functions are defined in a module named `math_ops.py`
# from math_ops import addition, subtraction

# For standalone testing, include the functions directly
def addition(x, y):
    return x + y

def subtraction(x, y):
    return x - y    

class TestMathOperations(unittest.TestCase):

    # Tests for addition
    def test_addition_positive_numbers(self):
        self.assertEqual(addition(3, 5), 8)

    def test_addition_negative_numbers(self):
        self.assertEqual(addition(-3, -7), -10)

    def test_addition_mixed_sign(self):
        self.assertEqual(addition(-3, 7), 4)

    def test_addition_zero(self):
        self.assertEqual(addition(0, 5), 5)
        self.assertEqual(addition(5, 0), 5)

    def test_addition_large_numbers(self):
        self.assertEqual(addition(1_000_000, 2_000_000), 3_000_000)

    def test_addition_floats(self):
        self.assertAlmostEqual(addition(2.5, 3.1), 5.6)

    # Tests for subtraction
    def test_subtraction_positive_numbers(self):
        self.assertEqual(subtraction(10, 4), 6)

    def test_subtraction_negative_numbers(self):
        self.assertEqual(subtraction(-5, -2), -3)

    def test_subtraction_mixed_sign(self):
        self.assertEqual(subtraction(5, -3), 8)
        self.assertEqual(subtraction(-5, 3), -8)

    def test_subtraction_zero(self):
        self.assertEqual(subtraction(0, 4), -4)
        self.assertEqual(subtraction(4, 0), 4)

    def test_subtraction_large_numbers(self):
        self.assertEqual(subtraction(2_000_000, 1_000_000), 1_000_000)

    def test_subtraction_floats(self):
        self.assertAlmostEqual(subtraction(5.5, 2.2), 3.3)

if __name__ == '__main__':
    unittest.main()

