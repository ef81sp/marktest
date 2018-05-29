\version "2.18.2"

mk = \new Voice {
  \compressFullBarRests

  \omit MultiMeasureRest

  \key bes \major
  \tempo 4 = 120

  R1*2 \bar "||" | % 転調のための複縦線
  \key d \major % 調号
  \mark \default % リハーサルマーク
  R1 |
  r2 r^"rit." | % rit. 音符に付随するテキストは長休符NG
  R1*2 |
  \bar "|." | % 終止線
}

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