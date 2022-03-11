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
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX%{$B%}$(git_branch)$(git_status)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 2> /dev/null 屏蔽输出结果
###### 获取分支名称
git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}
###### 获取分支状态
git_status() {
  _FILE_STATUS=""   #本地文件状态
  _BRANCH_STATUS="" #本地分支状态
  #检查本地 文件 状态
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

  #冲突后不判断仓库状态
  if [ $_FILE_STATUS = $ZSH_THEME_GIT_PROMPT_UNMERGED ]; then          
      echo $_FILE_STATUS
      exit 0
  fi

###### 检查本地 仓库 状态
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*origin'); then

      #超前（本地有更新 需push）
      if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then    
        echo "$_FILE_STATUS $ZSH_THEME_GIT_PROMPT_AHEAD"
        exit 
      fi
      #落后（远程有更新 需pull）
      if $(echo "$_INDEX" | command grep -q '^## .*behind'); then    
        echo "$_FILE_STATUS $ZSH_THEME_GIT_PROMPT_BEHIND"
        exit 
      fi
      #偏离
      if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then 
        echo "$_FILE_STATUS $ZSH_THEME_GIT_PROMPT_DIVERGED"
        exit 
      fi
      #无修改
      echo "$_FILE_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
      exit 
      # if $(echo "$_flag" | command grep -q "0"); then               
      #  echo "$_FILE_STATUS $ZSH_THEME_GIT_PROMPT_CLEAN"
      #  exit 
      # fi
  else  
    #未提交远程
    echo "$_FILE_STATUS $ZSH_THEME_GIT_PROMPT_UNTRACKED"
    exit 
  fi
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

# Not-staged
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$R%}?"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$R%} 冲突"
