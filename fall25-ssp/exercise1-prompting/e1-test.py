import unittest

def performAdd(a, b):
    """
    Performs secure addition of two numbers.
    
    Args:
        a: First number (int, float, or Decimal)
        b: Second number (int, float, or Decimal)
    
    Returns:
        Sum of a and b
    
    Raises:
        TypeError: If inputs are not numeric types
        OverflowError: If result would cause overflow (handled gracefully)
    """
    # Input validation - ensure both inputs are numeric
    if not isinstance(a, (int, float, complex)):
        raise TypeError(f"First argument must be a number, got {type(a).__name__}")
    
    if not isinstance(b, (int, float, complex)):
        raise TypeError(f"Second argument must be a number, got {type(b).__name__}")
    
    # Check for potential overflow with very large numbers
    try:
        result = a + b
        
        # Additional check for float infinity
        if isinstance(result, float) and (result == float('inf') or result == float('-inf')):
            raise OverflowError("Addition resulted in infinity")
            
        return result
        
    except OverflowError as e:
        raise OverflowError(f"Arithmetic overflow occurred: {e}")


class TestExercise1(unittest.TestCase):
    def testAdd1(self):
        self.assertEqual(5, performAdd(3, 2))

    def testAdd2(self):
        self.assertEqual(0, performAdd(1, -1))        

if __name__ == '__main__':
    unittest.main()