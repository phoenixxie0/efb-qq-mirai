参考链接：

1.[efb-telegram-master配置文件示例](https://github.com/ehForwarderBot/efb-telegram-master/blob/master/readme_translations/zh_CN.rst#编写配置文件)

2.[mirai客户端配置教程](https://github.com/ehForwarderBot/efb-qq-slave/blob/master/doc/Mirai_zh-CN.rst)

3.[efb-QQ-Docker地址](https://hub.docker.com/r/phoenixxie/efb-qq-docker)

4.[efb官方文档](https://github.com/ehForwarderBot/ehForwarderBot/wiki/Modules-Repository)

5.[mcl](https://github.com/iTXTech/mirai-console-loader/releases)

6.[滑块验证解决方案](https://github.com/project-mirai/mirai-login-solver-selenium)

7.[efb-filter-middleware中间件](https://github.com/xzsk2/efb-filter-middleware)

**本文多以图形化界面演示，喜欢命令行的自行操作。**



# 一、下载efb-qq镜像
登录ssh，输入下列代码
```
docker pull phoenixxie/efb-qq-mirai
```
或者直接去群晖检索下载，url地址点击[这里](https://hub.docker.com/r/phoenixxie/efb-qq-mirai)
![image](https://user-images.githubusercontent.com/50565072/177001693-7642f1f1-9b61-436c-95ab-b7da799d816e.png)
![image](https://user-images.githubusercontent.com/50565072/177001698-e7714cde-c806-402e-9abb-50c6c7e7a935.png)


# 二、获取电报机器人token和UID
## 1.创建机器人
TG搜索botfather，认准官方账号
![image](https://user-images.githubusercontent.com/50565072/177001854-a87c40ec-7435-46c2-aef8-1c991b225178.png)

在对话框输入/ 点击
```
/newbot
```

即可创建新机器人
按照指示取名字，就好像你的QQ昵称可以随时修改。

![image](https://user-images.githubusercontent.com/50565072/177001870-21fea189-8f99-4241-bc94-4a07bc5a5b18.png)

按照指示取机器人号，类似你的QQ号，必须用bot结尾，不可修改。

创建成功会收到这样一条信息：

![image](https://user-images.githubusercontent.com/50565072/177001884-343cd9de-3ea4-46e5-af3e-7c12002b37b7.png)

第二处马赛克部分就是我们需要的bot token，这个请保存好，注意不要泄露。
点击第一处马赛克的链接，跳转到你的机器人，点击开始。这样就添加好了你的机器人啦。
## 2.设置机器人
继续对botfather对话
```
/setcommands
```
选择你的bot
粘贴如下命令并发送
```
help - 显示命令列表
link - 将远程会话绑定到 Telegram 群组
chat - 生成会话头
info - 显示当前 Telegram 聊天的信息
unlink_all - 将所有远程会话从Telegram 群组解绑
update_info - 更新当前群组名称和头像，和QQ同步
extra - 获取更多功能
rm - 撤回某条消息。和QQ的撤回时间是一样的，具体使用为回复要撤回的内容，发送 /rm
extra - 掉线重新登录或强制刷新对话列表
```
与botfather对话
```
/setjoingroups  
```
选择enable，来允许您的 bot 加入群组。


```
/setprivacy 
```
选择disable，来禁用隐私限制，以使其能读取群组内的所有消息。

还可以在botfather处给你的机器人添加头像、修改昵称、修改描述。

## 3.获取UID
（1）如果你是plus messager用户，直接点开设置，在个人资料卡就能直接看到id。

（2）常规获取方法：搜索@get_id_bot ，输入/start，就能获得你的ID


# 三、创建容器
注：此处只讲群晖的安装方法，需要纯命令行的，请自行查阅资料依葫芦画瓢。
## 1.在群晖创建一个目录efb-qq
用于存放备份配置等数据，迁移重装的时候只需要备份整个efb-qq目录即可。
目录结构如下

```
efb-qq
├── mcl
└── profiles
    └── default
        ├── blueset.telegram
        │   ├── config.yaml
        ├── config.yaml
        └── milkice.qq
            ├── config.yaml
```

具体配置内容见参考链接，本人贴出的仅供参考，每项代表什么也请自行查阅官方文档说明。

/docker/efb-qq/profiles/default/milkice.qq/config.yaml

```
Client: mirai
mirai:
  qq: 123456789         # 这里换成登录的 QQ 号
  host: "127.0.0.1"       # Mirai HTTP API 监听地址，一般是 127.0.0.1
  port: 8080              # Mirai HTTP API 监听端口，一般是 8080
  verifyKey: "123456790" # 这里填入在配置 Mirai API HTTP 时生成的 verifyKey，暂时不填，之后来补充
```


/docker/efb-qq/profiles/default/blueset.telegram/config.yaml

```
token: "00000000:AAAAAAAAAA" #引号内请替换为自己的bottoken
admins:
  - 111111111 #替换为自己的Telegram UID 
request_kwargs:                         #不需要请删除第4-7行代码。支持添加代理文件，HTTP和SOCKS5均支持，具体格式请自行查阅 https://github.com/ehForwarderBot/efb-telegram-master/wiki/Network-Configuration-and-Proxy
    read_timeout: 6
    connect_timeout: 7
    proxy_url: http://XXX.XXX.XXX:端口号/
#实验性功能 我照抄wechat的
flags:
  chats_per_page: 20 #选择/ chat和/ link命令时显示的聊天次数。过大的值可能导致这些命令的故障
  network_error_prompt_interval: 100 #每收到n个错误后再通知用户有关网络错误的信息。 设置为0可禁用它
  multiple_slave_chats: true #默认true #将多个远程聊天链接到一个Telegram组。使用未关联的聊天功能发送和回复。禁用以远程聊天和电报组一对一链接。
  prevent_message_removal: true  #当从通道需要删除消息时，如果此值为true，EFB将忽略该请求。
  auto_locale: true #自动从管理员的消息中检测区域设置。否则将使用在环境变量中定义的区域设置。
  retry_on_error: false #在向Telegram Bot API发送请求时发生错误时无限重试。请注意，这可能会导致重复的消息传递，因为Telegram Bot API的响应不可靠，并且可能无法反映实际结果
  send_image_as_file: false #将所有图片消息以文件发送，以积极避免 Telegram 对于图片的压缩。
  message_muted_on_slave: "mute" #normal:作为普通信息发送给Telegram silent:发送给Telegram作为正常消息，但没有通知声音 mute:不要发送给Telegram
  your_message_on_slave: "silent" #在从属通道平台上收到消息时的行为。这将覆盖message_muted_on_slave中的设置。
  animated_stickers: true #启用对动态贴纸的实验支持。注意：您可能需要安装二进制依赖 ``libcairo`` 才能启用此功能。
  send_to_last_chat: true #在未绑定的会话中快速回复。enabled：启用此功能并关闭警告。warn：启用该功能，并在自动发送至不同收件人时发出警告。disabled：禁用此功能。
```


/docker/efb-qq/profiles/default/config.yaml

中间件有不少，但需要的安装环境、文件、配置，请查询官方文档。目测QQ只有下面这一个可以用。本文也有部分举例描述，可以参考。
```
master_channel: blueset.telegram
slave_channels:
- milkice.qq
middlewares:     #新手小白待阅读完全文后再按需添加，否则启动会报错。
#  - xzsk2.filter #根据自己的情况决定是否启用[使用参考]https://github.com/xzsk2/efb-filter-middleware
```

## 2.创建容器
在群晖的docker套件里面双击下载好的镜像文件。
创建容器，点击高级设置。
![image](https://user-images.githubusercontent.com/50565072/177002310-864feedf-ca10-47de-b981-5c5459060a53.png)

卷→添加文件夹。
将对应目录挂载到/root/.ehforwarderbot/profiles/default/和/root/mcl即可。
非常建议挂载/mcl文件夹。因为这里保存的是mcl文件和🐧端的登录信息，如果docker image更新，且你不是挂载的这个文件夹。那么你将丢失你的登录信息，再次登录则需要重新验证。
![image](https://user-images.githubusercontent.com/50565072/177002298-eb9d7529-ce4a-4f7f-bd40-45cd20c4d932.png)

# 四、登录QQ
## 1.安装mcl
运行一次docker，查看挂载的mcl文件夹是否产生了如下文件。
![image](https://user-images.githubusercontent.com/50565072/177002325-c6d2c08e-0f1b-496e-a1ed-511b013e82c9.png)

若否，查看docker日志。如果提示连接github失败、解压失败等报错，请手动下载[mcl](https://github.com/iTXTech/mirai-console-loader/releases)，压缩包放置于/docker/efb-qq/mcl/文件夹内，不要解压。
![image](https://user-images.githubusercontent.com/50565072/177002345-cbd1e3c5-d0e0-4c31-a891-391d4cfea709.png)


再次重启docker，观察日志是否正常，文件夹是否产生，如果没有请再次重启。
## 2.填写mcl配置文件并启动
填写并保存\docker\efb-qq\mcl\config\net.mamoe.mirai-api-http\settings.yml，具体说明查看[mirai客户端配置教程](https://github.com/ehForwarderBot/efb-qq-slave/blob/master/doc/Mirai_zh-CN.rst)。

```
adapters:
  - http
  - ws
## 是否开启认证流程, 若为 true 则建立连接时需要验证 verifyKey
## 建议公网连接时开启
enableVerify: true
verifyKey: 124567890  #自己随便填写一个，请务必和/docker/efb-qq/profiles/default/milkice.qq/config.yaml处的verifyKey同步
## 开启一些调式信息
debug: false
## 是否开启单 session 模式, 若为 true，则自动创建 session 绑定 console 中登录的 bot
## 开启后，接口中任何 sessionKey 不需要传递参数
## 若 console 中有多个 bot 登录，则行为未定义
## 确保 console 中只有一个 bot 登陆时启用
singleMode: false
## 历史消息的缓存大小
## 同时，也是 http adapter 的消息队列容量
cacheSize: 4096
## adapter 的单独配置，键名与 adapters 项配置相同
adapterSettings:
  ## 详情看 http adapter 使用说明 配置
  http:
    host: localhost
    port: 8080
    cors: ["*"]
  
  ## 详情看 websocket adapter 使用说明 配置
  ws:
    host: localhost
    port: 8080
    reservedSyncId: -1
```

打开ssh输入如下命令

```
docker exec -it efb-qq ash
cd /root/mcl
./mcl -u
```
会出现一些报错，属于正常现象。
![image](https://user-images.githubusercontent.com/50565072/177002724-fa47d1d8-a32a-4a34-b97d-e1f2dcc950fe.png)

## 3.登录账号
根据页面提示进行登录账号的设置。有什么不懂的输入 ？ ，查看提示。

```
#登录设备可以在<ANDROID_PHONE, ANDROID_PAD, ANDROID_WATCH 三选一>
/login QQ号 QQ密码 ANDROID_PAD  #登录命令，可修改登录设备
#下面两条命令如果需要设置自动登录，都要输
/autoLogin add  QQ号 QQ密码
/autoLogin setConfig QQ号 protocol ANDROID_PAD  #可修改登录设备
```
运行./mcl -u登录QQ号会提示需要滑块验证，然而TxCaptchaHelper不能用，请移步[滑块验证解决方案](https://github.com/project-mirai/mirai-login-solver-selenium)中的方法2。照做。通过滑块后在mcl回输需要的参数，会产生一个网址，浏览器打开需要使用手机QQ扫码。扫码成功后输入任意字符进行登录，手机会提示QQHD版已登录。


注意事项：

1.不要偷懒，必须是安卓手机&windows版的chrome，不要试图用任何的非官方版本蒙混过关！

2.打开inspect后弹出来的devtools为空白或者404，并且你遵照了注意事项1，请全局科学上网试试。

3.验证码地址在此处
![image](https://user-images.githubusercontent.com/50565072/177025756-82d104d5-1c6e-4304-8105-9528959562bd.png)

# 五、登录后玩法
## 1.分组
登录后机器人会开始帮你接收信息，然而不管是群组还是私聊，都会推送信息到这一个机器人，信息非常繁杂，不利于辨认，所以很有必要进行分组。
###### （1）创建群组

![image](https://user-images.githubusercontent.com/50565072/177025778-080408a1-2922-46d6-9923-e4b0159c4a83.png)


群组名字设置：如果是单个私聊或者单个群聊，随便设置一个名字，之后可以通过机器人命令同步信息，不用自己挨个设置。如果是想归类，一个群组关联很多聊天对话，就按需设置。例如：“游戏”、“同事”。

记得每个群组都必须把自己创建的机器人拉进群。

###### （2）进行筛选分组
在机器人对话界面操作：
可以针对已经给你发送信息的账户，直接左滑回复，输入/link，发送，选择link，然后选择你创建好的群组即可。
一个群组可以link多个微信账户，达到分组功能。

![image](https://user-images.githubusercontent.com/50565072/177025791-6439baa6-4e5f-4b00-afb4-97b9b30ed5cf.png)


###### （3）更新群组信息
当你的群组只绑定了一个微信私聊或者群组时，可以在群组中输入/update_info，即可自动同步QQ头像、昵称、群组成员（在简介中）。这项功能需要给机器人管理员权限。
## 2.中间件设置
本文只举例一个中间件，其余的还请自己查阅官方链接。不少中间件只是适用于微信，不适用于QQ。不需要启动的中间件直接在最前面加上#注释掉即可。
###### xzsk2.filter：信息过滤

[efb-filter-middleware中间件](https://github.com/xzsk2/efb-filter-middleware)

新建一个文件config.yaml，位置在/docker/efb-qq/profiles/default/xzsk2.filter。没有的文件夹自己创建。

```
version: 3.46   #随便写
match_mode: fuzz  
#fuzz是关键字命中即可匹配；exact是需要完整词组精确匹配
work_mode:
        - black_persons   #黑名单好友，过滤他的信息。如果你不想漏收私聊信息，也一定要启用这个。
        - white_groups    #白名单群组，仅接受列表内群组的信息
#white_persons:
#        - libai
white_groups:
        - 1234
        - "*"
        #特殊字符需要打引号
black_persons:   #如果你不想漏收私聊信息，也一定要启用这个。
        - nopppppppp   #如果没有想过滤的人，就填一个好友里面没有的名字吧
#black_groups:
#        - testsyou
```
在/docker/efb-qq/profiles/default/config.yaml中添加下列代码，保存并重启docker，日志如无报错正常识别运行中间件则成功。
```
- xzsk2.filter   
```
![image](https://user-images.githubusercontent.com/50565072/177003098-3154b5d0-4b7f-4824-92b5-b55ab293c1d6.png)



该docker已经内置此中间件，无需安装。
如没有安装则在容器内运行下列代码。
```
apk update
apk add git
pip3 install git+https://github.com/xzsk2/efb-filter-middleware
```
