" Description: Replace one word with another, keeping case.
" Author: Michael Geddes <michaelrgeddes@optushome.com.au>
" Date: Jan 2001
" Version: 1.1

" Usage: Using KeepCase or KeepCaseSameLen defined here, do a substitution like this:
" %s/\u\<old_word\>/\=KeepCaseSameLen(submatch(0), 'new_word')/g
" 
" * KeepCase( original_word , new_word )  
"   returns the new word maintaining case 
"   simply uses heuristics to work out some different common situations
"     given   NewWord
"     Word   	--> Newword
"     WORD    --> NEWWORD
"     word    --> newword
"     WoRd    --> NewWord
"     woRd    --> newWord
" 
" * KeepCaseSameLen( original_word , new_word )    
" 	Returns the new word maintaining case
" 	  Keeps the case exactly the same letter-for-letter
" 	  It does work if the words aren't the same length, as it truncates or
" 	  just coppies the case of the word for the length of the original word.


let keep_case_m1='^\u\l\+$'
let keep_case_r1='^\(.\)\(.\+\)$'
let keep_case_s1='\u\1\L\2'

let keep_case_m2='^\u\+$'
let keep_case_r2='^.\+$'
let keep_case_s2='\U&'

let keep_case_m3='^\l\+$'
let keep_case_r3='^.\+$'
let keep_case_s3='\L&'

let keep_case_m4='^\u.\+$'
let keep_case_r4='^.\+$'
let keep_case_s4='\u&'

let keep_case_m5='^\l.\+$'
let keep_case_r5='^.\+$'
let keep_case_s5='\l&'

fun! KeepCase( oldword, newword)
  let n=1
  while n <=5
	exe 'let mx = g:keep_case_m'.n
	if a:oldword =~ mx
	  exe 'let rx = g:keep_case_r'.n
	  exe 'let sx = g:keep_case_s'.n
	  return substitute(a:newword,rx,sx,'')
	endif
	let n=n+1
  endwhile
  return a:newword
endfun
"echo KeepCase('test','FreDrick')
"echo KeepCase('Test','FrEdRick')
"echo KeepCase('teSt','FrEdrIck')
"echo KeepCase('TEST','FredRick')

fun! KeepCaseSameLen( oldword, newword)
  let ret=''
  let i=0
  let len=strlen(a:oldword)
  while i<len
	if a:oldword[i] =~ '\u'
	  let ret=ret.substitute(a:newword[i],'.','\u&','')
	elseif a:oldword[i] =~ '\l'
	  let ret=ret.substitute(a:newword[i],'.','\l&','')
	else
	  let ret=ret.a:newword[i]
	endif
	let i=i+1
  endwhile
  let ret=ret.strpart(a:newword,i,strlen(a:newword))
  return ret
endfun

