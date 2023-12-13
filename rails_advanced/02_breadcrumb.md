# トピック
パンくずの設定

## 目標
課題のゴール

## 学習内容
- breadcrumb

### 課題に対しての学習内容
すでに設定されているパンくずリストを確認
  
gretelを使った設定

### やったこと
すでにgemはインストールしているので、viewファイルと`config/breadcrumb.rb`の編集

`config/beadcrumb.rb`
```
crumb "ページ名" do
  link "ビューに表示される名前", "リンクされるURL"
  parent :親のページ名（現在の前のページ）
end
```

viewファイル（slimでの記述）
```
-breadcrumb :"ページ名"
```


## 参考サイト
- [【Rails】 gretelを使ってパンくずリストを作成しよう](https://pikawaka.com/rails/gretel)