# トピック
名前を省略しない

## 目標
rubyのオブジェクト指向の考え方を体験する

### 学習内容
以下の規約に従うことで、オブジェクト指向による設計やプログラミングを実際のプログラムに適用します。

1. 1つのメソッドにつきインデントは1段階までにすること
2. else句を使用しないこと
3. すべてのプリミティプ型と文字列型をラップすること
4. 1行につきドットは1つまでにすること
5. 名前を省略しないこと
6. すべてのエンティティを小さくすること
7. 1つのクラスにつきインスタンス変数は2つまでにすること
8. ファーストクラスコレクションを使用すること
9. Getter、Setter、プロパティを使用しないこと

### 課題に対しての学習内容

#### 名前を省略しないこと
今回はbuyメソッドで引数iが設定されていた
```
-  def buy(i, kind_of_drink)
+  def buy(payment, kind_of_drink)
     # 100円と500円だけ受け付ける
-    if i != 100 && i != 500
-      @change += i
+    if payment != 100 && payment != 500
+      @change += payment
       return nil
     end
```
iのままでは引数の意味が分からずにコードを読むために時間がかかったり、誤って引数を使用してしまう可能性があるため意味のある名前を設定する必要がある  
また、意味のある名前であるだけでなく、ユビキタス的にチームで共通認識を持った言葉を使う必要がある

#### プリミティブ型と文字列型をラップする
意味のある値に対して型を定義することで、コードの可読性を高め、変更に強くし、拡張しやすくなります。  
一般的にValueObjectと呼ばれるテクニックで以下の特徴を持ちます。  
  
- 一意性を持たない
- 計測／定量化／説明を責務とする
- イミュータブルオブジェクト
- 交換可能
- ふるまいに副作用がない

#### ファーストクラスコレクションを使用する
配列をラップしたクラスのこと  
配列で行われる下記のような処理をクラスにまとめて整理する
- for文などのループ処理
- 配列やコレクションの要素の数が変換する（可能性がある）
- 個々の要素の内容が変化する（可能性がある）
- 0件の場合の処理
- 要素の最大数の制限
特定の用途に使用する配列をクラスにまとめたことで、配列に対して制御したり機能を追加したりすることが容易になる
- 配列の上限数を制限する
- 配列へ追加を可能にして、削除を禁止する

[Rubyで作るファーストクラスコレクション](https://qiita.com/gashiura/items/999a8c36e47a07fa4b27)

#### Getter, Setter, プロパティを使用しない
オブジェクトの内部状況を直接取得、変更する`Getter`,`Setter`はカプセル化を壊す要因になりかねない  
オブジェクトの内部状況を使用した処理をした場合は、クラスで別途定義して結果のみを受け取るようにする  
インスタンスが==0の場合や、インスタンスに1を追加するなど、それらはempty?やaddなどで定義してあげる

#### 1つのクラスにつきインスタンス変数は2つまでにする
オブジェクト指向エクササイズでは1つのクラスにつきインスタンス変数は2つまでにする  
インスタンス変数が増えて役割が増えてしまっている場合はクラスを分けることも必要です  

#### else句を使用しない
条件分岐があると機能の凝縮になりきらないため、判定メソッドはクラス内のメソッド内に含める  
ロジックを機能別で分けてクラスを分けていく判断を行う

#### 関連が強いものどうしを同じパッケージにまとめる
機能が同じクラス同士は同じパッケージにまとめる  
1つのソースファイルだと可読性が低いため

## 参考サイト
- [実践DDD本 第6章「値オブジェクト」～振る舞いを持つ不変オブジェクト～](https://codezine.jp/article/detail/10184)
- [ValueObjectという考え方](https://qiita.com/kichion/items/151c6747f2f1a14305cc)
- [参考サイト3](https://www.google.com/?hl=ja)