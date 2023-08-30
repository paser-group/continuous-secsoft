import unittest
import source 


class TestCalc(unittest.TestCase):
    def testSub1(self):
        self.assertEqual(1, source.performSub(2, 1), "Bug in implementation. Results should be 1.")    

if __name__ == '__main__': 
    unittest.main() 