# @fileoverview gt runs various gitTool commands (e.g. gt addRepo):
#   gt [add | list | del | help | version]
#   gt [add | ls   | rm  | -h --help | -v]
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

cmd=""               # the cmd the user enters
shellCmd=""          # the actual shell cmd gt runs
paramList=()         # the list of additional parameters


printHelp() {
  local shellName="bash"
  if [[ "${zshFlag}" -eq 1 ]]; then shellName="zsh"; fi
  printf "(You are using %s to run v%s of gt)\n" \
         "${shellName}" "${GT_VERSION}"
  printf "%s provides easy-to-use shell commands " "${scriptName}"
  printf "for github repositories.\n"
  printf "Usage: %s [add | del | list | help] [paramList]\n" "${scriptName}"
  printf "add            add a new repo "
  printf "(example: %s addRepo repoName -public)\n" "${scriptName}"
  printf "del     | rm   delete a repo from github "
  printf "(example: %s del repoName)\n" "${scriptName}"
  printf "list    | ls   list your gitHub repos\n"
  printf "help    | -h   show help\n"
  printf "version | -v   show the version (%s)\n"  "${GT_VERSION}"
}


# side effect -- updates global cmd and paramList
parseParamList() {
  local found=0
  local pList=( "${@}" )
  local paramCount="${#pList[@]}"

  for ((i=0 ; i < paramCount; ++i)); do
    local param="${pList[@]:$i:1}"  # 0th regardless of zsh or bash
    local firstChar="${param:0:1}"

    # found the command. store it and flag it as found
    if [[ "${found}" -eq 0 && "${firstChar}" != "-" ]]; then
      cmd="${param}"
      found=1
    else
      paramList+=("${param}")
    fi
  done
}


# if no cmd show help if cmd=help show help else make sure legit cmd
validateCmd() {
  # lowercase cmd in zsh v bash
  if [[ "${zshFlag}" -eq 1 ]]; then cmd="${cmd:l}";else cmd="${cmd,,}";fi

  # validate the cmd and set the actual shell script name
  case ${cmd} in
    "addrepo" | "add")
      shellCmd="gtAddRepo.sh"
      ;;

    "delrepo" | "del" | "rm")
      shellCmd="gtDelRepo.sh"
      ;;

    "listrepos" | "listrepo" | "list" | "ls")
      shellCmd="gtListRepo.sh"
      ;;

    "help" | "-h" | "-?" | "")    # if no cmd show help
      printHelp
      exit
      ;;

    "version" | "-v")
      printf "gt version %s\n"  "${GT_VERSION}"
      exit
      ;;

    *)
      printf "Error: "${cmd}" is an invalid command.\n" "${cmd}"
      printHelp
      exit
      ;;
  esac
}


runShellCmd() {
  local sh="bash"; if [[ "${zshFlag}" -eq 1 ]]; then sh="zsh"; fi
  "${sh}" "${scriptDir}"/"${shellCmd}" "${paramList[@]}"
}


main() {
  parseParamList "${@}"
  validateCmd
  runShellCmd
}

main $@
