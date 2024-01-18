# 高度な機能
基本機能のみで作られたサービスでは、就活で目を引くようなコードになりづらい傾向があります。そこで、本章ではユーザビリティを向上させ、就活でも評価されるコードを書ける機能をいくつか紹介します。  

## マルチ検索・オートコンプリート
概要  
食べログの検索フォームのような、様々なカラムから検索可能な検索フォームです。1文字入力するたびに、候補が表示されるため、ユーザーの入力手間を減らし、入力ミスを減らすことができます。  

使用技術・ライブラリ
- 0Stimulus Autocomplete（Rails7 ）
https://github.com/afcapel/stimulus-autocomplete
- JQuery
https://github.com/xpeppers/rails-autocomplete

## 通知
概要  
FacebookやTwitterでもおなじみの通知機能があります。その人に関連するお知らせをリアルタイムで通知することで、ユーザーの行動を促し、アクティブ率を向上させます。  

使用技術・ライブラリ
- WebSocket通信・ActionCable（Rails標準）

## LINE通知
概要  
Webプッシュはまだ普及しておらず、アプリのプッシュ通知を利用したい方には、LINEプッシュ通知がおすすめです。簡単な連携で、自分の好きなタイミングにLINEを通じてプッシュ通知を行うことができます。  

使用技術・ライブラリ
- LINE Messaging API
- LINE Messaging API SDK for Ruby
https://github.com/line/line-bot-sdk-ruby

## レコメンド
概要  
投稿されたまたは事前に用意されたコンテンツと類似したコンテンツを推奨する機能をレコメンドと呼びます。代表的なアルゴリズムとして、協調フィルタリングとコンテンツフィルタリングがあります。協調フィルタリングは、ユーザの行動や嗜好データを元に類似度を算出し、コンテンツベースフィルタリングは、コンテンツの数値化された特徴や評価を元に類似度を算出します。  

使用技術・ライブラリ
- Amazon Personalize
https://docs.aws.amazon.com/ja_jp/personalize/latest/dg/what-is-personalize.html  
AWSが提供する機械学習の知識がなくても、個々のユーザー向けにリコメンデーションをリアルタイムで提供できるサービスです。
- GCP Recommendations AI
https://cloud.google.com/recommendations?hl=ja  
Recommendations AIは、Google Cloud Platformが提供するレコメンドエンジンであり、Googleの機械学習アルゴリズムを利用しています。
- アルゴリズム
協調フィルタリングやコンテンツベースフィルタリングは、一般的にアルゴリズムが公開されているので、RubyやPythonで独自に実装することも可能です。  

## チャット
概要  
FacebookメッセンジャーやSNSなどには、チャット機能が必ずついています。現在では、WebSocketを用いることで、リアルタイムでやり取りが可能となっています。コツさえ掴めば、比較的簡単に実装できます。ダイレクトメッセージのようなチャット機能を実装することで、ユーザー同士のコミュニケーションを活性化させることができるかもしれません。  

使用技術・ライブラリ
- WebSocket
https://ja.wikipedia.org/wiki/WebSocket
- ActionCable（Rails標準）
https://railsguides.jp/action_cable_overview.html

## 画像加工・合成
概要  
アップロードされた画像のサイズを揃えることで、表示を統一化し、文字を合成することでOGPをより分かりやすくすることができます。これにより、ユーザビリティを向上させることができます。  

使用技術・ライブラリ
- ImageMagick
https://imagemagick.org/index.php  
ImageMagick（イメージマジック）は画像を操作・加工出来るソフトウェア（ツール）です。
- RMagick
https://github.com/rmagick/rmagick  
*RubyからImageMagickを利用できるようにするためのラッパーライブラリがRMagickです。このライブラリを利用することで、Rubyのコードから簡単にImageMagickを操作することができます。CarrierWaveとセットで使われることも多いです。
- MiniMagick
https://github.com/minimagick/minimagick  
RMagickは、大量のメモリを消費するため、省メモリ設計で作られたライブラリであるMiniMagickが代替として利用されることがあります。ただし、MiniMagickは機能が制限されるため、画像加工などの用途によっては、使用できる機能が制限されることがあります。こちらもCarrierWaveとセットで使われることが多いです。
-- Cloudinary
https://cloudinary.com/  
https://cloudinary.com/products/programmable_media  
Cloudinaryは、画像や動画、その他のデジタルアセットを管理、変換・最適化、そして配信まですべてできるサービスです。画像加工のAPIも非常に強力であり、独自の様々な加工を行うことができます。  

## ステップ入力・確認画面
概要  
1つのフォームで入力するには項目が多すぎる場合や、ユーザーの離脱を抑制するために、フォームを複数のステップに分割して入力できるようにすることがあります。また、1つのフォームで入力する場合でも、投稿後に編集できない情報がある場合には、確認画面を挟むことでユーザーに注意を促すなど、登録フォームのユーザビリティを考慮した様々な工夫が必要です。  

## 位置情報
概要  
位置情報や地図の技術は、モバイルサービスにとって必要不可欠な技術の一つです。例えば、住所情報から緯度経度に変換することで、地図上での位置情報を取得したり、スマートフォンのブラウザの機能を利用して現在の位置情報を取得し、住所に変換したり、特定の位置との距離を計算することができます。これらのデータを活用し、ユーザーの行動と連携させることで、より精度の高いサービスを提供することができます。  

使用技術・ライブラリ
- Google Maps Platform
https://mapsplatform.google.com/intl/ja/  
Google Maps Platformは、Googleが提供する地図・位置情報関連のサービス群の総称です。Google Maps Platformには、Google Maps APIやGoogle Places APIなどが含まれ、これらを利用することで、ウェブサイトやアプリにカスタマイズされた地図や位置情報を組み込むことができます。また、Google Maps Platformは、ルート検索や経路最適化など、ビジネスに役立つ機能も提供しています。
- Geocoder
https://github.com/alexreisner/geocoder  
ジオコーディングを行うためのRubyのgemとして、多くの開発者から利用されているものに「geocoder」というものがあります。このgemを使用することで、住所や地名から位置情報を取得することができます。また、逆に位置情報から住所や地名を取得することもできます。

## キューとバックグラウンド処理
概要  
バックグラウンド処理を利用することで、ユーザーが操作した処理に対して、その場ですぐに処理が完了するのではなく、キューに貯めておいてバックグラウンドで処理することができます。このようにすることで、ユーザーが待ち時間を減らし、スムーズな利用体験を提供することができます。特に、Web APIへの問い合わせや長時間かかる処理などはバックグラウンドに処理をまわすことがおすすめです。  

使用技術・ライブラリ
- ActiveJob（Rails標準）
https://railsguides.jp/active_job_basics.html  
Active Jobは、ジョブを宣言し、それによってバックエンドでさまざまな方法によるキュー操作を実行するためのフレームワークです。

## バックエンド
ActiveJobにはキューイングバックエンドに接続できるアダプタが必要となります。以下それぞれのアダプタについて解説いたします。  
- Sidekiq
https://github.com/sidekiq/sidekiq
- キューストレージ：Redis
マルチスレッドで動くので処理速度が速く、メモリ効率も高い
- Resque
https://github.com/resque/resque
- キューストレージ：Redis
シングルスレッド・マルチプロセスで動く為、メモリリークなどは起こしづらい
- Delayed Job
https://github.com/collectiveidea/delayed_job
- キューストレージ：RDBMS
ストレージにRDBMSを使用するため、導入が容易