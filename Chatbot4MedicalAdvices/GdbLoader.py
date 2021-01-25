"""
File: GdbLoader.py

Authors:
    Liu Jianping
    2020/9/17 - add parallelism  args
    2020/1/06 - add ak/sk args
    2019/8/13 - initial release
"""

from __future__ import print_function
import argparse
import requests
import json
from requests.auth import HTTPBasicAuth

class GdbLoader:
    def __init__(self, url, username, password):
        self.url = url
        self.auth = HTTPBasicAuth(username, password)

    def get_task_list(self):
        resp = requests.get(self.url, auth=self.auth)
        return resp.json()[u'payload'][u'loadIds']

    def get_task_detail(self, loaderId):
        resp = requests.get(self.url + '/' + loaderId, auth=self.auth)
        if resp.status_code != 200:
           raise Exception(resp.text)

        return resp.json()[u'payload']

    def delete_task(self, loaderId):
        resp = requests.delete(self.url + '/' + loaderId, auth=self.auth)
        if resp.status_code != 200:
           raise Exception(resp.text)

    def add_task(self, source, arn, ak, sk, failOnError, parallelism):
        headers = {'Content-Type': 'application/json'}
        task_data = {
            'source': source,
            'failOnError': failOnError,
            'parallelism': parallelism
        }

        if ak and sk:
            task_data['accessKey'] = ak
            task_data['secretKey'] = sk
        elif arn:
            task_data['ramRoleArn'] = arn
        else:
            raise Exception("add task need authorization arn or ak/sk")

        resp = requests.post(url=self.url, auth=self.auth, headers=headers, data=json.dumps(task_data))
        if resp.status_code != 200:
            raise Exception(resp.text)

        return resp.json()[u'payload']

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', dest="host", type=str, required=True)
    parser.add_argument('--port', dest="port", type=int, default=8182)
    parser.add_argument('--username', dest="username", type=str, required=True)
    parser.add_argument('--password', dest="password", type=str, required=True)
    parser.add_argument('--todo', dest="todo", type=str, required=True)
    parser.add_argument('--loaderId', dest="loaderId", type=str, required=False)
    parser.add_argument('--source', dest="source", type=str, default="")
    parser.add_argument('--arn', dest="arn", type=str, default="")
    parser.add_argument('--ak', dest="ak", type=str, default="")
    parser.add_argument('--sk', dest="sk", type=str, default="")
    parser.add_argument('--failOnError', dest="failOnError", type=bool, default=False)
    parser.add_argument('--parallelism', dest="parallelism", type=str, default="HIGH")

    args = parser.parse_args()
    url = 'http://' + args.host + ':' + str(args.port) + '/loader'
    gdb_loader = GdbLoader(url, args.username, args.password)
    parallelism = set(["HIGH", "MEDIUM", "LOW"])
    if not args.parallelism in parallelism:
        raise Exception("unknown parallelism option: " + args.parallelism + ". set in " + ', '.join(str(e) for e in parallelism))

    result = {"status": "OK"}
    if args.todo == 'list_task':
        result = gdb_loader.get_task_list()
    elif args.todo == 'get_task':
        if not args.loaderId:
            raise Exception("get task should set one task Id")
        result = gdb_loader.get_task_detail(args.loaderId)
    elif args.todo == 'delete_task':
        if not args.loaderId:
            raise Exception("delete task should set one task Id")
        gdb_loader.delete_task(args.loaderId)
    elif args.todo == 'add_task':
        if not args.source:
            raise Exception("add task should provide one oss location")
        result = gdb_loader.add_task(args.source, args.arn, args.ak, args.sk, args.failOnError, args.parallelism)
    else:
        raise Exception("unknown option to do: " + args.todo)

    print(json.dumps(result, indent=2))

if __name__ == '__main__':
    main()
