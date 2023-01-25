import unittest
import source 


class TestCalc(unittest.TestCase):
    def testSub1(self):
        self.assertEqual(1, source.performSub(2, 1), "Bug in implementation. Results should be 1.")    

    def testSub2(self):
        self.assertEqual(10, source.performSub(20, 10), "Bug in implementation. Results should be 1.")    

if __name__ == '__main__': 
    unittest.main() 