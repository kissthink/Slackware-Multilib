# =========================
# get_version
# 得到Multilib 的版本号
# 结果存入$version_file
#
# Copyright (C) 2014 iSpeller
# =========================

function get_version () {
  local my_version
  local result
  local use_dialog
  local result_file

  use_dialog=$1
  shift
  work_directory=$1
  result_file=$work_directory/result
  version_file=$work_directory/version
  shift

  alias dialog='/usr/bin/dialog'

  my_version=$(sed -n 's/slackware \(.\+\)/\1/ip' /etc/slackware-version)

  title='版本'
  menu='选择Multilib 的版本'
  switch_1="Slackware $my_version"
  switch_2='Slackware Current'
  switch_3='手动指定版本'
  switch_4='关于'
  switch_5='退出'

  while true; do
    if [[ 'true' == $use_dialog ]]; then
      dialog --title "$title" --default-item 1 \
            --menu "$menu" 15 50 5 \
            1 "$switch_1" \
            2 "$switch_2" \
            3 "$switch_3" \
            4 "$switch_4" \
            5 "$switch_5" \
            2>$result_file
      result=$(cat $result_file)
    else
      echo $menu
      echo 1 "$switch_1"
      echo 2 "$switch_2"
      echo 3 "$switch_3"
      echo 4 "$switch_4"
      echo 5 "$switch_5"
      while true; do
        read -p "请选择：" result
        if [[ 0 < $result && 6 > $result ]]; then
          break
        fi
      done
    fi

    case $result in
      1)
        my_version=$my_version
        break
        ;;
      2)
        my_version='current'
        break
        ;;
      3)
        title='版本'
        inputbox='输入要指定的版本号'
        if [[ 'true' == $use_dialog ]]; then
          dialog --title "$title" --inputbox "$inputbox" 10 50\
            2>$result_file
          my_version=$(cat $result_file)
        else
          read -p "$inputbox：" my_version
        fi
        break
        ;;
      4)
        title='关于'
        msgbox=$(
          cat <<EOM
  Copyright (C) 2014 iSpeller

  此程序是自由软件；您可以以自由软件基金会发布的GNU 通用公共许可协议第三版或（您可以选择）更高版方式重新发布它和/或修改它。

  此程序是希望其会有用而发布，但没有任何担保；没有甚至是暗含的适宜销售或特定目的适用性方面的担保。详情参看GNU 通用公共许可协议。

  您应该与此程序一道收到了一份GNU 通用公共许可协议的副本；如果没有，请查看<http://www.gnu.org/licenses/>。
EOM
        )
        if [[ 'true' == $use_dialog ]]; then
          dialog --title "$title" --msgbox "$msgbox" 20 50
        else
          echo "$msgbox"
        fi
        ;;
      5)
        exit 0
        ;;
      *)
        echo '未知的选项' 1>&2
        exit 1
        ;;
  esac
  done

  echo "$my_version" > "$version_file"
}

