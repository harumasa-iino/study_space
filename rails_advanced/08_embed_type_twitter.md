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
embed_typeのenumにtwitterを追加
```
# embed.rb
  enum embed_type: { youtube: 0 }
```
youtubeをembedするには`<iframe width="~~" height="~~" src="https://www.youtube.com/embed/{id}"`にする必要がある  
今回は共有URLを添付してもらってembedさせたいので、フォームから送信されたurlからidを取り出す必要がある
```
# embed.rb
def split_id_from_youtube_url
  identifier.split('/').last
end
```



#### 忘れていたこと
enumを定義した場合、youtube? メソッドが使えるようになります。そして、このメソッドは status の値が :youtube のときに true を返します。

## 参考サイト
- [動画と再生リストを埋め込む](https://support.google.com/youtube/answer/171780?hl=ja)
- [参考サイト2](https://www.google.com/?hl=ja)
- [参考サイト3](https://www.google.com/?hl=ja)