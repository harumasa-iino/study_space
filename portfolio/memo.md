# css　導入で挫けそうになった
gemでbootstrapをbundle install したが、yarnがなくてnode.jsをインストールできていなかったのでだめ 
いろいろ試したが、うまくいかなかったため再度ブランチ切ってやり直し。dockerfileを作り直し 
そしてbootstrapインストールしたがどうしてもうまく動かない…dockerfileの作り直しで何回も起動したりしていたから。 
デーモンと競合しちゃった可能性が高い。prune -a して再度buildして解決！嬉しい！！！

# db作成
モデルの前にdbを先に作成してしまった