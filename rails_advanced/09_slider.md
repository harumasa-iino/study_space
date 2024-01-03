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
ストロングパラメーターを設定。main_imagesには複数画像が入るため配列を設定しておく
```
  def site_params
    params.require(:site).permit(:name, :subtitle, :description, :favicon, :og_image, main_images: [])
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

  - if @site.main_images.attached?
    .main_images_box
      - @site.main_images.each do |main_image|
        .main_image
          = image_tag main_image.variant(resaize: '300×100').proceseed
```
destroyするためのルーティングを追加。siteのcontrollerは単数resourceであり、site自体のコントローラーのためここでの削除アクションはsiteを削除するものであるはず。 
そのため、個別に削除を行うコントローラーを新規で作成しルーティングを設定
```
resource :site, only: %i[edit update] do
# controller: 'site/attachments' がないと生成されるルーティングが、admin/attachments#destroy となるが、付けることでadmin/site/attachments#sdestroy となります
  resources :attachments, controller: 'site/attachments', only: %i[destroy]
end
```
Siteから引き継いだコントローラーを設定
```
class Admin::Site::AttachmentsController < ApplicationController
  def destroy
# current_siteはappricaton_controllerでhelperとして設定されている
    authorize(current_site)
# ActiveStorage::Attachmentでparamsを受けることで、siteモデルで設定されているどのattachmentsでも対応が可能になる
    image = ActiveStorage::Attachment.find(params[:id])
    image.purge
    redirect_to edit_admin_site_path
  end
end
```
viewに削除ボタンを設置
```
  = link_to '削除', admin_site_attachment_path(main_image.id), method: :delete, class: 'btn btn-danger'
```
削除権限も設定
```
# site_policy.rb
  def destroy?
    user.admin?
  end
```

### swiperの導入
紆余曲折有りすぎたが、覚えている限りで最初から書いていく  
swiperの導入のためにinstallする
```
# addを使ってからinstallする
yarn add swiper
yarn install
```
公式ドキュメントを参考にhtmlに追記していく
```
  .swiper
    .swiper-wrapper
      - if current_site.main_images.present?
        - current_site.main_images.each do |main_image|
          = image_tag main_image, class: 'swiper-slide'
      - else
        = image_tag '/images/cover.jpg', class: 'swiper-slide'
```
assets.rbにinstallしたswiperが読み込まれるように記載
```
# config/initializers/assets.rb
Rails.application.config.assets.paths << Rails.root.join('node_modules')
```
jsとcssでそれぞれswiperが使えるように記述
```
# app/assets/javascripts/application.js
//= require swiper/swiper-bundle.js
```
```
# app/assets/stylesheets/application.scss
@import 'swiper/swiper-bundle';
```
ここで躓く  
試したこと色々
- cssが崩れていたので見本を元にcssの記述をパクる。swiper-containerが古いclassだったため改変
- jsが読み込まれていないようだったので色々試す
- javascripts/appplication.jsではなくbuild/application.jsが読み込まれているようだったのでそちらに書いてみる
- bin/devするたびに消されてしまうので記述する場所ではないと気付く
- 別でswiper.jsを作ってそちらにswiper初期化のコードを書いてみる
- application.jsで呼び出してみるも、そもそも読み込まれていないようだったので挫折
- console.log(1);をしてもconsoleに書かれないので読み込まれていないと発覚した
- 結果試したところviewに直接javascriptを記述することで解決しそう
色々あった結果javascriptを直接記述  
DOMでswiper部分が読み込まれたあとにjavasxriptが起動する必要があるので下の方に追記
```
header
  .swiper
    .swiper-wrapper
      - if current_site.main_images.present?
        - current_site.main_images.each do |main_image|
          = image_tag url_for(main_image), class: 'swiper-slide'
      - else
        = image_tag '/images/cover.jpg', class: 'swiper-slide'
    .swiper-button-next    
    .swiper-button-prev
    .swiper-pagination
    .swiper-scrollbar    
  .container.blog-title
    h1 = link_to current_site.name, root_path
    p.lead = current_site.subtitle
  
javascript:
  $(document).ready(function() {
    new Swiper('.swiper', {
      loop: true,
      autoplay: {
        delay: 3000,
        disableOnInteraction: false,     
      },
       // If we need pagination
      pagination: {
        el: ".swiper-pagination",
        clickable: true,
      },

      // Navigation arrows
      navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',
      },

      // And if we need scrollbar
      scrollbar: {
        el: '.swiper-scrollbar',
      },
    })
  })
```
さらにminify化されたライブラリをapplication.html.slimで導入
```
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
```
上記で動くようになった


## 参考サイト
- [simple_form公式git hub](https://github.com/heartcombo/simple_form)
- [[Rails] Simple_form gem2](https://zenn.dev/yusuke_docha/articles/1fa77e0cfd54d9#%E4%BB%BB%E6%84%8F%E3%81%AEhtml%E5%B1%9E%E6%80%A7%E3%82%92%E3%81%9D%E3%81%AE%E3%81%BE%E3%81%BEinput%E3%81%AB%E6%B8%A1%E3%81%99)
- [[Rails] Swiperを使ったスライダー機能](https://osamudaira.com/411/)
- [[Rails] resourcesとresourceの違いについて勉強してみた](https://qiita.com/jackie0922youhei/items/0cf56e4c80e14a9cfd00)
- [そもそもnpmからわからない](https://zenn.dev/antez/articles/a9d9d12178b7b2)
- [Active Storage の概要](https://railsguides.jp/active_storage_overview.html)
- [swiperをyarnで導入して、画像をスライダー形式にする！](https://qiita.com/ken_ta_/items/bdf04d8ecab6a855e50f)
- [RailsでSwiperを導入する方法](https://qiita.com/miketa_webprgr/items/0a3845aeb5da2ed75f82)