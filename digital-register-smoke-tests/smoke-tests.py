import requests
from config import CONFIG_DICT

def deployment_smoketesting():
    # login stuff
    response = requests.post(
        '{}/login?next=titles'.format(CONFIG_DICT['REGISTER_TITLE_URL']),
        data={'username': 'username1', 'password': 'password1'},
        follow_redirects=False
    )
    import pdb; pdb.set_trace()


if __name__ == '__main__':
    #pytest.main()
    deployment_smoketesting()
