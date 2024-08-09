#---------------------------
#DribbleData Project
#Created by Matvey Guralskiy
#---------------------------
import unittest

# Import the app objects for each microservice
from main import app as main_app
from players import app as players_app
from training import app as training_app
from users import app as users_app

# Test class for Main Service
class TestMainService(unittest.TestCase):

    def setUp(self):
        self.app = main_app.test_client()

    def test_index(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>DribbleData</h1>', response.data)

# Test class for Players Service
class TestPlayersService(unittest.TestCase):

    def setUp(self):
        self.app = players_app.test_client()

    def test_index(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>Top NBA Players</h1>', response.data)

# Test class for Videos Service
class TestVideosService(unittest.TestCase):

    def setUp(self):
        self.app = training_app.test_client()

    def test_index(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>Basketball Training Videos</h1>', response.data)

# Test class for Users Service
class TestUsersService(unittest.TestCase):

    def setUp(self):
        self.app = users_app.test_client()

    def test_register(self):
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>Register</h1>', response.data)

    def test_login(self):
        response = self.app.get('/login')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'<h1>Login</h1>', response.data)

# Combine all tests into a suite
def suite():
    loader = unittest.TestLoader()
    test_suite = unittest.TestSuite()
    
    test_suite.addTests(loader.loadTestsFromTestCase(TestMainService))
    test_suite.addTests(loader.loadTestsFromTestCase(TestPlayersService))
    test_suite.addTests(loader.loadTestsFromTestCase(TestVideosService))
    test_suite.addTests(loader.loadTestsFromTestCase(TestUsersService))
    
    return test_suite

if __name__ == '__main__':
    runner = unittest.TextTestRunner()
    runner.run(suite())
