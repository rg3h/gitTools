# @fileoverview gtUtil.sh utilities for github access via github API
#
GT_VERSION="1.2.1"

gtUserid=""
gtCredential=""

# gets userid and credentials from .git-credentials or sets to ""
# if you pass a "1" then it will also print json on an error
gtGetGitUseridAndCredentials() {
  local printJson="${1}"

  # if we got the values previously, then return
  if [[ "${gtUserid}" != "" && "${gtCredential}" != "" ]]; then
    return;
  fi

  local gitCredentialsFile="${HOME}/.git-credentials"

  if [[ -f "${gitCredentialsFile}" ]]; then
    local firstLine
    read -r firstLine < "${gitCredentialsFile}" # reads file into firstLine
    local subLine=${firstLine/*\/\//}
    gtUserid=${subLine/:*/}
    gtCredential=${subLine/*:/}
    gtCredential=${gtCredential/@*/}
  fi

  if [[ "${gtUserid}" == "" || "${gtCredential}" == "" ]]; then

    if [[ "${printJson}" -eq 1 ]]; then
      printf "{ \"gtErrorMessage\": \"%s\"}" "unable to get userid/credential"
    fi

    gtUserid=""
    gtCredential=""
  fi
}


# usage: local createDate=$(getJsonDateField "${json}" "created_at")
gtGetJsonDateField() {
  local json="${1}"
  local token="${2}"
  # first grep finds the lines with the token
  printf "%s \n" "${json}" | grep -o "\""${token}"\": \"[^\"]*" | \
    grep -o "[^\"]*$"
}

# returns a list of values for "name":"value" JSON quoted pairs
# usage: local repoNameList=( $(getJsonQuotedField "${json}" "full_name") )
gtGetJsonQuotedField() {
  local json="${1}"
  local token="${2}"
  # first grep finds the lines with the token
  # the second grep strips the double quotes
  # local grepString="grep -o "\""${token}"\": \"[^\"]*" | grep -o "[^\"]*$""
  printf "%s \n" "${json}" | grep -o "\""${token}"\": \"[^\"]*" | \
    grep -o "[^\"]*$"
}


# returns a list of values for "name":value JSON unquoted pairs
# usage: privateList=( $(getJsonUnQuotedField "private") )
gtGetJsonUnquotedField() {
  local json="${1}"
  local token="${2}"
  # first grep finds the lines with the token
  # the second grep strips everything after the :
  printf "%s \n" "${json}" | grep -o "\""${token}"\": [^,]*" | \
    grep -o "[^:]*$"
}


# usage: local json=$(gtGetRepo "${repoName}")
gtGetRepo() {
  local repoName="${1}"

  # make sure we have the userid and credentials
  local printJsonFlag=1   # makes gtGetUserAndCredential print json on error
  gtGetGitUseridAndCredentials "${printJsonFlag}"

  if [[ "${gtUserid}" == "" ]]; then
    return
  fi

  curl --silent \
       -L \
       -H "Accept: application/vnd.github+json" \
       -H "Authorization: Bearer "${gtCredential}"" \
       -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/repos/"${gtUserid}"/"${repoName}""
}


#get a list of all repos
# usage gtGetRepoList parameters (e.g. ?sort="full_name")
gtGetRepoList() {
  local paramStr="${1}"
  local errorMsg=""

  # make sure we have the userid and credentials
  local printJsonFlag=1   # makes gtGetUserAndCredential print json on error
  gtGetGitUseridAndCredentials "${printJsonFlag}"

  if [[ "${gtUserid}" == "" ]]; then
    return
  fi

  curl --silent \
       -L \
       -H "Accept: application/vnd.github+json" \
       -H "Authorization: Bearer "${gtCredential}"" \
       -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/user/repos""${paramStr}"
}


# usage: local json=$(gtAddRepo "${repoName}" "${publicFlag}")
gtAddRepo() {
  local newRepoName="${1}"
  local publicFlag="${2}"

  if [[ "${newRepoName}" == "" ]]; then
    printf "{ \"gtErrorMessage\": \"%s\"}" "missing repository name"
    return
  fi

  # make sure we have the userid and credentials
  local printJsonFlag=1   # makes gtGetUserAndCredential print json on error
  gtGetGitUseridAndCredentials "${printJsonFlag}"

  if [[ "${gtUserid}" == "" ]]; then
    return
  fi

  if [[ "${publicFlag}" == "" ]]; then
    publicFlag=0
  fi

  local privacyStr="true"
  if [[ "${publicFlag}" -eq 1 ]]; then privacyStr="false"; fi

  curl --silent \
       -L \
       -X POST \
       -H "Accept: application/vnd.github+json" \
       -H "Authorization: Bearer "${gtCredential}"" \
       -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/user/repos" \
       -d '{"name":"'${newRepoName}'","private":'${privacyStr}'}'
}


# usage: local json=$(gtDelRepo "${repoName}")
# alternate usage: local json=$(gtDelRepo "${repoName}")
#   if you don't pass in the userid and credentials it will do a file access
gtDelRepo() {
  local repoName=$1
  local errorMsg=""

  if [[ "${repoName}" == "" ]]; then
    printf "{ \"gtErrorMessage\": \"%s\"}" "missing repository name"
    return
  fi

  # make sure we have the userid and credentials
  local printJsonFlag=1   # makes gtGetUserAndCredential print json on error
  gtGetGitUseridAndCredentials "${printJsonFlag}"

  if [[ "${gtUserid}" == "" ]]; then
    return
  fi

  curl --silent \
       -L \
       -X DELETE \
       -H "Accept: application/vnd.github+json" \
       -H "Authorization: Bearer "${gtCredential}"" \
       -H "X-GitHub-Api-Version: 2022-11-28" \
       "https://api.github.com/repos/"${gtUserid}"/"${repoName}""
}
