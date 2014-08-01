脚本用于在Slackware64 上安装32 位运行库。

`git clone https://github.com/iSpeller/Slackware-Multilib.git /tmp/Slackware-Multilib`

`cd /tmp/Slackware-Multilib`

如果当前使用Slackware Current 则执行

`su -c './slk_multilib.sh -d'`

否则执行

`su -c ./slk_multilib.sh`

如果的确使用Slackware，但是/etc/slackware-version 因为某种原因缺失，请执行

`su -c 'echo Slackware VERSION > /etc/slackware-version'`

其中的`VERSION` 换成你的Slackware 版本号（Current 则换成最近一个稳定版的版本号），然后再执行脚本。

