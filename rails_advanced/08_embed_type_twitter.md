# トピック
埋め込みメディアタイプにTwitterの追加

## 目標
twitterのツイートを埋め込みコンテンツとして選択できるようにするtwitterが選択され適切なURLが入力されたら、ツイートが表示されるようにしてください。
youtubeに関しても、IDではなくURLを入力したら動画を表示できるようにする

カラム名は現状のままで構いません。
入力項目のラベル名も本来はURLに変えるべきではありますが、自動テストの制約上IDのままにしてください。
貼り付けるべきURLはyoutube再生画面の「共有」を押した後に表示されるものとします。
＊TwitterがXに変わったことにより、共有ボタンから「リンクをコピー」を行うと、https://x.com/....になっています。課題ではURLのxの部分をtwitterに置換して投稿を行ってください。

## 学習内容
- 課題に対しての学習内容
- 課題に対しての学習内容
- 課題に対しての学習内容

### 課題に対しての学習内容

#### youtubeをurlで表示出来るようにする
youtubeをembedするには`<iframe width="~~" height="~~" src="https://www.youtube.com/embed/{id}"`にする必要がある  
今回は共有URLを添付してもらってembedさせたいので、フォームから送信されたurlからidを取り出す必要がある
```
# embed.rb
def split_id_from_youtube_url
  identifier.split('/').last
end
```
#### twitterを表示出来るようにする
embed_typeのenumにtwitterを追加
```
# embed.rb
  enum embed_type: { youtube: 0 }
```
入力フォームは既存のままでOK
```

```
viewファイルで分岐を作成
```
  - if embed.youtube?
    - if embed.identifier?
      = render 'shared/embed_youtube', embed: embed, width: 560, height: 315
  - if embed.twitter?
    - if embed.identifier?
      = render 'shared/embed_twitter', embed: embed
```
render先のembed_twitterを[公式のpath](https://publish.twitter.com/?query=https%3A%2F%2Fx.com%2FSpaceX%2Fstatus%2F1732824684683784516%3Fs%3D20&widget=Tweet)を元に作成
```
.embed-twitter
  blockquote.twitter-tweet
   a href="#{embed.identifier}"
  script async="" src="https://platform.twitter.com/widgets.js" charset="utf-8"
```

#### アイコン表示の分岐
```
# _article_block.html.slim
section.box
  .box-header
# box_header_iconで分岐表示
    = article_block.box_header_icon
```
```
# article_block_decorator.rbで分岐アクションの作成
  def box_header_icon
    if sentence?
      '<i class="fa fa-edit"></i>'.html_safe
    elsif medium?
      '<i class="fa fa-image"></i>'.html_safe
    elsif embed?
       '<i class="fa fa-youtube-play"></i>'.html_safe
    end
  end
```
判定はmodelで作成
```
  def sentence?
    blockable.is_a?(Sentence)
  end

  def medium?
    blockable.is_a?(Medium)
  end

  def embed?
    blockable.is_a?(Embed)
  end
```
インスタンス変数内のembed_typeの判定を追加する
```
  def embed?
    blockable.is_a?(Embed)
  end
# embed.youtube?にしていたが、article_blockモデル内で記述しているためblockableを使う
  def youtube?
    blockable.youtube?
  end

  def twitter?
    blockable.twitter?
  end
```

#### 忘れていたこと
enumを定義した場合、youtube? メソッドが使えるようになります。そして、このメソッドは status の値が :youtube のときに true を返します。

## 参考サイト
- [動画と再生リストを埋め込む](https://support.google.com/youtube/answer/171780?hl=ja)
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)