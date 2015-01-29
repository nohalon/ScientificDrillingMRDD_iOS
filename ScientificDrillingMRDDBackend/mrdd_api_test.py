import random
import unittest
import mrdd_api

class TestAPI(unittest.TestCase):

    def setUp(self):
        pass

    def test_get_all(self):
        all = mrdd_api.get_all()
        self.assertEqual(all, "UNIMPLEMENTED")

if __name__ == '__main__':
    unittest.main()