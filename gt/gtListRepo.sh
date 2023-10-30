# @fileoverview gtListRepo [ -h ]
# list your repos in a table: | name | visibility | creation date | mod date |
#

# set up script location and zshFlag
scriptDir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd); tDir=${0:a:h} zshFlag=0
if [[ ${#tDir} -gt 0 ]];then scriptDir="${tDir}";zshFlag=1;fi;unset tDir
source ${scriptDir}/gtUtil.sh   # abstracts github API

scriptName=${0##*/};scriptName=${scriptName##*\\}  #last part of full pathname
paramList=()
errorMsgList=()                 # list of error messages to display
json=""
gtListParam="?sort=updated"     # gtGetRepoList takes parameters like "sort"

printHelp() {
  local shellName="bash"
  if [[ "${zshFlag}" -eq 1 ]]; then shellName="zsh"; fi
  printf "(You are using %s to run v%s of gt)\n" \
         "${shellName}" "${GT_VERSION}"
  printf "list your repos in a table: "
  printf "| name | visibility | creation date | mod date |\n"
  printf "usage: gt [list | ls ]\n"
  printf "  -sc   sort by creation date\n"
  printf "  -sn   sort by name\n"
  printf "  -sm   sort by modification date (default)\n"
  printf "  -h |-? | -help | --help | help  shows this help message\n"
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


# side effect -- updates helpFlag
parseParamList() {
  local pList=( "${@}" )
  local paramCount="${#pList[@]}"

  for ((i=0 ; i < paramCount; ++i)); do
    local param="${pList[@]:$i:1}"  # 0th regardless of zsh or bash

    # lowercase param in zsh v bash
    local paramLower
    if [[ "${zshFlag}" -eq 1 ]]; then
      paramLower="${param:l}"
    else
      paramLower="${param,,}"
    fi

    # handle the parameter
    case "${paramLower}" in
      "-h" | "-?" | "-help" | "--help" | "help")
        printHelp
        exit
        ;;

      "-sc")
        gtListParam="?sort=created"
        ;;

      "-sn")
        gtListParam="?sort=full_name"
        ;;

      "-sm")
        gtListParam="?sort=updated"
        ;;

      *)
        errorMsgList+=(""${param}" is an invalid parameter.")
        ;;
    esac
  done

  # if there are errors then show them and and exit
  if [[ "${#errorMsgList[@]}" -gt 0 ]]; then
    printErrorMsgList
    exit
  fi
}


printRepoTable() {
  local date=$(date '+%a %d %b %Y %H:%M %p')

  if [[ "${json}" == "" ]]; then
    printf "There are 0 repositories (%s) v%s\n" "${date}" "${GT_VERSION}"
    return
  fi

  local repoNameList=( $(gtGetJsonQuotedField "${json}" "full_name") )
  local privateList=( $(gtGetJsonUnquotedField "${json}" "private") )
  local createDateList=( $(gtGetJsonDateField "${json}" "created_at") )
  local modDateList=( $(gtGetJsonDateField "${json}" "updated_at") )
  local repoCount="${#repoNameList[@]}"

  # check that all lists are same len, else error and print just the repo names
  if [[ "${repoCount}" != "${#privateList[@]}" || \
          "${repoCount}" != "${#createDateList[@]}"  || \
          "${repoCount}" != "${#modDateList[@]}"  \
      ]]; then
    printf " Error: problem parsing the json results. \n"
    printf "[%s]\n", "${json}"
    exit
  fi

  local sortName="name"
  if [[ "${gtListParam}" == "?sort=created" ]]; then
    sortName="creation date"
  elif [[ "${gtListParam}" == "?sort=updated" ]]; then
    sortName="modification date"
  else
    sortName="name"
  fi

  printf "%d repositories sorted by %s   " \
         "${repoCount}" "${sortName}"
  printf "(%s v%s)\n" "${date}" "${GT_VERSION}"
  printf "%-43s %-7s    %-11.11s  %-12.12s\n" \
         "repository name" "private" "creation" "modification"
  printf "%s%s\n" "-----------------------------------" \
         "---------------------------------------------"

  for ((i=0; i<$repoCount; ++i)); do
    local repoName="${repoNameList[@]:$i:1}"  # 0th regardless of zsh or bash
    local private="yes"
    if [[ "${privateList[@]:$i:1}" != "true" ]]; then
      private=$(printf "${BC_GREEN_BG}""no ""${BC_RESET}""   ")
    fi
    local createDate="${createDateList[@]:$i:1}"
    createDate=$(date -d "${createDate}" +%d" "%b" "%Y)
    local modDate="${modDateList[@]:$i:1}"
    modDate=$(date -d "${modDate}" +%d" "%b" "%Y)

    printf "%-45s %-6s %-11.11s    %-11.11s\n" "${repoName}" "${private}" \
           "${createDate}" "${modDate}"
  done
}


getRepoList() {
  json=$(gtGetRepoList "${gtListParam}")

  if [[ "${json}" =~ "gtErrorMessage" ]]; then
    errorMsg="${errorMsg/\"*/}"
    printf "Error: %s\n" "${errorMsg}"
    exit
  fi
}

main() {
  parseParamList "${@}"
  getRepoList
  printRepoTable
}

main $@
