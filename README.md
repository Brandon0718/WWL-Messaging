# Login and Profile App

Hey thanks for taking on our programming challenge. Out of respect for your time, please work for 1-2 hours, but don't stress too hard. This is not a timed challenge, feel free to spend as little or as much time as you desire. I don’t expect you to finish this challenge (unless you really want to); it’s more to get a sense of your approach to programming. The people who get hired tend to show their *best* and *most elegant* work rather than their quickest or most feature-complete work.

## Objective

Write an app allowing the user to log in and view his profile.

## Instructions

* Fork and clone this repo. It contains a default project.
* Implement the user story below
* Send a pull request to me ***along with your name*** when you're done or when it's been 2 hours. This step is super important; if you don't send a pull request, you definitely won't be hired.

## User Story

Please see [this google doc link](https://docs.google.com/document/d/1_OpId3aPamE7mR_Hx79BLEeYjkQEp1zKI4BkXQQNh6w) for the user story.

## API Information

API endpoint: http://dev-api.wwl.tv/api/v1

1. To get a confirmation code for a phone number:

http://dev-api.wwl.tv/docs/index.html#api-Authentication-Confirmation_Sms

2. To check confirmation code and get JWT session token:

http://dev-api.wwl.tv/docs/index.html#api-Authentication-Login

You will get `token` at this endpoint. You will always send this token as header parameter: `Authorization`. And also, you need to add `Bearer ` (with a trailing space) string at front of token. 

`Authorization: "Bearer {token}"`

3. To get profile fields to show them in form:

http://dev-api.wwl.tv/docs/index.html#api-UserProfile

## Bonus Story (if you really want to WOW me)

Add the [GoCoder Challenge](https://docs.google.com/document/d/1XyeZQz9p4LkTnryZL7nko02cF8lZKeBPTU0tb0L2_gI) to it.


