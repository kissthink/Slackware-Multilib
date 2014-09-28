# =========================
# get_arch
# 获得机器的架构
# 结果存入$arch_file
#
# Copyright (C) 2014 iSpeller
# =========================

function get_arch () {
  local arch
  local use_dialog
  local work_directory
  local arch_file

  use_dialog=$1
  shift
  work_directory=$1
  arch_file=$work_directory/arch
  shift
  arch=$(uname -m)

  alias dialog='/usr/bin/dialog'
  alias uname='/usr/bin/uname'
  alias grep='/usr/bin/grep'

  if ! echo $arch | grep -P '64' >/dev/null 2>&1; then
    title='错误'
    msgbox='当前系统不是64 位系统。'

    if [[ true == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 10 50
    else
      echo "$msgbox"
    fi

    exit 1
  else
    echo "$arch" > "$arch_file"
  fi
}

