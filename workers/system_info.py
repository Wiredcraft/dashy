#!/usr/bin/env python3
import sys
import logging
import copy
import psutil
import requests
import json
import datetime
import pytz

DEFAULT_URL = 'http://127.0.0.1:8081/sys-info'
INTERVAL = 1
LOG_LEVEL = logging.DEBUG


class Stats:
    def __init__(self):
        cur_net = psutil.net_io_counters()
        cur_disk = psutil.disk_io_counters(perdisk=False)

        self.cpu = psutil.cpu_percent(INTERVAL)
        self.value = psutil.virtual_memory().percent
        self.netsent = cur_net.bytes_sent
        self.netrecv = cur_net.bytes_recv
        self.diskwrite = cur_disk.write_bytes
        self.diskread = cur_disk.read_bytes

    def __str__(self):
        return 'cpu: {cpu}, value: {value}, netsent: {netsent}, netrecv: {netrecv}, ' \
               'diskwrite: {diskwrite}, diskread: {diskread}'.format(**self.__dict__)

    def to_json(self):
        return json.dumps({'time': datetime.datetime.now(pytz.timezone('Europe/Amsterdam')).isoformat(), 'data': self.__dict__})

    def diff(self, previous):
        self.netsent -= previous.netsent
        self.netrecv -= previous.netrecv
        self.diskwrite -= previous.diskwrite
        self.diskread -= previous.diskread
        return self

    def get_diff(self, previous):
        return copy.deepcopy(self).diff(previous)


class Server:
    def __init__(self, url):
        self.log = logging.getLogger(__name__)
        self.url = url
        self.log.info('url: ' + url)

    def post(self, stats):
        try:
            r = requests.post(self.url, data=stats.to_json())
            self.log.debug(r.text)
            return r.text
        except requests.RequestException as e:
            self.log.error(e, exc_info=True)


def main():
    log = logging.getLogger(__name__)
    log.setLevel(LOG_LEVEL)
    ch = logging.StreamHandler()
    ch.setLevel(log.level)
    ch.setFormatter(logging.Formatter('%(levelname)s %(message)s'))
    log.addHandler(ch)

    try:
        url = sys.argv[1]
    except IndexError:
        url = DEFAULT_URL

    server = Server(url)

    prev = Stats()

    while True:
        try:
            now = Stats()
            stats = now.get_diff(prev)
            prev = now

            log.debug(str(stats))
            log.debug(stats.to_json())

            server.post(stats)
        except KeyboardInterrupt:
            break

if __name__ == '__main__':
    main()
