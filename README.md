#### 欢迎使用 Leisure Linux 制作的 AlpineOS 无盘站虚机

#### x86_64 版本使用说明
  1. git clone 本仓库;  cd Alpine
  2. 运行 ./dl_netboot.sh 来下载需要的内核和 initrd 两个镜像
  3. 把 ./leisure-00.apkovl.tar.gz scp 到本地或者云端的 Web 上，上传后，确保能通过 wget 一个 URL 下载到
  4. 修改 leisure-00.xml 文件的 kernel/initrd 两行内的文件路径，修改 cmdline 中 apkovl 对应的值为以上 URL
  5. 定义虚拟机：virsh define --file leisure-00.xml
  6. 启动虚拟机：virsh start leisure-00
      - 进入 console 查看：virsh console leisure-00
      - root 账号密码： LeisureLinux
      - leisure 账号密码： leisurelinux
      - 登录后，请参考 ~leisure/README.md 


#### FAQ
  - Q1: could not open kernel/initrd file
  - A1: 权限问题，把下载下来的文件路径切换到具有 755 权限的目录下
