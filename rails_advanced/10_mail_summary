# トピック
wheneverによる記事数一覧のメール送信

## 目標
wheneverで毎日am9:00に下記を管理者にメールで送信

公開済の記事の総記事数
・「公開済の記事数: 10件」とメールに集計内容を表示させてください。

昨日公開された記事の件数とタイトル
・「昨日公開された記事数: 5件」とメールに集計内容を表示させてください。
・「タイトル: title_01」と各記事のタイトルをメールに表示させてください。
・対象記事が0件の場合は「昨日公開された記事はありません」と表示してください。

メールの件名には「公開済記事の集計結果」と設定してください。
管理者のメールアドレスにはadmin@example.comを設定してください。
usersテーブルにemailカラムは追加しなくて大丈夫です。
メール本文のViewファイルはerbで作成してください。

## 学習内容
- cron
- whenever
- ActionMailer

### 課題に対しての学習内容
mailerを作成するために下記を実施
```
rails generate mailer Article 
```
```
create  app/mailers/article_mailer.rb
create  app/mailers/application_mailer.rb
```
mialkerのアクションを設定
```
class ArticleMailer < ApplicationMailer
  def report_summary
    @published_articles = Article.where("state = ?", Article.states[:published])
    @yesterday_published_articles = Article.where("DATE(published_at) = ? AND state = ?", Date.yesterday, Article.states[:published])
    mail(to: admin@example.com, subject: '公開済記事の集計結果')
  end
end
```
メールのtextも設定
```
公開済みの記事数: <%= @published_articles.count  %>件
<% if @yesterday_published_articles?  %>
      <%each @yesterday_published_articles.do |article|%>
        タイトル:<%= article.title%>
      <%end%>
    <%else%>
      昨日公開された記事はありません
    <%end%>
```

試しに送信してみてどのような調子か確認  
問題なければwheneverで定期送信されるように設定する  
deliver_nowをつかうかも

#### previewの設定
mailerの作成時に生成されたpreviewを設定
```
# Preview all emails at http://localhost:3000/rails/mailers/article
class ArticlePreview < ActionMailer::Preview
  def send_mail
    ArticleMailer.report_summary
  end
end
```
preview確認の為にURLにアクセスするもエラーが発生
`http://localhost:3000/rails/mailers/article/send_mail`
エラー原因を調査する

`ルーティングの問題: プレビューのルーティングが正しく設定されているかを確認してください。config/environments/development.rbファイルでconfig.action_mailer.preview_pathが正しく設定されている必要があります。`
```
config.action_mailer.smtp_settings = {
  address:              'smtp.example.com',  # SMTPサーバーのアドレス
  port:                 587,                 # SMTPサーバーのポート
  domain:               'example.com',       # メールのドメイン
  user_name:            'user@example.com',  # SMTPサーバーのユーザー名
  password:             'password',          # SMTPサーバーのパスワード
  authentication:       'plain',             # 認証の種類
  enable_starttls_auto: true                 # TLSを自動で使用するかどうか
}

config.action_mailer.delivery_method = :smtp  # メールの配送方法
config.action_mailer.perform_deliveries = true  # メール送信を実行するか
config.action_mailer.raise_delivery_errors = true  # 送信エラー時に例外を発生させるか
```
syntax errorがあったので解消
```
# report_summary.text.erb

公開済みの記事数: <%= @published_articles.count  %>件
# .any?でコレクションが空でない場合に true を返す
<% if @yesterday_published_articles.any?  %>
# 課題の通り記事数カウントも追加
昨日公開された記事数: <%= @yesterday_published_articles.count  %>件
# .each do　にする
  <% @yesterday_published_articles.each do |article|%>
    タイトル:<%= article.title%>
  <%end%>
<%else%>
昨日公開された記事はありません
<%end%>

# article_mailer.rb

class ArticleMailer < ApplicationMailer
  def report_summary
    @published_articles = Article.where("state = ?", Article.states[:published])
    @yesterday_published_articles = Article.where("DATE(published_at) = ? AND state = ?", Date.yesterday, Article.states[:published])
# admin_emailの変数に設定してからtoに設定する
    admin_email = 'admin@example.com'
    mail(to: admin_email, subject: '公開済記事の集計結果')
  end
end
```
`http://localhost:3000/rails/mailers/article/report_summary`で意図した通りに表示されたことを確認

#### test
rubocop
```
@published_articles = Article.where("state = ?",  Article.states[:published])
↓
@published_articles = Article.where(state: Article.states[:published])
``` 

## 参考サイト
- [Action Mailer の基礎](https://railsguides.jp/action_mailer_basics.html)
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)