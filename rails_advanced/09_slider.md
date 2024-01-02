# トピック
トップ画像をスライダー形式に変更

## 目標
ブログのトップ画像を複数枚の画像が一定間隔で切り替わるようする
切り替わる画像は、管理画面でアップロードと削除ができるようにする
faviconやog-imageに関しても、個別に削除できるようにしてください。
main_imagesには、複数の画像を一度に登録できるようにしてください

## 学習内容
- jQueryプラグインの swiper を導入

### 課題に対しての学習内容
has_many_attachedによってレコードとファイルの間に1対多の関係を設定できます。各レコードには多数の添付ファイルをアタッチできます。
```
# site.rb
  has_one_attached :og_image
  has_one_attached :favicon
  has_many_attached :main_images
```
ストロングパラメーターを設定
```
  def site_params
    params.require(:site).permit(:name, :subtitle, :description, :favicon, :og_image, :main_images)
  end
```
バリデーションを設定
```
# site.rb
  validates :main_images, attachment: { purge: true, content_type: %r{\Aimage/(png|jpeg)\Z}, maximum: 524_288_000 }
```
viewで複数画像を送信出来るようにする
```
# 画像の複数投稿でmultiple: trueを付与したいときは､そのままmultiple: trueを付けるのでは無く､input_htmlの中で指定する
= f.input :main_images, as: :file, hint: 'JPEG/PNG (1200x1400)', input_html: { multiple: true }
```

### やったこと
あれこれやりました

#### 苦戦したこと
ここは苦戦しました

```
hogehoge 
```

これで解決しました


## 参考サイト
- [simple_form公式git hub](https://github.com/heartcombo/simple_form)
- [[Rails] Simple_form gem2](https://zenn.dev/yusuke_docha/articles/1fa77e0cfd54d9#%E4%BB%BB%E6%84%8F%E3%81%AEhtml%E5%B1%9E%E6%80%A7%E3%82%92%E3%81%9D%E3%81%AE%E3%81%BE%E3%81%BEinput%E3%81%AB%E6%B8%A1%E3%81%99)
- [参考サイト3](https://www.google.com/?hl=ja)