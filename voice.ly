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