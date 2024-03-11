# トピック
記事に画像のコンテンツブロックを挿入後、画像ファイルをアップロードせずにプレビューページを閲覧または公開するとエラーが発生する

## 目標
画像ファイルのアップデートをせずにプレビューを閲覧してもエラーが発生しないようにする

## 学習内容
- slim

### 課題に対しての学習内容
画像ファイルをアップロードせずにプレビュー表示したところ
```
Nil location provided. Can't build URI.
```
のエラーが発生。画像ファイルがないためエラーが出ているそう。
  

エラーの発生箇所は下記
```
.media-image
  = image_tag medium.image_url(:lg)
```

turboが動き出したことで修正が必要な箇所がでてきた

### やったこと
空のstringクラスに画像ファイルがない（nil）を入れようとしていたためエラーが発生。nilの場合に空で保存するという事ができないらしい。  
  
- ifでからの場合に読み込みを行わない分岐を入れることでエラーを回避
- もしくはデフォルトの値を入れることでもエラーを回避可能
  
今回は前者

#### 苦戦したこと
ifを入れたのですが変わらずエラーが発生
```
- if medium.image_url
.media-image
  = image_tag medium.image_url(:lg) 
```
  
slimの記法的にifを適応させるために、ネストして入れる必要がありました
```
- if medium.image_url
  .media-image
    = image_tag medium.image_url(:lg) 
```
  
slimは`<>`などが不要なRuby製のテンプレートエンジンのことで、htmlをより簡潔でスマートに書くことができるもの

## 参考サイト
- [Railsでslimを使う方法から基本文法](https://qiita.com/ngron/items/c03e68642c2ab77e7283)
- [TypeError - no implicit conversion of nil into String エラーの解消](https://qiita.com/takuya119/items/32817bcf1baff0a99726)