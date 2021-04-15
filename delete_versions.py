import requests
import sys

deleteQuery = """
mutation ($versionId: String!) {
    deletePackageVersion(input: {packageVersionId: $versionId}) {
          success
    }
}
"""

BASE_URL = "https://api.github.com/graphql"

def delete_single_version(versionId, token):
    headers = {
        "Authorization": "token " + token,
        "Accept": "application/vnd.github.package-deletes-preview+json"
    }
    input = {
        "versionId": versionId
    }
    return requests.post(
            BASE_URL, 
            json = {'query': deleteQuery, 'variables': input},
            headers = headers
    )

def delete_versions(idList, token):
    for id in idList:
        response = delete_single_version(id, token)
        if response.status_code == 200 and response.json()["data"]["deletePackageVersion"]["success"]:
            print("Deleted: " + id)
        else:
            print("Failure with code: " + response.status_code)
            return False
    return True
