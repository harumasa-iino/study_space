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

#### enumに新たにステータスを追加
```
  enum state: { draft: 0, published: 1, publish_wait: 2 }
```
  
#### フラッシュメッセージの分岐を追加
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
これをifを使って分岐を作成
```
def update
    authorize(@article)

    if @article.update(article_params)
      @article.adjust_state
        logger.debug("draftではない")
                            logger.debug(@article.state)
      @article.state = if @article.published_at <= Time.current
                            :published
                         else
                            :publish_wait
                         end
      end
      @article.save!
      flash[:notice] = '更新しました'
      redirect_to edit_admin_article_path(@article.uuid)
    else
      render :edit
    end
  end
```
publishのコントローラーも同様にifで分岐を作成。fat controllerの解消が必要  
```
# article.rb

# 現在の時間が公開日よりも過去であるかの判定。過去であれば公開にする
def publishable?
    Time.current >= published_at 
end

# フラッシュメッセージの分岐。stateごとにメッセージを設定している
def message_on_publish
  if published?
    '公開しました'
  elsif publish_wait?
    '公開待ちにしました'
  end
end

# stateの調整。publishableを使ってself.stateにstateを渡す。最初にdraftであればreturnする
def adjust_state
  return if draft?
  self.state = if publishable?
                  :published
               else
                  :publish_wait
               end
end
```
判定のロジックであるため、モデルに記載  
コントローラーにこれらを反映する
```
# articles_controller

def update
  authorize(@article)
# assign_attributesはparamsで受け取った値をまとめてDBに保存せずにインスタンスメソッド内に保存する事ができる、無駄にSQLを発行しないために使用
  @article.assign_attributes(article_params)
# ここでstateの判定をおこなって更新する
  @article.adjust_state
# すでに@articleにparamsで受け取った情報が入っているためupdateではなくsaveで更新を行う
  if @article.save
    flash[:notice] = '更新しました'
    redirect_to edit_admin_article_path(@article.uuid)
  else
    render :edit
  end
end
```
以上でfat controllerを解消しつつ、stateを条件ごとに分岐して更新・フラッシュメッセージの出し分けが完了  
コントローラーでの分岐からモデルにどこの部分を抜き出して判定を書くかをだいぶ記事に頼ってしまったが実装できた

#### 公開日の設定を1時間ごとに変更  
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
**失敗だったと判明**
時間をうまく渡せていなかったため、再度検索等したが見つけられずchatFPTに聞いた所`stepping: 60`で区切れるそう  
下記で解消した
```
$('.js-datetimepicker').datetimepicker({
    locale: 'ja',
    sideBySide: true,
    toolbarPlacement: 'bottom',
    showTodayButton: true,
    showClear: true,
    stepping: 60,
    format: 'YYYY-MM-DD HH:mm'
  });
```

## 参考サイト
- [【Rails 】Rakeタスクとは](https://qiita.com/mmaumtjgj/items/8384b6a26c97965bf047)
- [参考サイト3](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)

フラッシュメッセージの出し分けとfat controllerの解消
- [[Rails] FatControllerの改善](https://osamudaira.com/353/)
- [【Rails】Time.currentとTime.nowの違い](https://qiita.com/kodai_0122/items/111457104f83f1fb2259)
- [ああ](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)

日付変更
- [[Rails]日付と時間の入力フォームにDateTimePickerを使う](https://blog.hello-world.jp.net/posts/javascript-1762)