import requests
import sys

idQuery = """ 
query($owner: String!, $repoName: String!, $noOfPackages: Int!, $noOfVersions: Int!){
    repository(owner: $owner, name: $repoName) {
    packages(first: $noOfPackages) {
      edges {
        node {
          name
          versions(last: $noOfVersions) {
            edges {
              node {
                id
                version
              }
            }
          }
        }
      }
    }
  }
}
"""

BASE_URL = "https://api.github.com/graphql"


def get_version_ids(token, repoName, noOfPackages, noOfVersions):
    repoInfo = repoName.split('/')
    inputVariables = {
        "owner": repoInfo[0],
        "repoName": repoInfo[1],
        "noOfPackages": int(noOfPackages),
        "noOfVersions": int(noOfVersions)
    }

    try:
        headers = {"Authorization": "token " + token}
        versionRequest = requests.post(
            BASE_URL, 
            json = {'query': idQuery, 'variables': inputVariables},
            headers = headers)

        if versionRequest.status_code == 200:
            return parse_response(versionRequest.json())
        else:
            print(versionRequest.status_code)
            raise Exception("Query failed" + versionRequest.status_code)
    except (requests.exceptions.RequestException, requests.exceptions.HTTPError) as err:
        print(err.response.text)



def parse_response(response):
    nodes = response["data"]["repository"]["packages"]["edges"]
    idList = []
    for node in nodes:
        for version in node["node"]["versions"]["edges"]:
            idList.append(version["node"]["id"])
    return idList
