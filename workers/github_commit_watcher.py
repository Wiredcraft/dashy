import os
import json
import time
import logging

from getpass import getpass
from datetime import datetime, timedelta
from collections import namedtuple

import requests
import github


'''
Running instructions:
 -  Install requirements: pip install requests PyGithub
 -  Run: python github_commit_watcher.py
 -  Type in username and password of a github user when asked.
'''

#  Settings:
DATABASE_URL = 'http://127.0.0.1:5984/commits'
DASHY_URL = 'http://127.0.0.1:4000/commits'
TIMESTAMP_FORMAT = '%Y-%m-%dT%H:%M:%SZ'
DEFAULT_FETCH_DAYS = 2  # Used when there are no previous entries in the db
INTERVAL = 120 # How many seconds to sleep between next check
ORGANIZATIONS = ['devo-ps', 'wiredcraft']

                       
'''
Sent entries should look like:
{
   "time": "2013-05-14T21:34:49Z",
   "data": {
      "user": "Jamesford",
      "title": "Super Commit!",
      "image": "https://secure.gravatar.com/avatar/cfdfd092fdad6be1a2d80bdbea98d9ead=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png"
   }
}
'''
Dataentry = namedtuple('Dataentry', ['time', 'name', 'msg', 'avatar_url'])

def format_tuple(datatuple):
    return {'time':datatuple.time,
            'data':{'user': datatuple.name,
                    'title': datatuple.msg,
                    'image': datatuple.avatar_url }}


def fetch_last_timestamp():
    '''
    Fetch timestamp of last dataentry from the db.
    Query spec: http://docs.couchdb.org/en/latest/api/database.html#get-db
    '''
    params = {'limit': '1', 'include_docs': 'true'}
    r = requests.get(DATABASE_URL + '/_all_docs', params=params)
    if not r.ok:
        logging.warning('Could not connect to couchdb using url %s, got response code: %s.'%(DATABASE_URL, r.status_code))
        raise RuntimeError('Could not fetch data from to couchdb.')
    res = json.loads(r.text)
    
    if len(res['rows']) == 0:
        logging.info('No previous entries found.')
        return None
    timestamp = res['rows'][0]['doc']['time']
    logging.debug('Successfully fetched last timestamp: ' + timestamp)
    date_obj = datetime.strptime(timestamp, TIMESTAMP_FORMAT)
    return date_obj

def fetch_commits_since(timestamp, gh):
    commit_list = []
    for org in ORGANIZATIONS:
        event_counter = 0
        org_obj = gh.get_organization(org)
        for event in gh.get_user().get_organization_events(org_obj):
            if event.created_at <= timestamp:
                logging.debug('Timestamp passed after %s events.'%(event_counter,))
                break 
            
            if event.type == 'PushEvent':
                avatar_url = event.actor.avatar_url
                event_time = event.created_at
                for commit in event.payload.get('commits'):
                    msg = commit.get('message')
                    author = commit.get('author').get('name')
                    commit_list.append(Dataentry(time= event_time.strftime(TIMESTAMP_FORMAT),
                                                 name= author,
                                                 msg= msg,
                                                 avatar_url= avatar_url))
            event_counter += 1
    return commit_list


def get_username_and_password():
    if os.environ.get('GH_USERNAME') and os.environ.get('GH_PASSWORD'):
        username = os.environ['GH_USERNAME']
        password = os.environ['GH_PASSWORD'] 
    else:
        username = raw_input("Github username:")
        password = getpass("Github password:")

    return username, password

def main():
    logging.basicConfig(level=logging.INFO)
    
    username, password = get_username_and_password()
    
    gh = github.Github(username, password)

    last_timestamp = fetch_last_timestamp()
    if not last_timestamp:
        last_timestamp = datetime.now() - timedelta(days=DEFAULT_FETCH_DAYS)
    
    while True:
        try:
            commits = fetch_commits_since(last_timestamp, gh)

            for commit in commits:
                headers = {'content-type': 'application/json'}
                now = datetime.now()
                payload = format_tuple(commit)
                r = requests.post(DASHY_URL, data=json.dumps(payload), headers=headers)
            logging.info('Added %s commits.'%(len(commits)))
            if commits:
                last_timestamp = datetime.strptime(commits[0].time, TIMESTAMP_FORMAT)
        except:
            logging.exception("Exception when fetching commits.")
            # continuing
            
        time.sleep(INTERVAL)
    
if __name__ == '__main__':
    main()
