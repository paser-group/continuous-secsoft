import unittest
from scipy.stats import mannwhitneyu

def getComparison(ls1, ls2):
    str2ret = ''
    u_statistic, p_value = mannwhitneyu(ls1, ls2, alternative='two-sided')
    print(f"U statistic: {u_statistic}")
    print(f"P-value: {p_value}")
    if p_value < 0.05: 
       str2ret = 'Significant'
    else:
       str2ret = 'Not-Significant'
    return str2ret

class TestGenAI(unittest.TestCase):

    # 
    def test1(self):
        x = [1, 1, 2, 3, 1, 1, 4]
        y = [6, 4, 7, 1, 3 , 7, 3, 7] 
        self.assertEqual('Significant', getComparison(x, y))

if __name__ == '__main__':
    unittest.main()
