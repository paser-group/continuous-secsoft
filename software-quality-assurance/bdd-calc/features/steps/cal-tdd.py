import unittest
import calculator

class TestCalc(unittest.TestCase):
    def testSubtract(self):
        self.assertEqual(2, calculator.subtract(4, 2), "Subtraction operation for 4-2 is = 2")


if __name__ == '__main__': 
    unittest.main() 