import random
import unittest
import sdi_mock
import json, urllib2

SDI_server = "http://localhost:5001/"

class TestSDIMock(unittest.TestCase):

    def setUp(self):
        self.app = sdi_mock.app.test_client()

    def tearDown(self):
        pass

    def test_mock_fetch(self):

        for i in range(200):
            resp = self.app.get('fetch')
            print("resp.data" + str(resp.data))
            data = json.loads(resp.data)

            self.assertEqual(len(data), 2)

            temp = data[0]
            print("temp: " + str(temp))
            depth = data[0]
            print("depth: " + str(depth))

            self.assertIsNotNone(temp)
            self.assertIsNotNone(depth)

            self.assertEqual(len(temp), i + 2)
            self.assertEqual(len(depth), i + 2)

if __name__ == '__main__':
    unittest.main()