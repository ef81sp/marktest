\version "2.18.2"

atacca = {
  \stopStaff s_\markup {
    \right-align attacca.
  }
}

mk = \new Voice {
  \key bes \major % 調号
  \tempo 4 = 120 % テンポ記号

  R1*6 | % 長休符*6
  \bar "|." % 終止線
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