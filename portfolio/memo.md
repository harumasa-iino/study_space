# css　導入で挫けそうになった
gemでbootstrapをbundle install したが、yarnがなくてnode.jsをインストールできていなかったのでだめ 
いろいろ試したが、うまくいかなかったため再度ブランチ切ってやり直し。dockerfileを作り直し 
そしてbootstrapインストールしたがどうしてもうまく動かない…dockerfileの作り直しで何回も起動したりしていたから。 
デーモンと競合しちゃった可能性が高い。prune -a して再度buildして解決！嬉しい！！！

# db作成
モデルの前にdbを先に作成してしまった
db構成の変更があり、先にどれだけちゃんと設計できているかが重要なのか実感した

ハッシュからの取り出し方
enumからのデータの取り出し
resultの登録
引当

Categoryのnameを削除してpatternを追加
一度PATTERNに変換する必要がないので、nameを消してpatterにする

最初の画像を部屋画像と合成させる機能を作る
その後に、画像の切り替え機能
画像の幅や高さを現実に合わせる
会員登録機能で、部屋の画像保存