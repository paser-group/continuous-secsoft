import unittest
import source 


class TestCalc(unittest.TestCase):
    def testSub1(self): 
        self.assertEqual(4, source.performSub(5, 1), "Bug in code!" )

    def testSub2(self):
        self.assertEqual(1, source.performSub(2, 1), "Bug in code!")

class TestAddition(unittest.TestCase):
    def testAddition1(self): 
        self.assertEqual(3, source.performAdd(2, 1), "Error in implementation.")

    def testAddition2(self): 
        self.assertEqual(0, source.performAdd(1, -1), "Error in code!")

if __name__ == '__main__': 
    unittest.main() 