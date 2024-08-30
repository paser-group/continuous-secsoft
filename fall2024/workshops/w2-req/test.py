import unittest
import source

class TestAddition(unittest.TestCase):
    def testAddition1(self): 
        self.assertEqual(3, source.performAdd(2, 1), "Error in implementation.")

    def testAddition2(self):
        self.assertEqual(101, source.performAdd(100, 1), "Error again!") 

class TestSubtraction(unittest.TestCase):
    def testSub1(self):
        self.assertEqual(5, source.performSub(10, 5), "Error!")
    
    def testSub2(self):
        self.assertEqual(-1, source.performSub(5, 6), "Error in subtraction.")


if __name__ == '__main__': 
    unittest.main() 
