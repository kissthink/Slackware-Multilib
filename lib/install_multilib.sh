# =========================
# install_multilib
# 下载并安装Multilib
# 结果以return 语句返回
#
# Copyright (C) 2014 iSpeller
# =========================

function install_multilib () {
  local use_dialog
  local version
  local cache_directory
  local delete

  use_dialog=$1
  shift
  cache_directory=$1
  shift
  version=$1
  shift

  # 下载Multilib 安装包
  /usr/bin/lftp -c "open http://slackware.com/~alien/multilib/; mirror -c -e $version $cache_directory;"
  if [[ 0 != $? ]]; then
    title='错误'
    msgbox=$(
      cat <<EOM
无法下载Multilib 安装包。
可能是因为版本号不正确。
EOM
    )
    if [[ 'true' == $use_dialog ]]; then
      dialog --title "$title" --msgbox "$msgbox" 10 50
    else
      echo "$msgbox"
    fi
    exit 1
  fi

  # 安装
  /usr/bin/sudo /usr/bin/find "$cache_directory" \
    -name '*.t?z' \
    -exec upgradepkg \
    --reinstall --install-new {} \;

  # 清理：Slackware 的/tmp 目录默认不是tmpfs 的挂载点
  title='选择'
  yesno="是否删除缓存的Multilib 安装包（$cache_directory）？"
  if [[ 'true' == $use_dialog ]]; then
    dialog --title "$title" --yesno "$yesno" 5 50;
    if [[ 0 == $? ]]; then
      delete='true'
    else
      delete='false'
    fi
  else
    read -p "$yesno（y/n）" delete
    delete=$(echo $delete | tr '[:lower:]' '[:upper:]')
    if [[ 'Y' == $delete ]]; then
      delete='true'
    else
      delete='false'
    fi
  fi
  if [[ 'true' == $delete ]]; then
    /usr/bin/sudo /usr/bin/rm -rf $cache_directory
  fi
}

