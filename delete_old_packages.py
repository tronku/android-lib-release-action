import sys
from get_ids import get_version_ids
from delete_versions import delete_versions
from requests import exceptions
from subprocess import call

token = sys.argv[1]
repoName = sys.argv[2]
noOfPackages = sys.argv[3]
noOfVersions = sys.argv[4]
packageFilePath = sys.argv[5]
defaultBranch = sys.argv[6]

def delete_packages():
    idList = get_version_ids(token, repoName, noOfPackages, noOfVersions)
    print(idList)
    if (len(idList) == 0):
        print("No versions found.")
    else:
        try:
            isSuccess = delete_versions(idList, token)
            if isSuccess:
                print("Deleted succesfully!")
                call("chmod +x /delete_package_bump.sh", shell=True)
                call("/delete_package_bump.sh {0} {1} {2} {3}".format(token, packageFilePath, defaultBranch, noOfVersions), shell=True)
            else:
                print("Deletion failed")
        except (exceptions.RequestException, exceptions.HTTPError) as err:
            print("Deletion failed: " + err.response.text)

if __name__ == '__main__':
    delete_packages()