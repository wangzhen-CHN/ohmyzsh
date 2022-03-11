# Sunrise theme for oh-my-zsh
# Intended to be used with Solarized: https://ethanschoonover.com/solarized

# Color shortcuts
R=$fg[red]
G=$fg[green]
M=$fg[magenta]
Y=$fg[yellow]
B=$fg[cyan]
RESET=$reset_color

if [ "$USERNAME" = "root" ]; then
    PROMPTCOLOR="%{$R%}" PROMPTPREFIX="-!-";
else
    PROMPTCOLOR="%{$R%}" PROMPTPREFIX="%{$Y%}wz";
fi

local return_code="%(?..%{$R%}%? ↵%{$RESET%})"

# Get the status of the working tree (copied and modified from git.zsh)

# get the name of the branch we are on (copied and modified from git.zsh)
function custom_git_prompt() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX%{$B%}${ref#refs/heads/}$(git_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 获取分支状态
git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

git_status() {
  _FILE_STATUS=""   #本地文件状态
  _BRANCH_STATUS="" #本地分支状态
  ###### 检查本地 文件 状态
  _INDEX=$(command git status --porcelain 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then      #修改
      _FILE_STATUS="$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then       #修改
      _FILE_STATUS="$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then      #修改
      _FILE_STATUS="$ZSH_THEME_GIT_PROMPT_DIRTY"
    fi
    if $(echo "$_INDEX" | command grep -q '^UU '); then           #冲突
      _FILE_STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    _FILE_STATUS="$ZSH_THEME_GIT_PROMPT_CLEAN"                         #无修改
  fi


  if [ $_FILE_STATUS = $ZSH_THEME_GIT_PROMPT_UNMERGED ]; then          #冲突后不判断仓库状态
      echo $_FILE_STATUS
      exit 0
  fi

  ###### 检查本地 仓库 状态
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  _flag="0"
  if $(echo "$_INDEX" | command grep -q '^## .*origin'); then
   
      if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then    #超前（本地有更新 需push）
        _BRANCH_STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD"
        _flag="1"
      fi
      if $(echo "$_INDEX" | command grep -q '^## .*behind'); then   #落后 （远程有更新 需pull）
        _BRANCH_STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND"
        _flag="1"
      fi
      if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then #偏离
        _BRANCH_STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED"
        _flag="1"
      fi
      if $(echo "$_flag" | command grep -q "0"); then               #无修改
        _BRANCH_STATUS="%{$G%}="
      fi
  else  
    _BRANCH_STATUS=" 未跟踪 " #未提交远程
  fi
  echo "$_FILE_STATUS $_BRANCH_STATUS"
}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# %B sets bold text
PROMPT='%B$PROMPTPREFIX %{$M%}%2~ $(custom_git_prompt)%B>%b%{$RESET%} '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$Y%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$Y%}]%{$RESET%} "

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$R%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$G%}="
ZSH_THEME_GIT_PROMPT_BEHIND="%{$R%}↓"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$B%}↑"
ZSH_THEME_GIT_PROMPT_DIVERGED="%{$B%}Ψ"


ZSH_THEME_GIT_STATUS_PREFIX=" "

# Staged
ZSH_THEME_GIT_PROMPT_STAGED_ADDED="%{$G%}A"
ZSH_THEME_GIT_PROMPT_STAGED_MODIFIED="%{$G%}M"
ZSH_THEME_GIT_PROMPT_STAGED_RENAMED="%{$G%}R"
ZSH_THEME_GIT_PROMPT_STAGED_DELETED="%{$G%}D"

# Not-staged
ZSH_THEME_GIT_PROMPT_UNTRACKED="% {$R%}?"
ZSH_THEME_GIT_PROMPT_MODIFIED="% {$R%}M"
ZSH_THEME_GIT_PROMPT_DELETED="% {$R%}D"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$R%} 冲突"
