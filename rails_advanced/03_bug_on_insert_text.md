# トピック
課記事にテキストのコンテンツブロックを挿入した後、テキストを何も入力せずにプレビューページを閲覧するとエラーが発生します。

## 目標
テキストに何も入力せずにプレビューページを閲覧してもエラーが発生しない

## 学習内容
- result << object
- nilガード

### 課題に対しての学習内容
テキストを何も入れずにプレビューを見ることで下記エラーが出ている  
```
no implicit conversion of nil into String
```
エラー箇所は下記の通り
```
article_blocks.each do |article_block|
  result << if article_block.sentence?
        sentence = article_block.blockable
        sentence.body
       elsif article_block.medium?
```

### やったこと
nilがstringのインスタンスメソッドに渡されていることによるエラーが起きている。  
nilガードによってエラーを回避する
```
content = ''
  content << @user.name ||= ''
```
nilの場合は`||=`の右辺を代入する  

```
result << if article_block.sentence?
                  sentence = article_block.blockable
                  sentence.body  ||= ''
```

#### 苦戦したこと
||=''を記述する箇所に迷った  
いくつか試した結果sentence.bodyの後に設定
```
result << if article_block.sentence?
                  sentence = article_block.blockable
                  sentence.body ||= ''
```
resultメソッドに渡す変数の箇所に設定

### 学び
Stringのインスタンスメソッド `<<`
```
content = ''
content << "tomato"
p content
# => "tomato"
```
引数で与えられた文字列を破壊的に連結するメソッド。  
引数には文字列か０以上の整数を渡すことができる。


## 参考サイト
- [TypeError - no implicit conversion of nil into String エラーの解消](https://qiita.com/takuya119/items/32817bcf1baff0a99726)