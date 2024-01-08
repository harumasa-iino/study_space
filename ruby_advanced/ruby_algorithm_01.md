# トピック
アルゴリズム演習

## 目標
課題アルゴリズムを確認作成する

### 課題に対しての学習内容
####　課題1
3の倍数の場合は数の代わりに"らんて"を返す
5の倍数の場合は数の代わりに"くん"を返す
3と5の公倍数の場合は数の代わりに"らんてくん"を返す
上記の条件に合致しない場合は数値を返す
返り値はresponse変数に格納する
algorithm_01メソッドの最終的な返り値はresponseを返す
```
def algorithm_01(number)
  response = []
  i = 1
  while i <= number
    if i % 3 == 0 && i % 5 == 0
      response << 'らんてくん'
    elsif i % 3 == 0
      response << 'らんて'
    elsif i %  5 == 0
      response << 'くん'
    else
      response << i
    end
    i += 1
  end
  p response
end
```
---
`解答例`
3でも5でも割りきれるではなく、15で割り切れるのifで良かった
```
def algorithm_01(number)
  response = []
  1.upto(number) do |num|
    if num % 15 == 0
      response << 'らんてくん'
    elsif num % 3 == 0
      response << 'らんて'
    elsif num % 5 == 0
      response << 'くん'
    else
      response << num
    end
  end
  response
end
```

#### 課題2
任意の文字列の順番を逆にした文字列を出力するプログラム(algorithm_02メソッド)を作成してください（極力sortメソッドは利用しないでください）。
```
def algorithm_02(word)
# 一度文字を分解してから反対にして文字を結合
  s = word.split(//)
  ary = []
  s.reverse_each do |x|
    ary << x
  end
  p ary.join
# reverseを使って反転する方法
  p word.reverse
end
```
---
`解答例`
word[i]で先頭から数えた文字を取り出せるため、配列の番号を指定しつつ文字の番号を後ろから入れていくことでreverseさせている
```
def algorithm_02(word)
  i = word.length - 1
  j = 0
  letters = []

  while (i >= 0) do
    letters[j] = word[i]
    i -= 1
    j += 1
  end

  letters.join
end
```
#### 課題3
任意の文字列の奇数番目、偶数番目の文字をそれぞれ取り出し、それぞれ連結して出力するプログラム(algorithm_03メソッド)を作成してください。
```
def algorithm_03(word)
  s = word.split(//)
  num = s.size
  i = 0
  ary1 = []
  ary2 = []
  while i <= num 
    if i % 2 == 0
      ary1 << s[i]
    else
      ary2 << s[i]
    end
    i += 1
  end
  p ary1.join + ary2.join
end
```
---
`解答例`
```
def algorithm_03(word)
  i = word.length
  j = 0
  array1 = []
  array2 = []

  while j < i do
    d = word.split('')
    if j % 2 == 0
      array1 << d[j]
    elsif j % 2 == 1
      array2 << d[j]
    end
    j += 1
  end

  array1.concat(array2).join
end
```
#### 課題4
英文を単語別に分け、各単語のアルファベット数を先頭からの単語順の配列で出力するプログラム(algorithm_04メソッド)を作成してください。なおコンマとピリオドは単語として含めないでください。
```
def algorithm_04(text)
  new_text = text.gsub(/[[:punct:]]/, '')
  words = new_text.split(" ")
  word_lengths = words.map(&:length)
  p word_lengths
end
```
---
`解答例`
やっていることは同じだがよりシンプルに1行でまとめることが出来る。また回答例の場合だと,.だけを取り除いてから、splitしてmapしている。map自体配列を作るので入れ込む必要は無かった
```
def algorithm_04(text)
  text.delete(',.').split.map{ |w| w.length }
end
```


## 参考サイト
- [Ruby 繰り返し](https://qiita.com/mojihige/items/d0881a7730c9085dd969)
- [Rubyで配列に要素を追加・挿入する](https://uxmilk.jp/21132)
- [Ruby 文字列を任意の文字数に分割する](https://qiita.com/paty-fakename/items/990fe9d57864054409e1)
- [配列をインデックス付きで逆順にeachする](https://qiita.com/long_long_float/items/dd7ea2e0788921945612)
- [文字列を連結する方法をわかりやすく解説](https://www.sejuku.net/blog/69797)
- [Rubyの文字列連結に関して知っておくべきこと](https://qiita.com/Kta-M/items/c7c2fb0b61b11d3a2c48)
- [split](https://docs.ruby-lang.org/ja/latest/method/String/i/split.html)
- [gsub](https://docs.ruby-lang.org/ja/latest/method/String/i/gsub.html)
- [Punct](https://qiita.com/grrrr/items/7c8811b5cf37d700adc4#:~:text=Alpha%7D%5Cp%7BDigit%7D%5D-,%5Cp%7BPunct%7D,-%E5%8F%A5%E8%AA%AD%E6%96%87%E5%AD%97%3A!%22%23%24%25%26%27()*%2B%2C%2D./%3A%3B%3C%3D%3E%3F%40%5B%5D%5E_)
- [【Ruby入門】数を数えるlengthメソッドの使い方](https://style.potepan.com/articles/29049.html)
- [Ruby mapメソッドの基本の使い方](https://zenn.dev/keyproducts/articles/e8e3c8aca68f3d)