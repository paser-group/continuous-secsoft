import unittest
import source

class TestAddition(unittest.TestCase):
    def testAddition1(self): 
        self.assertEqual(3, source.performAdd(2, 1), "Error in implementation.")

    def testAddition2(self):
        self.assertEqual(30, source.performAdd(20, 10), "Error in implementation.")

class TestSub(unittest.TestCase):
    def testSub1(self):
        self.assertEqual(3, source.performSub(6, 3), "Error in implementation.")

if __name__ == '__main__': 
    unittest.main() 
