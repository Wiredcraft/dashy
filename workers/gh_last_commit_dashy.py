'''
get_repo
 - 
'''
'''
Running instructions:
 -  Install requirements: pip install requests PyGithub
 -  Run: python gh_last_commit.py myuser/myrepo
 -  Type in username and password of a github user when asked
    (or set them as environmen variables GH_USERNAME and GH_PASSWORD).
'''
#  Settings:

from collections import namedtuple
from getpass import getpass
import json
import logging
import os
import sys
import time

import requests
import github


TIMESTAMP_FORMAT = '%Y-%m-%dT%H:%M:%SZ'
INTERVAL = 60  # How many seconds to sleep between checks
DASHY_URL = 'http://107.170.255.152:8081/git-datasource'
HEADERS = {'content-type': 'application/json'}


def main():
    if (len(sys.argv) != 2):
        print 'ERROR: Wrong number of arguments!'
        print 'Usage: python gh_last_commit.py myuser/myrepo'
        exit(1)

    _config()

    username, password = _get_username_and_password()

    gh = github.Github(username, password)

    repo_id = sys.argv[1]

    try:
        repo = gh.get_repo(repo_id)
        if not repo:
            raise RuntimeError('Received empty repository object')
    except Exception, e:
        logging.exception(e)
        logging.error('Could not fetch repository %s for user %s' % (repo_id, username))
        exit(1)

    logging.info('Fetched repo successfully: %s' % repo_id)

    previous_commit = None
    while True:
        try:
            logging.info('Starting to fetch last commit.')
            commit = _fetch_last_commit(repo)
            if commit and (not previous_commit or commit.sha != previous_commit.sha):
                payload = _format_commit(commit)
                _send_entry(payload)
                logging.info('New commit successfully sent: %s' % payload)
                previous_commit = commit
            else:
                logging.info('No new commits')
        except Exception, e:
            logging.exception(e)
            logging.warning('Waiting extra one minute because of an exception.')
            time.sleep(60)

        time.sleep(INTERVAL)

'''
Sent entries should look like:
{
   "time": "2013-05-14T21:34:49Z",
   "data": {
      "user": "Jamesford",
      "title": "Super Commit!",
   }
}
'''

def _get_username_and_password():
    if os.environ.get('GH_USERNAME') and os.environ.get('GH_PASSWORD'):
        username = os.environ['GH_USERNAME']
        password = os.environ['GH_PASSWORD']
    else:
        username = raw_input("Github username:")
        password = getpass("Github password:")

    return username, password


def _fetch_last_commit(repo):
    commits = repo.get_commits()
    last = commits[0]
    return last


def _format_commit(commit):
    commit = commit.commit

    msg = commit.message
    committer_name = commit.committer.name
    event_time = commit.committer.date

    return {
               'time': event_time.strftime(TIMESTAMP_FORMAT),
               'data': {
                  'user': committer_name,
                  'title': msg
                }
            }


def _send_entry(payload):
    logging.info('Sending: %s' % payload)
    r = requests.post(DASHY_URL, data=json.dumps(payload), headers=HEADERS)
    if not r.ok:
        logging.warning("Failed to add data entry: %s" % payload)
    else:
        logging.info('Http request successfully set.')


def _config():
    if os.environ.get('DEBUG'):
        logging.basicConfig(level=logging.DEBUG)
    else:
        logging.basicConfig(level=logging.INFO)


if __name__ == '__main__':
    main()
