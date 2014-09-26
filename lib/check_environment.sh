# =========================
# check_environment
# 检查脚本依赖环境是否满足
# 结果直接用return 语句返回
#
# Copyright (C) 2014 iSpeller
# =========================

function check_environment {
  local use_dialog

  use_dialog=$1
  shift

  # 无root 权限则退出
  if [[ 'root' != $USER ]]; then
    title='错误'
    msgbox='请使用root 权限运行脚本。'

    if [[ 'true' == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 5 50
    else
      echo "$msgbox"
    fi

    return 0
  fi

  # 不是Slackware Linux 则退出
  if [[ ! -r /etc/slackware-version ]]; then
    title='错误'
    msgbox=$(
      cat <<EOM
您的系统似乎不是Slackware。
如果的确是Slackware，请尝试重新安装aaa_base 软件包。
EOM
    )

    if [[ 'true' == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 10 50
    else
      echo "$msgbox"
    fi

    return 0
  fi

  # 无lftp 指令则退出
  if ! type lftp >/dev/null 2>&1; then
    title='错误'
    msgbox='lftp 指令未发现，请先安装lftp。'

    if [[ 'true' == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 5 50
    else
      echo "$msgbox"
    fi

    return 0
  fi

  return 1
}

