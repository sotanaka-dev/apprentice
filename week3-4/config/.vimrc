"カラースキーム
colorscheme molokai

"行番号表示
set number

"タイトル表示
set title

"カーソル行強調
set cursorline

"カーソル列強調
set cursorcolumn

"ステータスライン有効化
set laststatus=2

"文字コードを指定
set encoding=utf-8

"指定した文字コードで自動判別
set fileencodings=utf-8,shift-jis,euc-jp

"コマンドモードでも行末の1文字先までカーソル移動可能
set virtualedit=onemore

"次の行もインデント
set autoindent

"構文に基づいてインデントを自動調整
set smartindent

"タブ文字の幅を4スペースに設定
set tabstop=4

"インデントの幅を4スペースに設定
set shiftwidth=4

"タブ文字の代わりにスペースを挿入
set expandtab

"タブ文字の可視化
set list listchars=tab:\-\-\>,extends:»,precedes:«,trail:⋅

"jjでESC
inoremap jj <Esc>
