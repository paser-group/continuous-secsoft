'''
Akond Rahman 
Oct 05, 2020 
Python Unit Testing Example 
'''

import unittest
import simpleCalc 


class TestSum(unittest.TestCase):

    def test_sum(self):
        self.assertEqual( simpleCalc.add([1, 2, 3]), 6, "Should be 6")

    def test_subtract(self): 
        self.assertEqual(simpleCalc.subtract(3, 2) , 1, "Should be 1")

    def test_multiply(self):
        self.assertEqual( simpleCalc.multiply(3, 2), 6, "Should be 6"   )

if __name__ == '__main__':
    unittest.main()