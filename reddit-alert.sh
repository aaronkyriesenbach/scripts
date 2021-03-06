#!/usr/bin/python3

import configparser
import json
import os
import re

import requests


def wait_for_internet():
    while True:
        try:
            requests.get("https://google.com", timeout=1)
            return
        except:
            pass


def push_notify(title, message):
    payload = {"token": os.getenv("PUSHOVER_API_TOKEN"),
               "user": os.getenv("PUSHOVER_USER_KEY"),
               "title": title,
               "message": message}
    requests.post(f"https://api.pushover.net/1/messages.json", params=payload)


def get_list_from_config(config, key):
    return json.loads(config[key]) if key in config else None


def get_recent_index(posts, recents, sub):
    if sub in recents:
        print(f"Most recent post from {sub} is {recents[sub]['recent']}")
        for i in range(len(posts)):
            if posts[i]["id"] == recents[sub]["recent"]:
                return i
    else:
        recents[sub] = {}
        return len(posts)


if __name__ == "__main__":
    wait_for_internet()

    config = configparser.ConfigParser()
    recents = configparser.ConfigParser()
    config.read(f"{os.getenv('HOME')}/.config/reddit-alert.ini")
    recents.read(f"{os.getenv('HOME')}/.cache/reddit-alert-recent.ini")
    for sub in (sub for sub in config if sub != "DEFAULT"):
        search = {"exact": get_list_from_config(config[sub], "exact"),
                  "fuzzy": get_list_from_config(config[sub], "fuzzy"),
                  "regex": get_list_from_config(config[sub], "regex")}
        resp = requests.get(f"https://www.reddit.com/r/{sub}/new.json", headers={"user-agent": "reddit-alert"}).json()
        posts = [post['data'] for post in resp['data']['children']]

        posts = posts[0:get_recent_index(posts, recents, sub)]
        if len(posts) > 0:
            recents[sub]["recent"] = posts[0]["id"]
            with open(f"{os.getenv('HOME')}/.cache/reddit-alert-recent.ini", "w") as recents_file:
                recents.write(recents_file)

        for post in posts:
            for term in (search["exact"] or []):
                if term in post["selftext"] or term in post["title"]:
                    message = f"New post on /r/{post['subreddit']} matching exact term {term}"
                    print(message)
                    push_notify(message, post["url"])

            for term in (search["fuzzy"] or []):
                if term.lower() in post["selftext"].lower() or term.lower() in post["title"].lower():
                    message = f"New post on /r/{post['subreddit']} matching fuzzy term {term}"
                    print(message)
                    push_notify(f"New post on /r/{post['subreddit']} matching fuzzy term {term}", post["url"])

            for term in (search["regex"] or []):
                if re.search(term, post["selftext"]) or re.search(term, post["title"]):
                    message = f"New post on /r/{post['subreddit']} matching regex {term}"
                    print(message)
                    push_notify(message, post["url"])
