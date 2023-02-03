import unittest
import source 


class TestCalc(unittest.TestCase):
    def testSub1(self):
        self.assertEqual(1, source.performSub(2, 1), "Bug in implementation. Results should be 1.")    

    def testSub2(self):
        self.assertEqual(10, source.performSub(20, 10), "Bug in implementation. Results should be 1.")    

    def testDivZero(self):
        self.assertEqual("Put in correct divisor", source.performSub(20, 0), "Bug in implementation.")    

if __name__ == '__main__': 
    unittest.main() 