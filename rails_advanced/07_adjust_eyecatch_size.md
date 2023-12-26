# トピック
アイキャッチの表示サイズ / 位置指定

## 目標
登録したアイキャッチの横幅を100px~700pxでピクセル単位で指定できる。  
また、アイキャッチの表示位置を指定出来るようにする。

## 学習内容
- 課題に対しての学

### 課題に対しての学習内容

#### アイキャッチ幅の設定

1. カラムの追加
2. バリデーションの設定
3. 入力フォームの作成
4. コントローラーでparamsで受け取れるようにする
5. viewでwidthを呼び出す

テーブルにeyecatch_widthのカラムを追加。
```
# 整数なのでintegerでdefaultは100、3桁で十分なのでlimit3
class AddEyecatchWidthToArticles < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :eyecatch_width, :integer, default: 100, limit: 3
  end
end
```
articeモデルにバリデーションを追加
```
  varidates :eyecatch_width, , numericality: { :greater_than_or_equal_to: 100, less_than_or_equal_to: 700 }
```
editのviewファイルにinput欄を追加
```
= f.input :eye_catch, as: :file
- if @article.eye_catch.attached?
= image_tag @article.eye_catch_url(:thumb), class: 'img-thumbnail'
br
br
= f.input :eyecatch_width
= f.input :description, input_html: { class: 'js-autosize' }
```
ストロングパラメーターでeyecatch_widthを許可する
```
  def article_params
    params.require(:article).permit(
      :title, :description, :slug, :state, :published_at, :eye_catch, :eyecatch_width, :category_id, :author_id, tag_ids: []
    )
  end
```
viewで表示出来るようにする
```
# shared/_article.rb
  - if article.eye_catch.attached?
    section.eye_catch
    # (:flex)でdecorator側で制御する
      = image_tag article.eye_catch_url(:flex), class: 'img-fluid'
```
article_decorator.rbで引数の呼び出しに定義する
```
command = case version
          when :thumb
            { resize: '640x480' }
          when :lg
            { resize: '1024x768' }
# flexでself.で幅のカラムを呼び出す
          when :flex
            { resize: "#{self.eyecatch_width}" }
          when :ogp
            { resize: '120x630' }
          else
            false
          end
```

#### 画像位置の調整
1. カラムの追加
2. モデルでenumの設定
3. viewファイルでラジオボタンの設定
4. コントローラー側でデータの保存
5. viewファイルで表示方法の変更

画像位置を保存するカラムを追加 
```
# enumを使うのでdefault:0を設定しておくと良い
class AddEyecatcgAlignToArticle < ActiveRecord::Migration[7.0]
  def change
    add_column :articles, :eyecatch_align, :integer, default: 0
  end
end
```
モデルでenumを設定
```
  enum eyecatch_align: { right: 0, center: 1, left: 2 }
```
viewにラジオボタンを設定する
```
= f.collection_radio_buttons :eyecatch_align, Article.eyecatch_aligns_i18n, :first , :last
```
collection_radio_buttonsを使うことで、ラジオボタンとラベルの記述が不要。  
また、enum_helperによってi18nでのenumの日本語呼び出しができてラベルにつけることが出来る  
見た目の調整は必要そう  
【追記】
```
= f.input_field :eyecatch_align, as: :radio_buttons  #ラジオボタンを使うときはf.input_fieldを使う
```
input_fieldとas: :radio_buttonsで記述する
  
コントローラー側でラジオボタンの結果を受け取る  
```
def article_params
  params.require(:article).permit(
    :title, :description, :slug, :state, :published_at, :eye_catch, :eyecatch_width, :eyecatch_align, :category_id, :author_id, tag_ids: [])
end

# ログでも受け取れていることを確認
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"w7iC1vBd3bnTeKos6mRNV_cJ4pMgjHS4N3iODF8n498QHL6t9n9TBnE3T4Bhb7e8RnAsnUk8KPmkZadPKOqIqQ", "article"=>{"state"=>"published", "published_at"=>"2023-12-16 23:00", "title"=>"aaa", "slug"=>"nani", "eyecatch_width"=>"300", "eyecatch_align"=>"left", "description"=>"a", "author_id"=>"", "category_id"=>"2", "tag_ids"=>[""]}, "commit"=>"更新する", "uuid"=>"ccb2c3dd-7a0b-4f23-a2a6-653d5d6eb9fe"}
```
カラムの作成をしてデータを送信するところまで実装できたので、データをもとに表の見た目を変えられるようにviewを編集  
Bootstrapの公式ドキュメントの通り、justifyを使用して画像の位置を調整する
```
# 左寄せ
<div class="d-flex justify-content-start">...</div>
# 右寄せ
<div class="d-flex justify-content-end">...</div>
# 中央揃え
<div class="d-flex justify-content-center">...</div>
```
データの内容によってclassを分岐させる必要がある。viewでのifは冗長的になるがいったんはcase whenで分岐させる
色々苦戦したが、section自体にclassをつけることで解決した
```
section.eye_catch class="text-#{article.eyecatch_align}"
```
enumの値をそのまま使うことでtext-rightなどbootstrapに適したclassを付与することができた

## 参考サイト
- [Railsのラジオボタン(f.radio_button)](https://qiita.com/dawn_628/items/944c79b06299a35b5225)
- [ActiveRecord でのデフォルト値設定](https://www.google.com/?hl=ja)
- [enumとenum_helpの使い方【rails】](https://qiita.com/kikikikimorimori/items/353f69e31b42e85b9c29)
- [Justify content](https://getbootstrap.jp/docs/5.3/utilities/flex/)