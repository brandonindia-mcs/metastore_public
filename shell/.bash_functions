function changetext { printf "\e[$1;$2;$3m${*:4}\e[0m " ; }
function showcolors { for bg in `seq 0 9`; do for fg in `seq 0 9`; do echo -n "`expr $fg` `expr $bg`: " && color `expr $fg` `expr $bg` "this & that"; echo; done; done }
alias colors=showcolors
function showchangetext { for bg in 100 `seq 40 47`;do for fg in `seq 30 37`;do for txt in `seq 0 1`;do changetext $txt $fg $bg "$txt $fg $bg" && echo;done;done;done; }
function println     { printf "$1\n" "${@:2}"; }
function TIMESTAMP   { date +%Y-%m-%dT%T.%N; }
function color       { echo -n "$(tput setaf $1;tput setab $2)${3}$(tput sgr 0) "; }
function normal      { changetext 0 0 0 $*; }
function green       { changetext 0 34 42 $* ; }
function red         { changetext 1 37 41 $* ; }
function yellow      { changetext 1 33 40  $* ; };
function blue        { changetext 1 36 44 $*; }
function blue_text   { changetext 1 34 40 $*; }
function cyan        { changetext 0 37 46 $*; }
function grey        { changetext 1 37 100 $* ; }
function pass        { green "$(date "+%Y-%m-%d %H:%M:%S") PASS($1):"  && echo "${@:2}" && echo; }
function fail        { red   "$(date "+%Y-%m-%d %H:%M:%S") FAIL($1):"  && echo "${@:2}" && echo; }
# function abort       { red   "$(date "+%Y-%m-%d %H:%M:%S") ABORT($1):" && echo "${@:2}" && echo; }
# function abort_hard  { red   "$(date "+%Y-%m-%d %H:%M:%S") ABORT($1):" && echo "${@:2}, exiting..." && read -p "press CTRL+C" && exit 1; }
function abort       { red   "$(date "+%Y-%m-%d %H:%M:%S") ABORT($1):" && echo "${@:2}" && echo; }
function abort_hard  { red   "$(date "+%Y-%m-%d %H:%M:%S") ABORT($1):" && echo "${@:2}" && exit 1; } # read -p "press CTRL+C" && exit 1; }
function warn        { wern  "$(date "+%Y-%m-%d %H:%M:%S") WARN($1):"  && echo "${@:2}" && echo; }
function wern        { changetext 0 31 43 $* ; }
function log         { grey "`basename "$0" 2>/dev/null`($1):" && echo "${@:2}"; }
function log_success { green "`basename "$0" 2>/dev/null`($1):" && echo "${@:2}"; }
function log_s       { log_success $*; }
function success     { log_success $*; }
function log_error   { red "`basename "$0" 2>/dev/null`($1):" && echo "${@:2}"; }
function log_e       { log_error $*; }
function error       { log_error $*; }
function log_warn    { wern "`basename "$0" 2>/dev/null`($1):" && echo "${@:2}"; }
function log_w       { log_warn $*; }
function warn        { log_warn $*; }
function log_notify  { blue "`basename "$0" 2>/dev/null`($1):" && echo "${@:2}"; }
function notify      { blue "`basename "$0" 2>/dev/null`($1):" && echo "${@:2}"; }
function countdown   { max=$1 min=0 && for i in `seq $min $(expr $max - 1)`;do echo -n "`expr $max - $i`.. " && sleep 1;done; }
# function log_usage { yellow "`basename "$0"`($1):" && echo "${@:2}"; }# Recursion to handle each file or directory encountered
function push { pushd "$1" >/dev/null ; }
function pop { popd  >/dev/null ; }
function print_array { echo print_array && local arr=$1 && printf '\t%s\n' "${arr[@]}" ; }
function dumpvars { for v in $@;do echo -e \\t$v: ${!v}; done ; }
function pause_for_effect1 { pausing_for_effect "$* $(echo -e \\n\\n[press ENTER])" ; }
function pausing_for_effect { read -p "pausing for effect... $* " x; } #[press <ENTER>]
function pause_for_effect2 { echo -e \\n @ $1: && dumpvars ${@:2} && pausing_for_effect; }
function exit9 { echo "BEEEEEEEEEP $* - exiting" && exit 9; }
function noyes { yesno-N "$*"; }
function yesno { yesno-Y "$*"; }
function yesno-Y { read -p "$1 yes (default) or no: " && if [[ ${REPLY,,} = n   ]] || [[ ${REPLY,,} = no    ]]; then return 9; fi; return 0; }
function yesno-Y { read -p "$1 yes (default) or no: " && if [[ ${REPLY} = n     ]] || [[ ${REPLY} = no      ]]; then return 9; fi; return 0; }
function yesno-N { read -p "$1 yes or no (default): " && if [[ ${REPLY,,} = y   ]] || [[ ${REPLY,,} = yes   ]]; then return 0; fi; return 9; }
function yesno-N { read -p "$1 yes or no (default): " && if [[ ${REPLY,,} = y   ]] || [[ ${REPLY} = yes     ]]; then return 0; fi; return 9; }
function unindex { $(which git) update-index --skip-worktree "${*}"; }
function reindex { $(which git) update-index --no-skip-worktree "${*}"; }
function cleanwhite { sed -i -e 's/\r$//' "$1" ; }
function toupper { echo ${*^^}; }
function tonix { str=~/$(tr \\\\ / <<<"$*") && sed 's/\\\\/\\\//g' <<<"$str" | tr -d : ; }
function cdtonix { str=~/$(tr \\\\ / <<<"$*") && cd $(sed 's/\\\\/\\\//g' <<<"$str" | tr -d :) ; }
function beforefirst    { if [ -z $1 ];then usage "\`${FUNCNAME[0]} ls-complex-way -\` # RETURNS ls" && return 1;fi; echo ${1%%$2*} ; } # ex: beforefirst xxxxx-yy - # RETURNS xxxxx
function getmiddle      { if [ -z $1 ];then usage "\`${FUNCNAME[0]} - <<<complex-ls-way\` # RETURNS ls" && return 1;fi; cut -d$1 -f2; } # ex: getmiddle - <<<"xxx-YYY-zzz" # RETURNS YYY
function afterlast      { if [ -z $1 ];then usage "\`${FUNCNAME[0]} - <<<complex-way-ls\` # RETURNS ls" && return 1;fi; sed -e "s#.*$1\(\)#\1#"; } # RETURNS WHATEVER IS *AFTER THE LAST* ARG1 ex: $(afterlast - <<<complex-way-of-ls)
# function getmiddle { if [ -z $1 ];then usage "\`${FUNCNAME[0]} - <<<\"xxx-YYY-zzz\"\` # RETURNS YYY" && return 1;fi; cut -d$1 -f2; } # ex: getmiddle - <<<"xxx-YYY-zzz" # RETURNS YYY
function get_keyname_v1 { if [ $# -eq 0 ];then cat ${SECURE_ASSETS}/DEFAULT_RSA;else x=$(afterlast - <<<"$1") && cat ${SECURE_ASSETS}/${x^^}_AT_${DOCKERHUB^^}; fi; }
function get_keyname_v2 { if [ $# -eq 1 ];then echo ${1,,}-id_rsa; fi; }
function get_keyname { get_keyname_v2 $*; }
function get_production_keyname { get_keyname $1 ;}
function get_integration_keyname { get_keyname $1 ;}
function get_application_keyname { get_keyname $1 ;}
function get_developer_keyname { get_keyname $1 ;}
function print_critical_values { unset CRITICAL_VALUES; for x in $@;do CRITICAL_VALUES+=($x);done; if [ ${#CRITICAL_VALUES[@]} -gt 0 ];then echo Critical Values: && for v in ${CRITICAL_VALUES[@]};do printf "%20s %s\n" $v: ${!v};done;else usage ${FUNCNAME[0]}: pass critical variable names as arguments;fi ; }
# alias gitwho="git config --get-regexp \"user|identity\""
# alias azwho="az account show --query \"{Subscription:name,SubscriptionID:id,Type:user.type,User:user.name,Tenant:tenantId}\" -o table"
function gitwho { git config --get-regexp "user|identity"; }
# function gitwho { git config --get-regexp "user.email"|awk "{ print $2 }"; }
# function gitwho { git config --get-regexp "user.email"|sed "s/user\.email//"; }
function azwho { az account show --query "{Subscription:name,SubscriptionID:id,Type:user.type,User:user.name,Tenant:tenantId}" -o table ; }
# alias azt="az login -t ${AZTENANT} >/dev/null && az account set --subscription ${AZSUB} && azwho"
function azt { az login -t ${AZTENANT} >/dev/null && az account set --subscription ${AZSUB} && azwho ; }
function azp { az login --service-principal -u ${SUPER} -t ${AZTENANT} -p$(echo ${AZCERT}); }
function usage { cat <<EOM
$(wern  ${FUNCNAME[0]})
  $*
EOM
}

###
### traverse expectes an addressable function
###
### usage  : traverse [recursive_function] [directory]
### example: traverse handle_directory .
###

function traverse {
  eval $1 "$2" "$(pwd)" || echo -e "Usage:\ttraverse [function] [directory]\n\texample: traverse handle_directory ."
}
function handle_file {
    # Do something with the file
    echo "Found file: $1"
}
function handle_directory {
    # Do something with the directory
    echo "Found directory: $1"
    
    # Recursively search for files and directories in the directory
    for entry in "$1"/*; do
        if [ -d "$entry" ]; then
            handle_directory "$entry"
        elif [ -f "$entry" ]; then
            handle_file "$entry"
        fi
    done
}
function unzip_directory {
    # Do something with the directory
    if [ -z $TRAVERSE_LOG ];then echo set TRAVERSE_LOG ahead of time && return 1;fi
    if [ ! -d "$(pwd)" ]; then echo "$(pwd) not a directory" && return 1;fi
    process_unzip "$(pwd)"
    # Recursively search for files and directories in the directory
    for entry in "$(pwd)"/*; do
        if [ -d "$entry" ]; then
            echo "pushing $entry" >>$TRAVERSE_LOG
            pushd "$entry" >/dev/null && traverse unzip_directory "$(pwd)" && popd >/dev/null
        fi
    done
}



# for entry in "$(pwd)"/*zip;
function process_unzip {
    if [ -z $TRAVERSE_LOG_ERROR ];then echo set TRAVERSE_LOG_ERROR ahead of time && return 1;fi
    local zip_dir="$(pwd)"
    # echo -e "Inside $zip_dir/"
    # echo -n " and found: $(/bin/ls *.zip 2>/dev/null)" && read -p "Press Enter" x
    # for zip_file in "$(/bin/ls *.zip 2>/dev/null)";do
    for zip_file in "$(pwd)"/*zip;do
        if [ -f "$zip_file" ];then
            local base_name="$(basename "$zip_file" .zip)"
            local unzip_dir="$(dirname "$zip_file")/$base_name"
            # echo -e "\n\tunzipping to $unzip_dir"
            unzip -o "$zip_file" -d "$unzip_dir" >/dev/null 2>>$TRAVERSE_LOG_ERROR
        fi
    done
}
function traverseup {
if [ -z $1 ];then echo bad args && return 1;fi
# Start in the current directory
dir=$(pwd)
log $LINENO "dir:$dir"

# Loop through parent directories
while [ "$dir" != "/" ]; do
  # Check if the '$1' script exists and is executable
  if [ -f "$dir/$1" -a ! -x "$dir/$1" ];then echo "$dir/$1 not executable" && read -p "Ctrl+C to exit" x && exit 1;fi
  if [ -x "$dir/$1" ]; then
    # Execute the script and exit
    log executing "$dir/$1"
    "$dir/$1"
  fi

  # Move to the parent directory
  dir=$(dirname "$dir")
  log $LINENO "dir:$dir"
done
}
function gitswitch {
    if [ -n "$1" ];then
        ln -fs $(find ~/Organization -name ".gitconfig-${1}" 2>/dev/null | grep "." || find ~/Organization -name ".gitconfig-$GIT_DEFAULT_USER") ~/.gitconfig
    else traverseup gituser; fi
    gitwho
}

function get_sql_servername {
if [ -z $1 ];then abort ${FUNCNAME[0]} no arg1, FUNCNAME[0] [container] [password] && return 1;fi
if [ -z $2 ];then abort ${FUNCNAME[0]} no arg1, FUNCNAME[0] [container] [password && return 1;fi
SQLCONTAINER=$1
SQLCMD=/opt/mssql-tools/bin/sqlcmd
DBUSER=sa
DBPSWD=$2
SQLCONNECT="${SQLCMD} -U ${DBUSER} -P ${DBPSWD}"
docker exec -it ${SQLCONTAINER} ${SQLCONNECT} -h -1 -Q "set nocount on; select @@SERVERNAME"
}

ZERO=0
ONE=1
TWO=2
THREE=3
FOUR=4
FIVE=5
SIX=6
SEVEN=7
EIGHT=8
NINE=9
TEN=10
ELEVEN=11
TWELVE=12
THIRTEEN=13
FOURTEEN=14
FIFTEEN=15
SIXTEEN=16
SEVENTEEN=17
EIGHTTEEN=18
NINETEEN=19
TWENTY=20

# echo $0 called .bash_functions
