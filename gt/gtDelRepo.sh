# @fileoverview gtDelRepo repoName deletes repoName (confirms and does not
# touch the local version).
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

source ${scriptDir}/gtUtil.sh   # abstracts github API

scriptName=${0##*/};scriptName=${scriptName##*\\}  #last part of full pathname
repoName=""
errorMsgList=()           # list of error messages to display

printHelp() {
  local shellName="bash"
  if [[ "${zshFlag}" -eq 1 ]]; then shellName="zsh"; fi
  printf "(You are using %s to run v%s of gt)\n" \
         "${shellName}" "${GT_VERSION}"
  printf "Usage: [del | rm] [repoName | -help]\n"
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

      *)
        if [[ "${#repoName}" -lt 1 ]]; then
          # make sure the first char is not a "-" which is an invalid parameter
          firstChar="${param:0:1}"
          if [[ "${firstChar}" != '-' ]]; then
            repoName="${param}"
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


validateRepoNameAndUserid() {
  gtGetGitUseridAndCredentials
  if [[ "${gtUserid}" == "" ]]; then
    printf "Error: unable to get your git userid and credentials\n"
    printf "Please check that you have a $HOME/.git-credentials file\n"
    exit
  fi

  while [[ ${#repoName} -lt 1 ]]; do
    printf "Enter the repository name to delete: "
    read repoName
  done
}


# asks the user if the delete settings are correct
confirmWithUser() {
  local answer=""
  local la=""

  while [[ "${answer}" == "" ]]; do
    printf "Verify the command for %s:   " "${gtUserid}"
    printf "gtDelRepo %s\n" "${repoName}"

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

  if [[ "${la}" != "y" ]]; then
    printf "No action taken.\n"
    exit
  fi
}


# calls gtDelRepo and parses the status of the results
runDelCmd() {
  local json=$(gtDelRepo "${repoName}")

  # if there is a message in the json, then there is an error
  local error="${json/*\"message\"*/true}"
  if [[ ${error} == "true" ]]; then
    printf "Error: deleting the repo %s " "${repoName}"
    local errorMsg="${json/*message\": \"/}"
    errorMsg="${errorMsg/\"*/}"
    case "${errorMsg}" in
      "Not Found")
        printf "%s not on github\n" "--"
        ;;
      *)
        printf "%s %s\n" "--" "${errorMsg}"
        ;;
    esac
    exit
  fi
}


# shows the final message that the repo was created on the current date
showResults() {
  local date=$(date '+%A %d %b %Y at %H:%M %p')
  printf "%s deleted from GitHub on %s\n" "${repoName}" "${date}"
  printf "You will still need to manually delete %s on your local machine.\n" \
         "${repoName}"
}


main() {
  parseParamList "${@}"
  validateRepoNameAndUserid
  confirmWithUser
  runDelCmd
  showResults
}

main $@
