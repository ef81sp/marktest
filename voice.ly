\version "2.18.2"

% 記号用Voice
mk = \new Voice {
  \compressFullBarRests % 長休符をまとめる

  \key bes \major
  \tempo 4 = 120

  s1*2 | \bar "||" |

  \key d \major
  \mark \default

  s1 |
  s2 s^"rit." |
  s1*2 | \bar "|."
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
  g2\f a |
  b c |
  R1*2 |
}