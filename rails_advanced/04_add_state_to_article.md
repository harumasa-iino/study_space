# トピック
記事ステータスの追加

## 目標
記事のステータスは「下書き」「公開」の2種類に「公開待ち(publish_wait)」を追加  
記事編集画面で記事の更新、公開ボタンを押した際の挙動を変更

```
- 記事のステータスを「公開」または「公開待ち」、公開日時を「未来の日付」に設定して、「更新する」ボタンを押した場合
--> 記事のステータスを「公開待ち」に変更して「更新しました」とフラッシュメッセージを表示

- 記事のステータスを「公開」または「公開待ち」、公開日時を「過去の日付」に設定して、「更新する」ボタンを押した場合
--> 記事のステータスを「公開」に変更して「更新しました」とフラッシュメッセージを表示

- 記事のステータスを「下書き」に設定して、「更新する」ボタンを押した場合
--> 記事のステータスを「下書き」に変更して「更新しました」とフラッシュメッセージを表示

- 公開日時が「未来の日付」となっている記事に対して、「公開する」ボタンを押した場合
--> 記事のステータスを「公開待ち」に変更して「公開待ちにしました」とフラッシュメッセージを表示

- 公開日時が「過去の日付」となっている記事に対して、「公開する」ボタンを押した場合
--> 記事のステータスを「公開」に変更して「公開しました」とフラッシュメッセージを表示
```
記事のステータスが「公開待ち」で公開日時が過去になっているものがあれば、rakeタスクをライブラリ「whenever」により1時間ごとに走らせ、ステータスを「公開」に変更.  
※公開日時が過去で「公開待ち」となっているデータを画面上で更新しなくても、自動でステータスを公開に変更するようにしたい
  
管理画面から1分単位で公開日時を指定できるようになっているが、1時間ごとに指定できるように変更してください。
(自動更新するcronの実行間隔に合わせる)

## 学習内容
- rakeタスク
- cron・whenever
- find_each
- FatControllerの解消

### 課題に対しての学習内容


### やったこと
enumに新たにステータスを追加
```
  enum state: { draft: 0, published: 1, publish_wait: 2 }
```
  
フラッシュメッセージの分岐を追加
```
def update
    authorize(@article)

    if @article.update(article_params)
      flash[:notice] = '更新しました'
      redirect_to edit_admin_article_path(@article.uuid)
    else
      render :edit
    end
  end
```


  
公開日の設定を1時間ごとに変更  
公開日のinputを確認したらdate_time_pickerを使用していることを確認。設定がjavascriptだったためファイルを確認したところ、設定箇所があったため修正  
```
# app>assets>javascript>admin.js

$('.js-datetimepicker').datetimepicker({
    locale: 'ja',
    sideBySide: true,
    toolbarPlacement: 'bottom',
    showTodayButton: true,
    showClear: true,
    format: 'YYYY-MM-DD HH:00'
  });
```
format:の`mm`を00にして1時間ごとの変更に固定

#### 苦戦したこと
ここは苦戦しました

```
hogehoge 
```

これで解決しました


## 参考サイト
- [参考サイト1](https://www.google.com/?hl=ja)
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)