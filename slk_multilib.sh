#!/bin/sh

# ========================
# 脚本用于在Slackware64 上
# 安装32 位运行库，对32 位
# 发行版或者非Slakcware 的
# 发行版没什么用处，请绕行
#
# 32 位运行库安装方法来自于
# http://www.slackware.com/~alien/multilib/
#

version_id=''
target_dir=''
arch=''

# 没有root 权限则退出
if [[ 'root' != $USER ]]; then
  echo 'EE: 要求root 权限但未得到。'
  exit 1
fi

# 不存在lftp 指令则退出
if ! type lftp >/dev/null 2>&1; then
  echo "EE: lftp 指令未发现，执行su -c 'slackpkg install lftp' 指令安装lftp。"
  exit 1
fi

# 处理可能的开关
while getopts "dh" switch; do
  case $switch in
    h)  cat <<END_OF_HELP
使用-d 参数指明当前在使用开发版本（Slackware Current）。
未使用开发版本则不要指定-d 参数。
-h 参数打印本帮助。
END_OF_HELP
        exit 0
      ;;
    d)  version_id='current'
      ;;
    \?) echo 'EE: 未知参数，使用-h 参数打印帮助'
        exit 1
      ;;
  esac
done

# 获取内核架构
arch=$(uname -m)
if ! echo $arch | grep '64' >/dev/null 2>&1; then
  echo 'EE: 当前系统不是64 位系统。'
  exit 1
fi

# 如果不是Current 则获取Slakcware 版本号
if [[ -z $version_id ]]; then
  # 判断/etc/slackware-version 存在性
  if [[ ! -e /etc/slackware-version ]]; then
    echo 'EE: /etc/slackware-version 不存在，请检查你的发行版。'
    exit 1
  fi

  # 设置版本号
  version_id=$(sed -n 's/slackware \(.\+\)/\1/ip' /etc/slackware-version)

  # 网站上最低支持版本13.0，低于这个版本则报错
  if [[ $version_id < 13.0 ]]; then
    echo "当前版本$version_id 太低因而不被支持。"
    exit 1
  fi
fi

# 构造目标目录
target_dir=/tmp/multilib_$version_id

# 下载multilib 安装包
lftp -c "open http://slackware.com/~alien/multilib; mirror -c -e $version_id $target_dir;"

# 安装multilib 安装包
find $target_dir -name '*.t?z' -exec upgradepkg --reinstall --install-new {} \;

# 删除下载内容，因为Slackware /tmp 默认不是tmpfs 的挂载点
rm -rf $target_dir

