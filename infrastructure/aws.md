# トピック
AWSでインフラ構築をしてみる

## 目標
AWSでインフラ構築をする

### 課題に対しての学習内容

#### AWSのアカウント作成
- AWSアカウント作成  

※アカウント作成の際にクレジットカード情報が必要なので準備しておきましょう(デビットカードも可)！  
公式に丁寧な手順書があるので、これに従い作成してください！  
完了後は画面に従いAWSマネジメントコンソール画面(以下コンソール画面)を開き、次の項目(ルートアカウントの注意点)に進んでください！  
[AWS アカウント作成の流れ](https://aws.amazon.com/jp/register-flow/)

- ルートアカウントの注意点

アカウントを作成できたと思います！  
これでAWSのクラウドサービスを利用できますが、今ログインしているアカウントはルートアカウントというすべてのサービスの操作が可能であり、またアクセス権限を変更することができません。  
そのため通常はこのルートアカウントは保護し、利用するサービスへの制限を定義したユーザーを作成してそのユーザーアカウントでAWSを利用していきます。  
そのためのサービスが次で作業するIAMになります。  

#### IAMユーザーの作成
- IAMグループ作成

コンソール画面の上部にある検索フォームからIAMを検索して、IAMの画面へ移動します。  
左メニュー内の「個のユーザーグループ」から「グループ作成」に進んでください。  
下記内容で作成してください。  

グループ名：任意のものでOK  
アクセス許可ポリシーをアタッチ：検索窓で「AdministratorAccess」を検索しチェック  
IAMユーザー作成  

上記と同じく、IAMのコンソール画面の左メニュー内の「ユーザー」から「ユーザーを追加」に進んでください。  
下記内容でユーザを作成します。  
ユーザ名：任意のものでOK  
AWS 認証情報タイプを選択：パスワード - AWSマネジメントコンソールへのアクセス  
コンソールのパスワード：カスタムパスワード、任意のパスワードを入力してください  
パスワードリセットが必要：チェックなし  
アクセス権限：先ほど作成したIAMグループにチェック  
タグの追加：なし  
作成が終わったら作成したIAMユーザーでコンソール画面にログインできるか確認してみましょう！  
この段階で「rootアカウント」「作成したIAMユーザーアカウント」の2つがあるかと思います。  
基本的にAWS上での作業はrootアカウントは利用せずに、新しく作成したIAMユーザーアカウントを利用して進めていきます。  

- budgets設定

※budgets設定はAWSの権限上、rootアカウントを利用して進めます。  
AWSは無料枠で利用できるクラウドサービスもありますが、基本的には有料のサービスになっております。  
そのため意図しない課金が出ないように予算のアラート設定をしましょう。  
コンソール画面の検索窓から「budget」と検索して「AWS Budgets」のサービスを開き、「予算を作成」に進みます。  
下記の内容で作成していきます。  

予算タイプを選択  
予算タイプ：コスト予算  
予算名：任意の名前  
予算額を設定(ここは任意のものでも大丈夫です)  
間隔：月別  
予算有効日：定期予算  
開始月：現在の年月  
予算設定方法：固定  
予算額：10.00  
予算のスコープ：すべてデフォルト設定でokです  
閾値：任意の%  
トリガー：実績
Eメールの受信者：受信するメールアドレス  
アクションのアタッチ  
そのまま  

#### インフラの構築
- クラウドサーバーを構築する、地域(リージョン)を指定
AWSは全世界で利用されており、各地域でホスティングされています。  
画面右上のアカウント名の隣のプルダウンから「東京」を選んでください。  

用語  
ホスティング  
サーバーを借りること、ここではサーバーを利用されている(借りられている)という意味になります  

VPC  
VPC(Virtual Private Cloud)とは、AWS上に作成できるプライベートなネットワークの領域です。 
初期段階で各リージョンごとでデフォルトのVPCなどが設定されていますので、今回はそちらを利用していきます。  
コンソール画面の検索窓から「VPC」を検索し進んでください。  
「VPCダッシュボード」から確認してみましょう。  

それぞれNameタグが空になっているので、把握できるよう命名しておきましょう！  

VPC  
runteq-vpc  

サブネット  
runteq-subnet-1a  
runteq-subnet-1c  
※アベイラビリティゾーンごとで命名しています  

インターネットゲートウェイ  
runteq-igw  

ルートテーブル  
runteq-rt  

用語  
アベリラビリティゾーン(AZ)  
これはサーバーを物理的に置いているデータセンターについて、各リージョンで地域毎にデータセンターを分けた集合の単位のこと  

- ルートテーブルをサブネットに紐付け  
デフォルトで設定されているルートテーブル(runteq-rt)をプライベートサブネット（runteq-subnet-1a, runteq-subnet-1c）と紐づけます。  
紐付けたいルートテーブルを選択し、「サブネットの関連付けを編集」から下記の2つのサブネットで紐付けます。  

runteq-subnet-1a  
runteq-subnet-1c  

- セキュリティグループの作成

VPC内の通信の許可/拒否の設定をするためにセキュリティグループを設定することができます。  
今回はアプリケーションサーバーとデータベースの通信設定を作成していきましょう！  

手順
コンソール画面の検索窓から「VPC」を検索し進んでください。  
左メニューの「セキュリティグループ」を選択し、右上「セキュリティグループを作成」をクリックします。  
下記の設定で2つ作成します。  

アプリサーバー接続用  
基本的な詳細  
セキュリティグループ名：web-sg  
説明：web-sg  
VPC：runteq-vpc  
インバウンドルール(2つ)  
1つ目  
タイプ：HTTP  
リソースタイプ(画面によってはタイプ)：Anywhere-IPv4  

2つ目  
タイプ：ssh  
リソースタイプ(画面によってはタイプ)：Anywhere-IPv4  
アウトバウンドルール：そのまま  
タグ：なしでok  
※今回はクラウドサービスでアプリを動かすこと目的なので、HTTPのみの設定になっております  

データベース接続用  
基本的な詳細  
セキュリティグループ名：db-sg  
説明：db-sg  
VPC：runteq-vpc  
インバウンドルール  
タイプ：MYSQL/Aurora  
ソース：カスタム web-sg(先ほど作成したセキュリティグループ)  
アウトバウンドルール：そのまま  
タグ：なしでok  
データベースはアプリサーバーからのアクセスのみ許可したいので、インバウンドルールはweb-sgのグループIDを指定します  

AWSにおけるネットワーク構築については以上となります。  
次はRDSとEC2インスタンスの作成に移ります。  

#### EC2(Elastic Compute Cloud)
EC2はクラウドでサーバーの構築や運用ができるサービスです。  
アプリを動かすサーバーを作っていきましょう！  
コンソール画面の検索から「EC2」を検索してEC2の画面へ進み、左メニュー内の「インスタンス」を選択してください。  
右上の「インスタンスを起動」をクリックし、下記に従い設定していきます！  

Amazonマシンイメージ(AMI)  
Amazon Linux 2 AMI (HVM) - Kernel 5.10, SSD Volume Type(64ビット x86)  
インスタンスタイプの選択  
t2.micro  
インスタンスの詳細の設定  
インスタンス数：1  
ネットワーク：runteq-vpc  
サブネット：runteq-subnet-1a  
ストレージの追加：デフォルト  
タグの追加  
キー：Name  
値：runteq-web  
セキュリティグループの設定  
セキュリティグループの割り当て：既存  
セキュリティグループID：web-sg  
最後に「起動」をクリックすると、キーペアの作成が出るので、下記の設定でキーペアを作成してダウンロードをしてください。  
こちらはEC2にログインする際に必要なので、自分のPCに保存して、外部に出さないようにしましょう！  

新しいキーペアの作成  
キーペアのタイプ：RSA  
キーペア名：runteq-key  

- EC2にログイン
EC2へログインするために、ダウンロードしたキーペアを移動させます。  
ダウンロードしたrunteq-key.pemを~/.sshに移動させてください。  
移動完了後は、キーへのアクセス権限を設定します。キーがある階層に移動し、下記のコマンドを打ってください。  
`$ chmod 400 runteq-key.pem`

最後にsshログインのコマンドを取得します。  
EC2のコンソール画面で作成したインスタンスを選択し、「接続」をクリックします。  
「SSHクライアント」タブをクリックすると、接続のコマンドが出てきますので、ターミナルからそのコマンドを入力します。  

ターミナルで下記のようになればok

[ec2-user@... ~]$

- ElasticIP紐づける
先ほど作成したEC2は停止して再度起動すると、パブリックIPが変わり、毎回sshログイン時は不便になるので、固定のIPを紐付けます。  
EC2のダッシュボードの左メニューから「Elastic IP」に進み、右上の「Elastic IPアドレスの割り当て」から下記の設定で作成していきます。  

ネットワークボーダーグループ：ap-northeast-1a  
パブリックIPのアドレスプール：AmazonのIPv4アドレスプール  
作成後、今のElasticIPをEC2インスタンスに割り当てます。  
右上の「アクション」から「ElasticIPアドレスの関連付け」に進み、先ほど作成したEC2インスタンスに紐付け設定をしてください。  
作成したEC2の概要内にElasticIPアドレスが表示されていればokです！  

#### RDS(Relational Database Service)
RDSはクラウドでリレーショナルデータベースを利用できるサービスです。  
早速作成してきましょう！  

- DBサブネットグループの作成
コンソール画面の検索窓から「RDS」を検索し進んでください。  
まずはDB用のサブネットグループを作成します。  
左メニューの「サブネットグループ」を選択し、右上「DBサブネットグループを作成」をクリックします。  
下記の設定で作成します。  

サブネットグループの詳細  
名前：runteq-subnetgroup  
説明：runteq-subnetgroup  
VPC：runteq-vpc  
サブネットの追加  
アベイラビリティゾーン：ap-northeast-1a, ap-northeast-1c  
サブネット：runteq-subnet-1a, runteq-subnet-1c  

- RDSインスタンスの作成
コンソール画面の検索窓から「RDS」を検索し進んでください。  
左メニューの「データベース」を選択し、右上「データベースを作成」をクリックします。  
下記の設定で作成します。  

データベースの作成方法：標準作成  
エンジンのオプション  
エンジンのタイプ：MYSQL  
エディション：MySQL Community  
バージョン：5.7.xx(最新版)  
テンプレート：無料利用枠  
設定  
DBインスタンス識別子：デフォルト(database-1)  
マスターユーザー名：デフォルト(admin)  
マスターパスワード：任意のもの  
※ここでのユーザ名、パスワードは後ほどアプリ側に設定するので、控えておいてください。  
DBインスタンスクラス：デフォルト  
ストレージ：すべてデフォルト  
可用性と耐久性：デフォルト  
接続  
VPC：runteq-vpc  
サブネットグループ：runteq-subnetgroup  
パブリックアクセス：なし  
VPCセキュリティグループ：既存の選択 db-sg  
アベイラビリティゾーン：ap-northeast-1a  
データベースポート：3306  
データベース認証：パスワード認証  
追加設定  
最初のデータベース名：runteq_db  
その他はそのままでok  

#### EC2内の環境構築
利用パッケージの追加
まずはパッケージをアップデートします。下記のコマンドを打ちます。

[ec2-user@ip... ~]$ sudo yum -y update
EC2の初期状態では最低限のパッケージしかインストールされていないので、利用するパッケージをインストールします。
下記のコマンドを\を含めて全て実行してください。

[ec2-user@ip... ~]$ sudo yum -y install \
git make gcc-c++ patch curl \
openssl-devel \
libcurl-devel libyaml-devel libffi-devel libicu-devel \
libxml2 libxslt libxml2-devel libxslt-devel \
zlib-devel readline-devel \
mysql mysql-server mysql-devel \
ImageMagick ImageMagick-devel \
epel-release
nodejsインストール
次にnode.jsのインストールをします。
まずはnode.jsのパッケージをダウンロードします。

[ec2-user@ip... ~]$ curl -sL https://rpm.nodesource.com/setup_19.x | sudo bash -
次にnode.jsをインストールします。

[ec2-user@ip... ~]$ sudo yum install -y nodejs
下記コマンドでインストールされたか確認しましょう！

[ec2-user@ip... ~]$ which node
/usr/bin/node
yarnインストール
yarnも利用するのでインストールします。
nodejsと同じようにyarnのパッケージをダウンロードします。

[ec2-user@ip... ~]$ curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | sudo tee /etc/yum.repos.d/yarn.repo

yarnをインストールします。

[ec2-user@ip... ~]$ sudo yum -y install yarn
rubyインストール
rubyを利用できるように、rbenvとruby-buildをインストールしていきます。

# rbenvインストール
[ec2-user@ip... ~]$ git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
[ec2-user@ip... ~]$ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
[ec2-user@ip... ~]$ echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
[ec2-user@ip... ~]$ source ~/.bash_profile


# ruby-buildインストールしてrubyをインストール
[ec2-user@ip... ~]$ git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
[ec2-user@ip... ~]$ rbenv install -v 3.1.4
[ec2-user@ip... ~]$ rbenv global 3.1.4
[ec2-user@ip... ~]$ rbenv rehash
[ec2-user@ip... ~]$ ruby -v
ruby 3.1.4p223 (2023-03-30 revision 957bb7cb81) [x86_64-linux]
アプリデプロイ
EC2内にアプリのコードを送ります。
GitHub利用をしてコードをクローンできるようにするため、EC2上で公開鍵と秘密鍵のペアを作成します。

鍵作成
下記のコマンドを参考に公開鍵と秘密鍵を作成します。

[ec2-user@ip... ~]$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ec2-user/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
# 何も入力せずそのままエンター
Enter same passphrase again: 
# 何も入力せずそのままエンター
Your identification has been saved in /home/ec2-user/.ssh/id_rsa.
Your public key has been saved in /home/ec2-user/.ssh/id_rsa.pub.
The key fingerprint is:
~~省略~~
GitHubに公開鍵を登録
GitHubと接続できるように作成した公開鍵を登録します。

[ec2-user@ip... ~.]$ cd .ssh
[ec2-user@ip... .ssh]$ cat id_rsa.pub
# ここに表示された文字列を全てコピーする(ssh-rsaから)
自分のGitHubにログインしSettings->SSH and GPG keys->New SSH keyに進んで登録します。

Title：わかりやすい名前
Key：先ほどコピーした公開鍵
これでEC2とGitHubでSSH通信ができるようになりました。
確認してみましょう！

[ec2-user@ip... ~]$ ssh -T git@github.com
# 下記メッセージが出たらyesを入力する
Are you sure you want to continue connecting (yes/no)?
「Hi GitHubアカウント名....」が出れば接続完了です。

デプロイするアプリの準備
今回はこちらのアプリケーション利用します。
上記アプリケーションをGitHub上で、ご自身のリモートリポジトリにフォークしてください。

GitHubからコードクローン
サーバー上の操作に戻りまして、コードの保存ディレクトリを作成します。

[ec2-user@ip... ~]$ cd /
[ec2-user@ip... /]$ sudo mkdir /var/www/
[ec2-user@ip... /]$ sudo chown ec2-user /var/www/
[ec2-user@ip... /]$ cd /var/www
[ec2-user@ip... www]$ git clone git@github.com:アカウント名/アプリ名.git

※ git@github.com:アカウント名/アプリ名.gitのところは先程のフォークしたリモートリポジトリを参照して適宜修正してください。
本番用のアプリの設定
master.key設定
本カリキュラムで使用するアプリケーションでは特に操作は必要ありません。
（＊本来であれば秘匿情報であるmaskter.keyを手動で設定する必要があります。通常master.keyなどの秘匿情報はGitHub上に掲載しません）

以下、master.keyの設定の一例になります。（本カリキュラムでは操作不要）

- ローカルのmaster.keyの値を習得
- EC2のサーバーに接続して以下のコマンドを実行
  - cd /アプリ名
  - vim config/master.key
    - ローカルのmaster.keyの値を入力・保存
database.ymlの設定
RDS作成した際のdatabase接続設定をします。
下記コマンドでdatabase.ymlを編集しましょう！
vim config/database.yml

default: &default
  adapter: mysql2
  encoding: utf8mb4
  charset: utf8mb4
  collation: utf8mb4_general_ci
  username: 設定したユーザ名
  password: 設定したパスワード
  host: RDSのエンドポイント
  pool: 5
  timeout: 5000

production:
  <<: *default
  database: runteq_production # なんでもOK
gemのインストール
gem list bundlerと打つとbundlerのバージョンが確認できるので打ち込んでみましょう。

[ec2-user@ip... `アプリ名`]$ gem list bundler

***LOCAL GEMS***

bundler (default: 2.3.17)
デプロイで必要なローカルと同じbundlerのバージョンをインストールする必要があります。

[ec2-user@ip... `アプリ名`]$ gem install bundler `ローカルと同じバージョン`
準備ができたのでgemをインストールします。

[ec2-user@ip... `アプリ名`]$ bundle install
※ここでエラーとなりファイルの編集やgemの追加が必要になった場合は、EC2上で作業せずにローカルで作業してpushしたものをEC2上でpullしてください。
リポジトリのソースコードを更新しないと、別環境でデプロイした際に同じ内容のエラーが再発するため注意しましょう！

DB作成
# DBを作成
[ec2-user@ip... `アプリ名`]$ rails db:create RAILS_ENV=production
# テーブル作成
[ec2-user@ip... `アプリ名`]$ rails db:migrate RAILS_ENV=production
※デフォルトではdevelop環境への実施になるので、production環境に対して実施してください

Nginxのインストール
本番環境は開発環境とは異なり、複数のユーザーから大量のアクセスが発生するので、アプリケーションサーバーだけではリクエストを処理しきれません。
そのためにリクエストごとに発生する処理をさばいてくれるwebサーバーが必要になります。
今回はwebサーバーのnginxを利用します。
まずはインストールします。

[ec2-user@ip... ~]$ sudo amazon-linux-extras install nginx1
Is this ok [y/d/N]:を聞かれた場合はyを入力して進んでください。

Nginxの起動
下記コマンドでnginxを起動して、ブラウザでnginxが起動しているか確認します。

[ec2-user@ip... ~]$ sudo systemctl start nginx
EC2に設定したElasticIPをブラウザのアドレスバーに打って以下のnginxのページが表示がされたらokです。
スクリーンショット 2019-10-02 9.04.02.png (168.5 kB)

今はNginxデフォルトのページに飛ばされているのでこれをRailsアプリに飛ぶように設定をします。

Nginxの設定ファイルを作成
Nginxの設定ファイルはインストールした時に生成されています。
/etc/nginx/nginx.confがデフォルトのNginxの設定ファイルです。
新しく設定ファイルを作成して/etc/nginx/nginx.confに読み込ませて設定します。

[ec2-user@ip... ~]$ cd /etc/nginx/conf.d
[ec2-user@ip... conf.d]$ sudo vi runteq-infra.conf
下記を参考にファイルを作成します。
※複数箇所にディレクトリ名を指定する箇所があるので自分のアプリと合わせる必要があるので注意。

error_log  /var/www/アプリ名/log/nginx.error.log;
access_log /var/www/アプリ名/log/nginx.access.log;

client_max_body_size 2G;
upstream runteq-app {
  server unix:///var/www/アプリ名/tmp/sockets/puma.sock fail_timeout=0;
}
server {
  listen 80;
  server_name xxx.xxx.xxx.xxx; # 作成したEC2の ElasticIPアドレス。
  keepalive_timeout 5;
  root /var/www/アプリ名/public;
  try_files $uri/index.html $uri.html $uri @app;
  location @app {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_redirect off;
    proxy_pass http://runteq-app;
  }

  error_page 500 502 503 504 /500.html;
  location = /500.html {
      root /var/www/アプリ名/public;
  }
}
Pumaを起動する
pumaの本番設定ファイルを確認します(ない場合は作成しておきましょう)。
config/puma/production.rb

environment "production"

tmp_path = "#{File.expand_path("../../..", __FILE__)}/tmp"
bind "unix://#{tmp_path}/sockets/puma.sock"

threads 3, 3
workers 2
preload_app!

pidfile "#{tmp_path}/pids/puma.pid"
# stdout_redirect "#{tmp_path}/logs/puma.stdout.log", "#{tmp_path}/logs/puma.stderr.log", true

plugin :tmp_restart
下記で起動させます。

[ec2-user@ip... ~]$ cd /var/www/アプリ名/
[ec2-user@ip... アプリ名]$ RAILS_ENV=production rails assets:precompile
[ec2-user@ip... アプリ名]$ bundle exec puma -C config/puma/production.rb -e production
Nginxを再起動する
Pumaがうまく起動できたらNginxを再起動する。
（※Pumaは起動状態にしておく必要があるので、Puma起動中のターミナルとは別に新しくターミナルを立ち上げて以下を実行してください。）

[ec2-user@ip... アプリ名]$ sudo nginx -s stop
[ec2-user@ip... アプリ名]$ sudo service nginx start
アクセス
もしエラーが発生していた場合はログを確認して修正してみてください。
Railsのログはどこにあるでしょうか、探してみましょう！
そのエラーを解消すればアプリが使えるようになっているはずですね！！

Image from Gyazo

お片付け
クラウドサービスなので、構築内容によっては起動していなくても金額が発生してしまいます。
完了したら、作成した環境を削除しておきましょう。

EC2は停止して削除する。
ElasticIPを「アドレスの関連付けの解除」して、ElasticIPアドレスを解放する。
RDSは停止と削除する。RDSは停止をしても7日後には自動的に起動する仕様なので「削除」までやりましょう。
その他のVPCやらサブネットやらは残したままでもOKです。

- 苦戦したこと
RSDになかなか接続できず、VPCやセキュリティを見直したが問題はなかった  
よくよくチェックすると`database.yml`の一番最下部にproductionのデフォルトでのuserｔｐpasswordが設定されていることによるエラーだった

## 参考サイト
- [参考サイト1](https://www.google.com/?hl=ja)
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)