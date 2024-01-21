# トピック
ネットワーク基礎

### 課題に対しての学習内容

3 ネットワーク基礎
3-1 ネットワークとは
ネットワークとは、コンピューター同士が通信するための環境や設備のことです。
この章ではコンピューターの宛先を示すIPアドレスやサーバーの遠隔操作の方法について学びます。

3-2 IPアドレスとは
IPアドレスとは、ネットワークにおけるコンピューターの住所のようなものです。
ネットワークに接続されているコンピューターは必ずIPアドレスを持っていて、通信をする際には必ずIPアドレスを指定します。

※ なお、IPアドレスの規格には旧来のIPv4と、新しいIPv6があります。IPv6は徐々に普及しつつありますが、まだまだIPv4が主流です。そのためこの章ではIPv4のみの説明とします。

グローバルIPアドレスとプライベートIPアドレス
IPアドレスにはグローバルIPアドレスとプライベートIPアドレスがありますが、その前にネットワークについてもう少し確認しておきましょう。
まず、ネットワークには大きく分けて外と内があります。外のネットワークとはインターネットのことで、内のネットワークとはLAN（例えばあなたの自宅内のネットワーク）のことです。それぞれのネットワークは分離されており、直接通信することはできません。通常はゲートウェイと呼ばれる中継機を通って接続します。

話をIPアドレスに戻すと、インターネットで使われるのが「グローバルIPアドレス」でLANで使われるのが「プライベートIPアドレス」です。

ローカルPCのIPを確認
ここでは手元のPCのIPアドレスを確かめる方法について紹介します。

まずグローバルIPアドレスですが、こちらのサイトにアクセスすることでグローバルIPアドレスが確認できます。

IP確認(PC)

また、同一のLANに属していれば通常は同じグローバルIPアドレスを使用します。
試しに同じWi-Fiに接続しているスマホから確認すると同じグローバルIPアドレスを使用しているのが分かります。
IP確認(スマホ)

実は、LAN内のPCやスマホはグローバルIPアドレスを持っていません。
ここで表示されているグローバルIPアドレスはゲートウェイ（自宅にあるルータやモデムと呼ばれるもの）が持っているもので、PCやスマホはインターネットにアクセスする際にゲートウェイのグローバルIPアドレスを借りることによってインターネットで通信することができるのです。これは会社や学校などのLANからインターネットにアクセスする際も同様です。

次にプライベートIPアドレスを確認してみましょう。
まず、networksetup -listallhardwareportsというコマンドを使ってネットワークハードウェアを確認します。今回の場合Wi-Fiを使用しているので、en0というデバイスにプライベートIPアドレスが割り当てられているはずです。

fuku@fukunoMacBook-Air ~ % networksetup -listallhardwareports

Hardware Port: Ethernet Adaptor (en3)
Device: en3
Ethernet Address: 1e:00:ea:1e:4d:28

Hardware Port: Ethernet Adaptor (en4)
Device: en4
Ethernet Address: 1e:00:ea:1e:4d:29

Hardware Port: Wi-Fi
Device: en0
Ethernet Address: 50:ed:3c:04:e2:c0

Hardware Port: Thunderbolt 1
Device: en1
Ethernet Address: 36:20:5e:6d:01:00

Hardware Port: Thunderbolt 1
Device: en2
Ethernet Address: 36:20:5e:6d:01:04

Hardware Port: Thunderbolt Bridge
Device: bridge0
Ethernet Address: 36:20:5e:6d:01:00

VLAN Configurations
===================
そして、ifconfig [デバイス名]とコマンドを実行することで、そのデバイスに割り振られたプライベートIPアドレスが確認できます。
今回の場合はinet 192.168.10.103と表示されており、192.168.10.103というプライベートIPアドレスが割り振られていることが分かります。

fuku@fukunoMacBook-Air ~ % ifconfig en0                      
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether 50:ed:3c:04:e2:c0 
	inet6 fe80::819:d834:5775:12a3%en0 prefixlen 64 secured scopeid 0x9 
	inet6 240b:12:2ae1:d300:18b3:f506:1aaa:5d43 prefixlen 64 autoconf secured 
	inet6 240b:12:2ae1:d300:c853:34c7:c414:9cdc prefixlen 64 deprecated autoconf temporary 
	inet 192.168.10.103 netmask 0xffffff00 broadcast 192.168.10.255
	inet6 240b:12:2ae1:d300:944d:11f4:c125:5efb prefixlen 64 deprecated autoconf temporary 
	inet6 240b:12:2ae1:d300:71c5:f3f7:5dcd:bf42 prefixlen 64 deprecated autoconf temporary 
	inet6 240b:12:2ae1:d300:718f:defe:df7c:6a64 prefixlen 64 deprecated autoconf temporary 
	inet6 240b:12:2ae1:d300:87a:dc64:f549:c8ae prefixlen 64 deprecated autoconf temporary 
	inet6 240b:12:2ae1:d300:3d10:f4b4:7133:2309 prefixlen 64 autoconf temporary 
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active
ちなみに同一のLANに属していればプライベートIPアドレスを使った通信をすることができます。
例えばPCでRailsを立ち上げていれば、同一LANに接続しているスマホからhttp://[プライベートIP]:3000とすることでアクセスすることができます（なお、サーバー起動時に-b 0.0.0.0のオプションが必要です）。

※ この写真では192.168.10.114のプライベートIPアドレスを使っています。
スマホからRailsにアクセス

IPアドレスの形式
※ こちらのwebツールでIPアドレスの変換が行えます

IPアドレスには、どのネットワークに属しているかという「ネットワーク部」と、ネットワーク内の端末を識別するための「ホスト部」という情報に分けられます。そして、その表記方法として「サブネットマスク」と「CIDR」の２つがあります。
しかしそれらの表記方法を説明する前にIPアドレスを2進数で考えるところから説明します。

IPアドレスと32ビットのデータ
例えば192.168.10.104というIPアドレスがありますが、これは10進数で表記されています。
これを2進数で表記すると11000000.10101000.00001010.01101000となります。
このようにIPアドレスは本来32ビットのデータであり、8ビットずつドットで区切って表記します。

# IPアドレス（10進数）
192.168.10.104

# IPアドレス（2進数）
11000000.10101000.00001010.01101000
サブネットマスク表記について
では、サブネットマスクについて説明します。
IPアドレスは2進数で表記した時に、先頭からN桁目までの数字が「ネットワーク部」、それ以降が「ホスト部」を示しており、ネットワーク部はどのネットワークに属しているか、ホスト部はネットワーク内のどの端末かを示しています。

例えばスマホのサブネットマスクを確認してみると次のようになっています。
サブネット確認

この情報からネットワーク部を調べるには、IPアドレスとサブネットマスクを2進数に変換する必要があります。

ip-address 11000000.10101000.00001010.01101000
subnetmask  11111111.11111111.11111111.00000000
サブネットマスクは先頭から24桁までが1となっています。
これはIPアドレスの先頭から24桁までがネットワーク部であり、それ以降がホスト部であることを示しています。

つまり、ネットワーク部とホスト部を分ける表示すると以下のようになります。

# ネットワーク部
11000000.10101000.00001010.00000000 # 2進数
192.168.10.0 # 10進数

# ホスト部
00000000.00000000.00000000.01101000 # 2進数
0.0.0.104 # 10進数
CIDR表記について
サブネットマスクについては分かったかと思いますが、しかし一つ疑問に思うことがあります。
先頭からN桁目までがネットワーク部ということであれば、わざわざ小難しい2進数の表記を使わなくても、N桁という情報だけが分かれば良さそうです。
そこで使われるのがCIDRです。
先程と同じIPアドレスをCIDR表記にすると次のようになります。

# CIDR表記（10進数）
192.168.10.104/24
サブネットマスクと全く同じことをしていますが、CIDRの方がスッキリとした表記になります。

3-3 DNS
3-3-1 DNSとは
IPアドレスの節で、コンピューター同士が通信をする際には必ずIPアドレスを指定すると言いましたが、IPアドレスを知らなくてもドメイン名をブラウザに打ち込めばサイトにアクセスすることができます。
実はコンピューターは私たちの見えないところでドメイン名をIPアドレスに変換しているのです。その仕組みのことをDNSと言い、ドメイン名からIPアドレスを索引してくれるサーバーのことをDNSサーバーと言います。
また、ドメイン名からIPアドレスを索引することを名前解決と言います。

Macには名前解決するためのコマンドラインツールであるnslookupが標準インストールされています。
試しにnslookup github.comと実行してみると、GitHubにアクセスする際に必要なIPアドレスが索引できます。

fuku@fukunoMacBook-Air ~ % nslookup github.com
Server:		240b:12:2ae1:d300:8222:a7ff:fe24:3dc
Address:	240b:12:2ae1:d300:8222:a7ff:fe24:3dc#53

Non-authoritative answer:
Name:	github.com
Address: 52.192.72.89
※ 但し、IPアドレスで直接サイトにアクセスすることはサーバー側の設定で許可されていないケースは多いです。また、IPアドレスからドメイン名にリダイレクトさせるケースもあり、その際にブラウザが警告を発したりします（GitHubがまさにそう）。

3-3-2 DNSの仕組み
DNSは一つのDNSサーバーによって実現しているのではなく、世界中にある複数のDNSサーバーが連携して成り立っています。
詳細な説明は省きますが、DNSサーバーは自身で名前解決できない場合に他のDNSサーバーへ問い合わせるようレスポンスを返し、それを繰り返すことで名前解決できるDNSサーバーに辿り着く仕組みになっています。

3-4 ポート
3-4-1 ポートとは
コンピューターはサーバー（APサーバーやDBサーバーなど）を立ち上げる際に、リクエストの受け口となる玄関を用意しておく必要があります。それがポートと呼ばれるものです。
例えばローカルPCで起動しているRailsにリクエストを送る際はlocalhost:3000というようなURLを使っていたかと思いますが、これはlocalhostの3000番ポートを指定しているのということです。
ポートは数字で指定している必要があり、一つのポートで一つのサーバーを立ち上げることができます。

※ 余談ですがlocalhostもドメインであり127.0.0.1というIPアドレスを指しています。このIPアドレスは「ループバックアドレス」と呼ばれ、自分自身（ローカルPC）を指す特殊なIPアドレスです。

3-4-2 主なサービスのポート
サービスによってよく使われるポートが決まっている場合があります。
ここではよく使われるポートについて一例を紹介したいと思います。

ポート番号	サービス（プロトコル）	内容
20	FTP（データ）	FTPによるデータ送信
21	FTP（制御）	上記FTPの制御
22	SSH	サーバーの遠隔操作（暗号化）
23	Telnet	サーバーの遠隔操作
25	SMTP	メール送信
53	DNS	DNS索引
80	HTTP	ホームページ閲覧
110	POP3	メール受信
119	NNTP	ニュース用
123	NTP	時間の取得・調整用
143	IMAP	メール通信
443	HTTPS	ホームページ暗号化閲覧
587	Submission	メール送信
これらのポートは「よく使われる」という意味で「ウェルノウンポート(well known port)」と呼ばれます。

3-5 SSH
3-5-1 SSHとは
SSHとはネットワークに接続された機器（サーバー）を遠隔操作するためのサービスです。
通常、サーバーなどは地理的に離れた所（データセンターなど）に設置しており直接操作することができません。
そこでSSHで接続することでサーバーを遠隔操作することが可能になります。

また、遠隔操作するための似たようなサービスとしてtelnetがあります。
従来は、telnetを使ってリモート通信が行われていましたが、通信内容を暗号化せず送信してしまうため、機密性の高い情報を盗聴されるリスクがありました。
SSHではパスワードや公開鍵で通信内容を暗号化することで安全な通信を実現しています。なお、安全性の高さから公開鍵を使った方式が推奨されています。

3-5-2 SSHのやり方
SSHで他のコンピューターに接続（ログイン）するにはsshコマンドを使います。

# IPアドレス(111.222.333.444)を指定してログイン
ssh 111.222.333.444

# ホスト名(example.com)を指定してログイン
ssh example.com

# 22以外のポート番号を使いたい場合
ssh 111.222.333.444 -p 1234

# ユーザー名（runteq）を指定してログイン。どちらも可。
ssh runteq@111.222.333.444
ssh -l runteq 111.222.333.444

# リモートマシンでコマンド（例:lsコマンド）を実行
ssh 111.222.333.444 ls

# 秘密鍵を指定して、リモートマシンにsshでログイン
# ※ 鍵の場所は環境に合わせて変えてください
ssh -i ./.ssh/id_rsa runteq@111.222.333.444