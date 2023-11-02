# @fileoverview gtAddRepo newRepoName [-h -p ]
# creates a new git repo locally and remotely on github.
#

# figure out whether running bash or zsh by how it handles array indexing
zshFlag=0;a=(1);if [[ ${a[0]} != "1" ]]; then zshFlag=1; fi; unset a

#figure out where the script directory is, depending on zsh or bash
scriptDir=""
if [[ "${zshFlag}" == "1" ]]; then
  scriptDir=${0:a:h}
else
  scriptDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fi

source "${scriptDir}/gtUtil.sh"   # abstracts github API

scriptName=${0##*/};scriptName=${scriptName##*\\}  #last part of full pathname
newRepoName=""
publicFlag=""             # set to 0 or 1 based on -public | -private | input
visibilityStr=""          # human readable form of publicFlag
errorMsgList=()           # list of error messages to display


printHelp() {
  local shellName="bash"
  if [[ "${zshFlag}" -eq 1 ]]; then shellName="zsh"; fi
  printf "(You are using %s to run v%s of gt)\n" \
         "${shellName}" "${GT_VERSION}"
  printf "Usage: add newRepoName [-public | -private | -help]\n"
}


# display the global array errorMsgList
printErrorMsgList() {
  local errorCount="${#errorMsgList[@]}"
  if [[ ${errorCount} -lt 1 ]]; then return; fi

  for ((i=0 ; i < errorCount; ++i)); do
    local errorMsg="${errorMsgList[@]:$i:1}"
    printf "Error: %s\n" "${errorMsg}"
  done
}


parseParamList() {
  local helpFlag=0
  local paramList=( "${@}" )

  for param in "${paramList[@]}"; do
    # printf "param [%s]\n" "${param}"
    case "${param}" in
      "-?" | "-h" | "-help" | "--help")
        helpFlag=1
        ;;

      "-public" | "--public")
        publicFlag=1
        ;;

      "-private" | "--private")
        publicFlag=0
        ;;

      *)
        if [[ "${#newRepoName}" -lt 1 ]]; then
          # make sure the first char is not a "-" which is an invalid parameter
          firstChar="${param:0:1}"
          if [[ "${firstChar}" != '-' ]]; then
            newRepoName="${param}"
          else
            errorMsgList+=(""${param}" is an invalid parameter.")
          fi
        else
          errorMsgList+=(""${param}" is an invalid parameter.")
        fi
        ;;
    esac
  done

  if [[ "${#errorMsgList}" -gt 0 || helpFlag -eq 1 ]]; then
    printErrorMsgList
    printHelp
    exit
  fi;

}


# if the name is missing, ask for it
# if the name exists locally, issue an error and quit
validateRepoNameAndUserid() {
  gtGetGitUseridAndCredentials
  if [[ "${gtUserid}" == "" ]]; then
    printf "Error: unable to get your git userid and credentials\n"
    printf "Please check that you have a $HOME/.git-credentials file\n"
    exit
  fi

  while [[ ${#newRepoName} -lt 1 ]]; do
    printf "Enter a new repository name: "
    read newRepoName
  done

  if [[ -f "${newRepoName}" ]]; then
    printf "%s is an existing file. Nothing created.\n" ${newRepoName}
    exit
  fi

  if [[ -d "${newRepoName}" ]]; then
    printf "%s is an existing directory. Nothing created.\n" ${newRepoName}
    exit
  fi
}

validatePublicFlag() {
  while [[ "${publicFlag}" == "" ]]; do
    printf "Do you want the repo to be private [Y/n]? "
    read answer

    if [[ "${answer}" == "" || "${answer}" == "Y" || "${answer}" == "y" ]]; then
      publicFlag=0
    elif [[ "${answer}" == "N" || "${answer}" == "n" ]]; then
      publicFlag=1
    else
      publicFlag=""
      printf "Invalid answer (%s). Please answer y or n.\n" "${answer}"
    fi
  done

  visibilityStr="private"    # human readable form of publicFlag
  if [[ "${publicFlag}" -eq 1 ]]; then visibilityStr="public"; fi

}


# asks user if the add settings are correct
confirmWithUser() {
  local answer=""
  local la=""

  checkRepoForExistence

  while [[ "${answer}" == "" ]]; do
    printf "Verify the command for %s:   gtAddRepo %s as %s\n" \
           "${gtUserid}" "${newRepoName}" "${visibilityStr}"

    printf "Is this correct (y/n)? "
    read answer

    # lowercase in zsh v bash
    if [[ "${zshFlag}" -eq 1 ]]; then la="${answer:l}";else la="${answer,,}";fi

    if [[ "${la}" != "y" && "${answer}" != "n" ]]; then
      printf "Invalid answer (%s). Please answer y or n.\n" "${answer}"
      answer=""
      la=""
    fi
  done

  if [[ "${la}" != "y"  ]]; then
    printf "No action taken.\n"
    exit
  fi
}


checkRepoForExistence() {
  # printf "Would check repo for existence of [%s]\n" "${newRepoName}"
  # if already exists, report exists and exit
  local json=$(gtGetRepo "${newRepoName}")

  # if there is a gtErrorMessage, show it
  if [[ ${json/*gtErrorMessage*/true} == "true" ]]; then
    local errorMsg="${json/*gtErrorMessage\": \"/}"
    errorMsg="${errorMsg/\"*/}"
    printf "Error: %s\n" "${errorMsg}"
    exit
  fi

  # if there is an id then the repo exists; issue an error and exit
  if [[ ${json/*id*/true} == "true" ]]; then
    local createDate=$(gtGetJsonDateField "${json}" "created_at")
    createDate=$(date -d "${createDate}" +%d" "%b" "%Y)

    printf "Error: %s already exists on the repo " "${newRepoName}"
    printf "(it was created on %s).\n" "${createDate}"
    printf "Nothing created.\n"
    exit
  fi
}

createRepoLocally() {
  #create a local directory for the new repo
  mkdir ${newRepoName}
  cd ${newRepoName}
  git init -q

  #create a README.md and commit it locally
  echo \<h2\>${newRepoName}\</h2\> > ./README.md
  git add README.md
  git commit -q -m "initial commit"

  # now push it up to github
  git remote add origin git@github.com:${gtUserid}/${newRepoName}.git

  # git push -q -u --set-upstream origin main
  git push -q -u origin main
}


# calls gtAddRepo and parses the status of the results
runAddCmd() {
  local json=$(gtAddRepo "${newRepoName}" "${publicFlag}")

  # if there is a message in the json, then there is an error
  local error="${json/*\"message\"*/true}"
  if [[ ${error} == "true" ]]; then
    printf "Error: creating the repo %s " "${newRepoName}"
    local errorMsg="${json/*message\": \"/}"
    errorMsg="${errorMsg/\"*/}"
    printf "%s\n" "${errorMsg}"
    exit
  fi

  createRepoLocally  # creates the new repo as a directory on local computer
}


# shows the final message that the repo was created on the current date
showResults() {
  local date=$(date '+%A %d %b %Y at %H:%M %p')

  printf "%s (%s repo) created on %s\n" \
         "${newRepoName}" "${visibilityStr}" "${date}"
}


main() {
  parseParamList "${@}"
  validateRepoNameAndUserid
  validatePublicFlag

  # for debugging
  # printf "newRepoName:[%s] publicFlag:%d userid:[%s] credential:[%s]\n" \
  # "${newRepoName}" "${publicFlag}" "${userid}" "${credential}"

  confirmWithUser
  runAddCmd
  showResults
}

main $@
