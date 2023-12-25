# トピック
検索機能の追加

## 目標
「セレクトボックスのカテゴリー検索」「フリーワードによるタイトル検索」に加えて、
「セレクトボックスの著者検索」「セレクトボックスのタグ検索」「フリーワードによるコンテンツ（記事内容）検索」を追加
追加する各検索機能では、下書き状態の記事も検索できるように実装

## 学習内容
- form object
- scope

### 課題に対しての学習内容

#### scopeについて
現在実装されている検索機能の流れを確認
```
# app>controller>form>search_articles_form.rb

  def search
    relation = Article.distinct

    relation = relation.by_category(category_id) if category_id.present?
    title_words.each do |word|
      relation = relation.title_contain(word)
    end
    relation
  end
```
Articleモデルでby_categoryでscopeを定義していると分かる  
scopeとは
```
(publishedカラムはtrueかfalseで公開・非公開を管理)

class Blog < ApplicationRecord
  scope :published, -> { where(published: true) }
end
```
上記のようにモデルで共通の条件式を設定出来るもの  
scopeのメリットは
- 条件式に名前を付けられるので直感的なコードになる
- 共通化により修正箇所が少なくて済む
- 記述コードが短くなる


#### Taxonomy

類似テーブルはまとめ設計する。DBには実在しないテーブルでデータは全てtaxonomiesに保管される
```
# taxonomies.rb
class Taxonomy < ApplicationRecord

end

#tag.rb
class Tag < Taxonomy
  has_many :article_tags
  has_many :articles, through: :article_tags
end
```

タグのattributesがうまくいかない  
モデルのscopeではjoinsしているが、view読み込み時にアソシエーションがうまくいかなくてarticlesのカラムだとされており、エラーが発生指定しまっている
```
Mysql2::Error: Unknown column 'articles.tag_id' in 'where clause'

th = Article.human_attribute_name(:published_at)
  tbody
   - @articles.each do |article|
    tr
      td = article.id
      td
```
## 次回やること
sentecesのbodyをattributeして検索出来るようにする  
paramsで送信はできているが、データベースにうまく送信できていなくて検索できない状態にある  
->params permitできていなかった  
  
tag_idの紐づけを見直す
```
scope :by_tag, ->(tag_id) { joins(:tags).where(article_tags: {tag_id: tag_id}) }
```
where句内に中間テーブルを経由するように記載  
結合先のカラム名で絞り込む場合はwhereでテーブルを指定する
```
モデル名.joins(:関連名).where(結合先のテーブル名: { カラム名: 値 })
```

## Rspec
uniqueで作成しないデータは複数のデータをsequenceを使って作成
```
sequence(:カラム) {|n| "値#{n}"}
```
Rspecの記述方法については要復習



## 参考サイト
- [[Rails]モデルのscopeメソッド](https://zenn.dev/yusuke_docha/articles/ca0637ccc8d01f)
- [【Rails】単一テーブル継承(STI)について](https://qiita.com/niwa1903/items/218713c076fb0075712f)
- [ActiveModelを用いた検索機能の実装方法](https://qiita.com/namikawa07/items/d223305861ffe10bfbc5)
- [Railsのモデルのscopeを理解しよう](https://qiita.com/ozin/items/24d1b220a002004a6351)
- [【Rails】 joinsメソッドの使い方 ~ テーブル結合からネストまで学ぶ](https://pikawaka.com/rails/joins#where%E3%83%A1%E3%82%BD%E3%83%83%E3%83%89%E3%81%AE%E3%82%AB%E3%83%A9%E3%83%A0%E6%8C%87%E5%AE%9A%E6%96%B9%E6%B3%95%EF%BC%92)
- [transientとafter(:build)](https://sakitadaiki.hatenablog.com/entry/2021/02/07/091403)
