\version "2.18.2"
\include "voice.ly" % voice.lyをinclude

stfOne = \new Staff <<
  \mk % 記号用Voice
  \one % パート1のVoice
>>

stfTwo = \new Staff <<
  \mk % 記号用Voice
  \two % パート2のVoice
>>
