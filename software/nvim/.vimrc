let mapleader=" "

set showmode
set visualbell
set number
set ruler

set wrapscan
set incsearch
set smartcase

"""set hlsearch
"""set maxmapdepth
"""set history

set scroll=0
set scrolloff=0
set scrolljump=0
"""set startofline

"""set keymodel="startsel,stopsel"
"""set selection='inclusive'
"""set selectmode=""

set clipboard+=unnamed
"""set digraph
"""set iskeyword

""" Overrides ------------------------------------------------

""" typos
nnoremap cie ciw

""" Directionals and Extend Layer

nnoremap <Tab> >>
nnoremap <S-Tab> <<
vnoremap <Tab> >>gv
vnoremap <S-Tab> <<gv

nnoremap <Enter> i<Enter><ESC>

nnoremap i gk
nnoremap k gj
nnoremap j h
nnoremap h g^
nnoremap ç g$

nnoremap <A-Right> W
nnoremap <S-A-Right> vW
nnoremap <S-A-Left> vB
nnoremap <A-Left> B

vnoremap <A-Right> W
vnoremap <S-A-Right> W
vnoremap <A-Left> B
vnoremap <S-A-Left> B

nnoremap <Up> gk
nnoremap <Down> gj

nnoremap <leader>i i
nnoremap <leader>a a
vnoremap <leader>i <Esc>i
vnoremap <leader>a <Esc>a

nnoremap <Home> g^
nnoremap <C-Home> g^
nnoremap <C-S-Home> v^
nnoremap <S-Home> v^

nnoremap <End> g$
nnoremap <C-End> g$
nnoremap <C-S-End> v$
nnoremap <S-End> v$

nnoremap <S-Up> vk
nnoremap <S-Right> vl
nnoremap <S-Down> vj
nnoremap <S-Left> vh

inoremap <Home> <Esc>^i
inoremap <C-Home> <Esc>^i
inoremap <C-S-Home> <Esc>vg^
inoremap <S-Home> <Esc>vg^

inoremap <End> <Esc>$a
inoremap <C-End> <Esc>$a
inoremap <C-S-End> <Esc>lv$a
inoremap <S-End> <Esc>lv$

inoremap <S-Up> <Esc>vk
inoremap <S-Right> <Esc>vl
inoremap <S-Down> <Esc>vj
inoremap <S-Left> <Esc>vh

nnoremap <A-Right> W
nnoremap <A-Left> B

nnoremap <leader>i i
nnoremap <leader>a a

vnoremap <leader>i <Esc>i
vnoremap <leader>a <Esc>a

vnoremap <Home> ^
vnoremap <C-Home> ^
vnoremap <C-S-Home> ^
vnoremap <S-Home> ^

vnoremap <End> $
vnoremap <C-End> $
vnoremap <C-S-End> $
vnoremap <S-End> $

"""vnoremap <Up> k
"""vnoremap <Down> j
"""vnoremap <Left> h
"""vnoremap <Right> l

vnoremap <S-Up> k
vnoremap <S-Down> j
vnoremap <S-Left> h
vnoremap <S-Right> l

""" ____________________ [Q] prefix controls [Q]uick commands

nnoremap q <Nop>
nnoremap qq <Esc>
nnoremap qe zz

nmap qo %
nnoremap qu {
nnoremap qp }

nnoremap qi <C-U>
nnoremap qk <C-D>
nnoremap qI gg
nnoremap qK G

vnoremap qi {
vnoremap qk }

nnoremap ql <C-I>
nnoremap qj <C-O>

vmap qo %
vnoremap qu {
vnoremap qp }

""" ____________________ [W] prefix is for [W]ord movement

Plug 'michaeljsmith/vim-ident-object' """Additional text objects: ai, ii, aI
   
    
"""nnoremap w <Nop>
"""nnoremap ww w

"""nnoremap wl w
"""nnoremap wj b
"""nnoremap wç W
"""nnoremap wh B

"""nnoremap wo e
"""nnoremap wu ge

""" ____________________ [E] prefix controls [E]dit cursor

nnoremap ee e
vnoremap ee e

nnoremap ea a """ Todo could be better

nnoremap ei O
nnoremap ek o
vnoremap ei <Esc>`<O
vnoremap ek <Esc>`>o

nnoremap ej bi
nnoremap el ea
vnoremap ej <Esc>`<i
vnoremap el <Esc>`>a

nnoremap eL Ea
nnoremap eJ Bi
""" no visual counterpart

nnoremap eç A
vnoremap eç A
nnoremap eh I
vnoremap eh I

nnoremap eu {a
nnoremap ep }i
""" no visual counterpart

nnoremap eo %a
vnoremap eo <Esc>%i

nnoremap eml ]wa
nnoremap emj [bi
vnoremap eml <Esc>`>]wa
vnoremap emj <Esc>`<[bi

"" Experimental
nnoremap e, /,<CR>i
nnoremap e; /;<CR>i
nnoremap e) /)<CR>i
nnoremap e( /(<CR>i
nnoremap e? /?<CR>i
nnoremap ed /{<CR>i

""" ____________________ [R] prefix controls [R]efactoring

nnoremap r <Nop>
nnoremap rj J
nnoremap rr gq
vnoremap rr gq

vnoremap rsp :sort i<CR>
vnoremap rsP :sort! i<CR>

nnoremap rd "ayy"ap
vnoremap r. :s/)\./)\r./g<CR>
vnoremap r, :s/,/,\r/g<CR>

""" ____________________ [T] prefix is unmodified

""" ____________________ [Y] prefix is for yanking

Plug 'machakann/vim-highlightedyank'
let g:highlightedyank_highlight_duration = "1000"
let g:highlightedyank_highlight_color = "rgba(100, 160, 100, 100)"

""" ____________________ [U] prefix is unmodified

""" ____________________ [I] prefix is directional

""" ____________________ [O] prefix controls [O]pening of popups

nnoremap o <Nop>
vnoremap o <Nop>
vnoremap oi o

""" ____________________ [P] prefix controls [P]asting
vnoremap p "ad<Esc>p
vnoremap P "ad<Esc>P

"""___________________________________________________________________________________________________________________________________________________

""" ____________________ [A] prefix is Undetermined

nnoremap an <C-a>
vnoremap an <C-a>gv
nnoremap aN <C-x>
vnoremap aN <C-x>gv

nnoremap An g<C-a>
vnoremap An g<C-a>
nnoremap AN g<C-x>
vnoremap AN g<C-x>

""" ____________________ [S] Prefix Controls [S]urroundings

Plug 'tpope/vim-surround'
nnoremap s <Nop>

" Java
nnoremap so vi<"ay/><CR>v?\<<CR>B"ap
nmap sfl viwS)<leader>iCollections.singletonList
vmap sfl S)<leader>iCollections.singletonList
nnoremap sqo ea><Esc>biOptional<
nnoremap sql viw<Esc>a><Esc>biList<

""" ____________________ [D] Prefix Controls [D]eletions

nnoremap d<Space> "adf<Space>
nnoremap dl "adt
nnoremap dj "adT
nnoremap dk "adl
nnoremap di "adl

nnoremap d<Home> "ad<Home>
nnoremap dh "ad<Home>

nnoremap d<End> "ad<End>
nnoremap dç "ad<End>

nnoremap do d%
nnoremap dp d}
nnoremap du d{

""" nnoremap D "adt
""" nnoremap DD "aD
""" nnoremap dip "adipO<Esc>

nnoremap <Del> "adl
nnoremap <C-Del> "adw
nnoremap <Backspace> "adh
nnoremap <C-Backspace> "adb

vnoremap <Del> "ad
vnoremap <C-Del> "ad
vnoremap <Backspace> "ad
vnoremap <C-Backspace> "ad

""" ____________________ [F] Prefix Controls [F]ind

Plug 'easymotion/vim-easymotion'
let g:EasyMotion_do_mapping = 0

nnoremap f <Nop>
nnoremap fu :set invhlsearch<CR>
nnoremap fk *
nnoremap fi #

nnoremap fn n
nnoremap fe t

nnoremap fr :s/
vnoremap fr :s/
nnoremap f. &
vnoremap f. &
nnoremap ff f
vnoremap ff f

" todo: finish these
" search for currently selected text 
""" vnoremap fk "ay/\V<C-R>=escape(@",'/\')<CR><CR>
" yank to search register
""" nnoremap fy viw"/y
""" vnoremap fy "/y
""" nnoremap <A-f>f /

""" ____________________ [G] Prefix is directional ( Home )
""" ____________________ [J] Prefix is directional ( Left )
""" ____________________ [K] Prefix is directional ( Down )
""" ____________________ [L] Prefix is directional ( Right )
""" ____________________ [Ç] Prefix is directional ( End )

"""___________________________________________________________________________________________________________________________________________________

""" ________________________________ [Z] prefix controls [Z]ooming, [Z]ips and Scroll

nnoremap zz zz
nnoremap zi zb
vnoremap zi zb
nnoremap zk zt
vnoremap zk zt
nnoremap zl zL
nnoremap zj zH

""" ________________________________ [X] prefix controls code stuff


nnoremap x <Nop>

" region collapse
nnoremap x. zo
nnoremap x, zc
nnoremap x0 zM

" next method fallback
nnoremap xi [m
nnoremap xk ]m

""" ________________________________ [C] prefix controls [C]hanging

nnoremap cl "act
nnoremap cL "acf

nnoremap cj "acT
nnoremap cJ "acF

nnoremap c<Home> "ac<Home>
nnoremap cç "ac<Home>
nnoremap c<End> "ac0
nnoremap ch "ac0

nnoremap ck "acl
nnoremap ci "acl

nnoremap co c%

""" ________________________________ [V] prefix controls [V]isual selections

nnoremap vl vt
nnoremap vL vf
nnoremap vj vT
nnoremap vJ vF
nnoremap vç vg_
nnoremap v<End> vg_
nnoremap vh v^
nnoremap v<Home> v^

nnoremap vk v
nnoremap vK <C-v>j
" nnoremap vi -> vi is inside dummy

nnoremap V <C-v>
vnoremap V <C-v>

nnoremap vv V
nnoremap viv g^vg_
nnoremap vpa va}V
nnoremap vpf va)V

""" ________________________________ [B] prefix is unmodified

""" ________________________________ [N] prefix controls [N]avigation

nnoremap n <Nop>
nnoremap nn n
nnoremap nd gD
vnoremap nd <Esc>gD

nnoremap nI G
vnoremap nI G
nnoremap nK gg
vnoremap nK gg

""" ________________________________ [M] prefix controls [M]ovements

nnoremap mo v%

""" todo: Declare this properly as functions here, 
"""       use these hardcoded as a fallback for 
"""       emulators without vimscript support

" move quote
nnoremap mq /"<CR>vi"
vnoremap mq /"<CR><Esc>/"<CR>vi"
nnoremap mQ ?"<CR>vi"
vnoremap mQ ?"<CR><Esc>?"<CR>nvi"

" seek ahead camel case
nnoremap me ]w[bv]w
vnoremap me <Esc>]w[bv]w
nnoremap mE [bv]w
vnoremap mE <Esc>[b[bv]w
nnoremap vie ]wv[b

" move curly 
nnoremap ma /{<CR>zovi}
vnoremap ma o<Esc>/{<CR>zovi}
nnoremap mA ?}<CR>vi}
vnoremap mA <Esc>?{<CR>nvi}

" move function call
nnoremap mf /(<CR>vi)
vnoremap mf o<Esc>/(<CR>vi(
nnoremap mF ?)<CR>vi)
vnoremap mF o<Esc>?)<CR>vi(

" ms is busy

" move [list]
nnoremap ml /[<CR>vi[
vnoremap ml o<Esc>/[<CR>vi[
nnoremap mL ?]<CR>vi[
vnoremap mL /[<CR><Esc>nvi[

" move class
nnoremap mz /class/b-1<CR>viw 
vnoremap mz <Esc>/class/b-1<CR>viw

" mc is busy

" move number
nnoremap mn /[0-9]\+/<CR>viw
vnoremap mn <Esc>/[0-9]\+/<CR>viw
nnoremap mN ?[0-9]\+?<CR>viw
nnoremap mN <Esc>?[0-9]\+?<CR>viw

" next angle
nnoremap m> /><CR>vi>
vnoremap m> <Esc>/><CR>nvi>
nnoremap m< ?><CR>vi>
vnoremap m< <Esc>?><CR>vi>

" move punctuation
nnoremap m, v/,/e-1<CR>
vnoremap m, /,/e-1<CR>
nnoremap m. v/\./e-1<CR>
vnoremap m. /\./e-1<CR>
nnoremap m; v/;<CR>
vnoremap m; /;<CR>

""" Java - move definition
nnoremap md /= \+/e1<CR>v/;/b-1<CR>
vnoremap md o<Esc>/= \+/e1<CR>v/;/b-1<CR>
nnoremap mD ?= \+?e1<CR>v/;/v-1<CR>
vnoremap mD o<Esc>?= \+?e1<CR>v/;/v-1<CR>

""" Java - move method call - cant use mc because of multicursor remaps.
nnoremap mm /\S(/e-1<CR>v?\v[ ()=.]?e+1<CR>o
vnoremap mm <Esc>/\S(/e-1<CR>v?\v[ ()=.]?e+1<CR>o
nnoremap mM ?(?e-1<CR>vBo
vnoremap mM <Esc>?(?e-1<CR>vBo

"""___________________________________________________________________________________________________________________________________________________

""" Experimental -----------------------------------------

noremap Q q
noremap am @
noremap a. @@
xnoremap <Leader>, :<UP><CR>

" Java
nnoremap <leader>jj $h"ayiw^i@JsonProperty("<Esc>"apli")<Space><Esc>
nmap <leader>jt viveç}<Esc>vivehassertThatThrownBy{<Esc>ek.isInstanceOf(
vmap <leader>je el)<Esc>gvejassertThat(<Esc>qo<leader>a.isEqualTo(
nmap <leader>je el)<Esc>ejassertThat(<Esc>qo<leader>a.isEqualTo(
nnoremap <leader>jj $h"ayiw^i@JsonProperty("<Esc>"apli")<Space><Esc>

""" Meta ------------------------------------------------- 

nnoremap <leader>wr :w<CR>:source ~\.vimrc<CR>
nnoremap <leader>vim :e ~/.vimrc<CR>
nnoremap <leader>vii :e ~/.ideavimrc<CR>

if has('neovim')
lua << EOF

require "init.mac"

EOF
endif