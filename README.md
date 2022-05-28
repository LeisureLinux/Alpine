#### 如何让 Alpine Linux 无盘机在关机或者重启前自动保存数据
##### Auto backup the $HOME data on a diskless Alpine Linux OS to local/remote storage before shutdown/reboot
#### 本文关联视频： 
  - https://www.bilibili.com/video/BV1434y177aX/

#### 如何创建无盘虚拟机(默认分配4核，512M内存)
  1. git clone 本仓库;  cd Alpine
  2. 运行 ./dl_netboot.sh 下载需要的内核和 initrd 两个镜像(8+22 MB) 文件到本地
  3. 把 ./leisure-00.apkovl.tar.gz scp 到本地或者云端的 Web 上，上传后，确保能通过 wget 一个 URL 下载到
  4. 修改 leisure-00.xml 文件的 kernel/initrd 两行内的文件路径，修改 cmdline 中 apkovl 对应的值为以上 URL
  5. 定义虚拟机：virsh define --file leisure-00.xml
  6. 启动虚拟机：virsh start leisure-00 (每次重启都会从指定 URL 下载备份的 apkovl 包，解开备份的数据，然后从镜像网站下载安装需要的软件包)
      - 进入 console 查看：virsh console leisure-00
      - root 账号密码： LeisureLinux
      - leisure 账号密码： leisurelinux
      - 登录后，请参考 ~leisure/README.md 

#### 进入无盘机操作系统后需要关注的几个要点：
  - 实现数据自动备份的脚本是： /etc/init.d/lbu-backup，请根据自己的情况修改该脚本
  - 系统重启/停机时会关闭 sshd 进程，在 /etc/init.d/sshd 的 pre_stop 部分，调用了 lbu-backup
  - 备份可以使用 scp/rsync/ssh 等各种办法，但是需要 ssh-key 实现无密码登录，因此使用之前请用 root 执行：
    - ssh-keygen -t rsa -N ''
    - ssh-copy-id username@remotehost
  - 如果需要临时备份，可以在普通用户下运行 .b 命令，这个 alias 在 ~/.zshrc 里定义，请根据情况修改

#### 关于 Alpine Linux ，OpenRC 以及 apk
  - Alpine Linux 是 docker 的默认内核，因此学习使用它，对于理解 docker 也有帮助
  - Alpine Linux 使用 musl 作为 C lib 库，很多软件包都要重新编译，市场上有些没有源码的软件就无法得到，因此软件包不丰富
  - OpenRC 真的是非常简单，添加了 before/after 之类的功能，避免之前 Sysvinit 使用前缀数字来调整启动顺序
  - apk 也是一个简单不失优雅的包管理软件，安装 apk-tools-doc 可以查看相关 man 手册,一目了然

#### FAQ
  - Q1: could not open kernel/initrd file
    - A1: 权限问题，把下载下来的文件路径切换到具有 755 权限的目录下
  - Q2: 如何安装图形界面(X-Windows), Xfce ?
    - A2: 参考： https://wiki.alpinelinux.org/wiki/Xfce ，但是要实现无盘站的图形界面，不但要增加虚拟机内存，最核心的是需要增加 modloop 到内核参数，即： modloop=http://mirrors.nju.edu.cn/alpine/edge/releases/x86_64/netboot/modloop-lts, 详细可以阅读 /etc/init.d/modloop 脚本。视频教程： https://www.bilibili.com/video/BV163411V7Un/
  - Q3: 为什么不使用 /etc/local.d 来实现数据自动备份？
    - A3: /etc/local.d 内的普通脚本（不是 openrc 脚本），依赖于 local 服务的启用，只有 local 服务停止时，才会执行里面的 .stop 脚本 ，不能实现希望的重启时自动备份数据的需求。
  - Q4: 你的镜像内包含了哪些包？
    - A4: 使用命令：$ tar xzf leisure-00.apkovl.tar.gz etc/apk/world -O --|sort|xargs 可以看到 36 个包，核心添加的是： avahi bind-tools byobu chrony coreutils dbus findmnt git htop iproute2 jq less less-doc lsblk lsof mandoc mandoc-apropos mandoc-doc man-pages neofetch openrc-doc openssh-client openssh-client-common openssh-server openssl pciutils procps qemu-guest-agent shadow sudo tzdata util-linux-misc vim zsh
  - Q5: 要增加或者删除备份的文件或者目录，怎么办？
    - A5:  lbu 命令有 include 和 exclude 命令可以解决你的问题
  - Q6: 树莓派上能跑吗？能跑虚拟的树莓派吗？或者 RISC-V 的虚拟机？
    - A6:  可以。视频教程： https://www.bilibili.com/video/BV1T34y177xa/
  - Q7: 如何用 virsh 命令调整虚拟机内存和 CPU 数量？(不用 virsh edit，不用 virt-manager )
    - A7:  修改 CPU: $ virsh setvcpus --config  --count 2 --domain leisure-00 ； 修改内存： 
     $ virsh setmem  --config --size 2G --domain leisure-00
  - Q8: 我想多跑几个这样的无盘站，有啥办法快速复制？
    - A8: 
        - $ virt-clone -o leisure-00 -n leisure-01 --auto; 
        - 启动 leisure-01；修改主机名： hostname leisure-01; setup-hostname leisure-01; 
        - 运行 .b 备份；shutdown guest； 
        - $ virsh edit leisure-01 修改 apkovl 文件路径
  - Q9: 我忘记当前机器启动的 apkovl 是哪个文件了？
    - A9:  查看 /proc/cmdline 里的 apkovl= 后面的值

