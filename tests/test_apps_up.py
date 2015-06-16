import os
import pytest
import requests


REGISTER_TITLE_URL = os.environ['DIGITAL_REGISTER_URL']
USERNAME = os.environ['SMOKE_USERNAME']
PASSWORD = os.environ['SMOKE_PASSWORD']
TITLE_NUMBER = os.environ['SMOKE_TITLE_NUMBER']
PARTIAL_ADDRESS = os.environ['SMOKE_PARTIAL_ADDRESS']
POSTCODE = os.environ['SMOKE_POSTCODE']


def test_frontend_up():
    # login stuff
    response = requests.post('{}/login?next=titles'.format(REGISTER_TITLE_URL),
                             data={'username': USERNAME, 'password': PASSWORD},
                             follow_redirects=False)
    import pdb; pdb.set_trace()
