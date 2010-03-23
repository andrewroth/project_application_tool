class ExtrasManifest < ShadowPuppet::Manifest
  recipe :foo

  def foo
    user = ENV['SUDO_USER']

    package('vim-full', :ensure => :installed)

    vimrc = <<-VIMRC
runtime! debian.vim
syntax on
"set background=dark
if has("autocmd")
  filetype plugin indent on
endif

set nocompatible
filetype plugin indent on
set mouse=a

runtime! macros/matchit.vim

augroup myfiletypes
  autocmd!
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END

"set showtabline=2
set tabpagemax=15
nnoremap <silent> <C-n> :tabnext<CR>
nnoremap <silent> <C-p> :tabprevious<CR>
nnoremap <silent> <C-t> :tabnew<CR>
VIMRC
    file "/etc/vim/vimrc", :ensure => :present,
    :content => vimrc
    package "vim-ruby", :ensure => :installed, :provider => :gem, 
      :before => exec("install_vim_ruby")
    exec "install_vim_ruby",
      :command => "vim-ruby-install.rb --directory /usr/share/vim/vimfiles"

    end
end
