# 概要
曲を通して共通のものを各パートの音楽表記に混ぜて書くと、編成が大きくなるにつれて管理がつらくなってきます。
調号、練習番号、テンポ記号、拍子記号、発想記号……
これを音楽表記と分離することで、1回だけ書けばよい状態にします。

理解するにあたり、公式の[学習マニュアル](http://lilypond.org/doc/v2.18/Documentation/learning/index.ja.html)を読み通し、[記譜法リファレンス](http://lilypond.org/doc/v2.18/Documentation/notation/index.ja.html)の使い方がわかるようにしておくと良いと思います。

なお、QiitaにはLilyPondのシンタックスハイライトがないようです。。。
[GitHub](https://github.com/ef81sp/marktest)にはあるので、そちらに上げたものもよろしければご覧ください。


# 環境
LilyPond v2.18.2


# 結論
※サンプルソースは記事の最後と[GitHub](https://github.com/ef81sp/marktest)にあります。

## Voice
記号用のものを1つ、パート用はそれぞれ作る
* 記号用は長休符`R`で埋める。休符は`\omit`で消す。
  * 対象は `Rest`, `MultiMeasureRest`, `MultiMeasureRestNumber`
  *
* パート用には音符・パート固有の記号のみ書く
  * 音部記号、強弱記号……

## Staff
`<<` と `>>`で記号用のVoiceとパート用のVoiceを囲む

## Score
パート譜なら対象のStaffをひとつ書く。
総譜なら作ったStaffをすべて`<<` と `>>`で囲む。


# 実践
## ファイル構成
今回は記述内容が少ないので、階層は作らず全部同じディレクトリに放り込みます。
2パート作って、総譜とそれぞれのパート譜も作ります。
```
|- voice.ly
|- staff.ly
|- score.ly % 総譜
|- part1.ly % パート譜1
 - part2.ly % パート譜2
```
## ざっくり作る
### パートのVoiceを作る
適当に6小節くらい作ります。パート固有の記号や長休符も入れました。

```ly:voice.ly
\version "2.18.2"

one = \new Voice \relative c' {
  \clef "treble"
  c2\ff d |
  e f |
  g a |
  R1*2 |
  b2 c |
}

two = \new Voice \relative c {
  \clef "bass"
  c2\mf\< d |
  e f |
  g\f a |
  b c |
  R1*2 |
}
```

### 記号用Voiceを作る
追記していきます。とりあえず曲の最初に表示するものを書きます。
ついでに終止線も書きます。

```ly:voice.ly
\version "2.18.2"

% 記号用Voice
mk = \new Voice {
  \compressFullBarRests % 連続する全休符を長休符にまとめる

  \key bes \major % 調号
  \tempo 4 = 120 % テンポ記号

  R1*6 | % 長休符*6
  \bar "|." % 終止線
}

one = \new Voice \relative c' {
% ▼▼▼ 省略 ▼▼▼
```

## StaffとScoreを作る
Staffです。これはちょろいですね。

```ly:staff.ly
\version "2.18.2"
\include "voice.ly"

stfOne = \new Staff <<
  \mk % 記号
  \one % パート
>>

stfTwo = \new Staff<<
  \mk % 記号
  \two % パート
>>
```

Scoreです。まず総譜。ちょろいですね。
`#(ly:set-option 'relative-includes #t)`は`\include`を各ファイルからの相対パスで書けるようになるマジックワードです。

```ly:score.ly
#(ly:set-option 'relative-includes #t)
\version "2.18.2"
\include "staff.ly"

\new Score {
  <<
    \stfOne
    \stfTwo
  >>
}
```

パート譜もさらっと書きます。

```ly:part1.ly
#(ly:set-option 'relative-includes #t)
\version "2.18.2"
\include "staff.ly"

\new Score {
  \stfOne
}
```

```ly:part2.ly
#(ly:set-option 'relative-includes #t)
\version "2.18.2"
\include "staff.ly"

\new Score {
  \stfTwo
}
```

### コンパイル①
Score
![](img/1-score.png)

part1
![](img/1-part1.png)

part2
![](img/1-part2.png)

調号・テンポ記号・終止線が正しく入っているのがわかります。
しかし、余計な全休符が表示されています。こんどはこれを消しましょう。

## 余計な全休符を消す
### `\omit`を追加
記号用Voiceの上の方に追記します。

```ly:voice.ly
% ~~~
mk = \new Voice {
  \compressFullBarRests % 連続する全休符を長休符にまとめる

  \omit MultiMeasureRest % ★追記

  \key bes \major % 調号
  \tempo 4 = 120 % テンポ記号

  R1*6 | % 長休符*6
  \bar "|." % 終止線
}
% ~~~
```

`\omit` は、端的に言うと指定したオブジェクトの描画を行わなくするコマンドです。
厳密に言うと、オブジェクトの`stencil`プロパティを`#f`にする短縮記法です。
```
% この2つは同義
\override MultiMeasureRest.stencil = ##f
\omit MultiMeasureRest
```
詳細は公式ドキュメント[^1]をお読みください。

そして、`MultiMeasureRest`は長休符オブジェクトです。

### コンパイル②
Score
![](img/2-score.png)

part1
![](img/2-part1.png)

part2
![](img/2-part2.png)

余計な全休符が消えました！
次は、曲の途中にや最後に置く記号を追加しましょう。

## 曲の途中に置く記号を追加する
### リハーサルマーク・転調・rit
以下の作戦でいきます。

* 3小節目で転調(複縦線も) & リハーサルマーク
* 4小節目3拍目でrit.

```ly:voice.ly
% ~~~
mk = \new Voice {
  \compressFullBarRests

  \omit MultiMeasureRest

  \key bes \major
  \tempo 4 = 120

  R1*2 \bar "||" | % ★追記 転調のための複縦線
  \key d \major % ★追記 調号
  \mark \default % ★追記 リハーサルマーク
  R1 |
  r2 r^"rit." | % ★追記 rit. 音符に付随するテキストは長休符NG
  R1*2 |
  \bar "|." |
}
% ~~~
```
rit.のある行に注目です。
長休符にテキストをつけると意図した位置に表示できません。
通常の休符で2分休符を2つ入力し、2つ目の休符に`^"rit."`で付与します。

### コンパイル③
Score
![](img/3-score.png)

part1
![](img/3-part1.png)

part2
![](img/3-part2.png)

ritは意図したとおりに表示できましたが、余計な2分休符が出てしまいました。

さらに、part2の5-6小節目間の小節線上に「2」と表示されてしまっています。
これの正体は長休符の長さを表す数字です。
記号用の長休符を`\omit`したため、適切な位置に表示されません。

以上の2オブジェクトも消してしまいましょう。

## 通常の休符と長休符の数字を消す
### `\omit`を追加
方法は同じです。
対象のオブジェクトを記号用のVoiceから`\omit`していきます。

```ly:voice.ly
% ~~~
mk = \new Voice {
  \compressFullBarRests

  \omit MultiMeasureRest
  \omit Rest % ★追記 通常の休符
  \omit MultiMeasureRestNumber % ★追記 長休符の長さを示す数字

  \key bes \major
% ~~~
```

### コンパイル④
Score
![](img/4-score.png)

part1
![](img/4-part1.png)

part2
![](img/4-part2.png)

キレイに出ましたね！

## 最終形

Voice

```ly:voice.ly
\version "2.18.2"

% 記号用Voice
mk = \new Voice
  \compressFullBarRests % 長休符をまとめる

  \omit Rest % 通常の休符を消す
  \omit MultiMeasureRest % 長休符の記号を消す
  \omit MultiMeasureRestNumber % 長休符の長さを表す数字を消す

  \key bes \major
  \tempo 4 = 120

  R1*2 \bar "||" |

  \key d \major
  \mark \default

  R1 |
  r2 r^"rit." |
  R1*2 |
  \bar "|." |
}

% パート1
one = \new Voice \relative c' {
  \clef "treble"

  c2\ff d |
  e f |
  g a |
  R1*2 |
  b2 c |
}

% パート2
two = \new Voice \relative c {
  \clef "bass"

  c2\mf\< d |
  e f |
  g\f a |
  b c |
  R1*2 |
}
```

Staff

```ly:staff.ly
\version "2.18.2"
\include "voice.ly"  % voice.lyをinclud

stfOne = \new Staff
  <<
    \mk % 記号用Voice
    \one % パート1のVoice
  >>

stfTwo = \new Staff \transpose bes c' {
  <<
    \mk % 記号用Voice
    \two % パート2のVoice
  >>
}
```

Score

```ly:score.ly
#(ly:set-option 'relative-includes #t) % includeを各ファイルからの相対パスで書ける
\version "2.18.2"
\include "staff.ly"

\new Score {
  <<
    \stfOne
    \stfTwo
  >>
}
```

```ly:part1.ly
#(ly:set-option 'relative-includes #t)
\version "2.18.2"
\include "staff.ly"

\new Score {
  \stfTwo
}
```

```ly:part2.ly
#(ly:set-option 'relative-includes #t)
\version "2.18.2"
\include "staff.ly"

\new Score {
  \stfTwo
}
```

# 参考
[^1]: LilyPond — 学習マニュアル v2.18.2 (安定版). -- 4.3.1 オブジェクトの可視性と色 -- stencil プロパティ
<http://lilypond.org/doc/v2.18/Documentation/learning/visibility-and-color-of-objects#the-stencil-property>
