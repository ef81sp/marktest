\version "2.18.2"

atacca = {
  \stopStaff s_\markup {
    \right-align attacca.
  }
}

mk = \new Voice {
  \compressFullBarRests
  \omit Rest
  \omit MultiMeasureRest
  \omit MultiMeasureRestNumber
  \key bes \major
  \tempo 4 = 120
  R1*2 \bar "||" |
  \key d \major
  \mark \default
  R1 |
  r2 r^"rit." |
  R1*2 |
  \bar "|." |
  \atacca
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