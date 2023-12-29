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
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)