#### 欢迎使用 Leisure Linux 制作的 AlpineOS 无盘站虚拟机
##### A diskless AlpineOS VM can auto backup the $HOME data to local/remote storage before shutdown/reboot

#### 如何创建无盘虚拟机(默认分配4核，512M内存)
  1. git clone 本仓库;  cd Alpine
  2. 运行 ./dl_netboot.sh 来下载需要的内核和 initrd 两个镜像(8+22 MB)
  3. 把 ./leisure-00.apkovl.tar.gz scp 到本地或者云端的 Web 上，上传后，确保能通过 wget 一个 URL 下载到
  4. 修改 leisure-00.xml 文件的 kernel/initrd 两行内的文件路径，修改 cmdline 中 apkovl 对应的值为以上 URL
  5. 定义虚拟机：virsh define --file leisure-00.xml
  6. 启动虚拟机：virsh start leisure-00
      - 进入 console 查看：virsh console leisure-00
      - root 账号密码： LeisureLinux
      - leisure 账号密码： leisurelinux
      - 登录后，请参考 ~leisure/README.md 

#### 进入无盘机操作系统后需要关注的几个要点：
  - 实现数据自动备份的脚本是： /etc/init.d/lbu-backup，请根据您自己的情况修改该脚本
  - 系统重启/停机时会关闭 sshd 进程，在 /etc/init.d/sshd 的 pre_stop 部分，调用了 lbu-backup
  - 备份可以使用 scp/rsync/ssh 等各种办法，但是需要 ssh-key 实现无密码登录，因此使用之前请用 root 执行：
    - ssh-keygen -t rsa -N ''
    - ssh-copy-id username@remotehost
  - 需要临时备份，可以在普通用户下运行 .b 命令，这个 alias 在 ~/.zshrc 里定义，请根据自己的情况修改

#### FAQ
  - Q1: could not open kernel/initrd file
    - A1: 权限问题，把下载下来的文件路径切换到具有 755 权限的目录下
  - Q2: 如何安装图形界面(X-Windows), Xfce ?
    - A2: 参考： https://wiki.alpinelinux.org/wiki/Xfce ，但是要实现无盘站的图形界面，不但要增加虚拟机内存，最核心的是需要增加 modloop 到内核参数，即： modloop=http://mirrors.nju.edu.cn/alpine/edge/releases/x86_64/netboot/modloop-lts，详细可以阅读 /etc/init.d/modloop 脚本
  - Q3: 为什么不使用 /etc/local.d 来实现数据自动备份？
    - A3: /etc/local.d 内的普通脚本（不是 openrc 脚本），依赖于 local 服务的启用，只有 local 服务停止时，才会执行里面的 .stop 脚本 ，不能实现希望的重启时自动备份数据的需求。

