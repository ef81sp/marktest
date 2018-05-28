\version "2.18.2"
\include "voice.ly"

stfOne = \new Staff
  <<
    \mk
    \one
  >>

stfTwo = \new Staff \transpose bes c' {
  <<
    \mk
    \two
  >>
}