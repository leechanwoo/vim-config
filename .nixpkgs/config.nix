{pkgs}:
let 
  coc = pkgs.vimUtils.buildVimPlugin {
    name = "coc";
    src = pkgs.fetchFromGitHub {
      owner = "neoclide";
      repo = "coc.nvim";
      rev = "0fd56dd25fc36606afe2290240aecb6e6ab85092";
      sha256="qCeDt/FznXkvIZCgqq4SEVI6YIAz1CtY6Kkf1MPmhX8=";
    };
  };

  nerd-commenter = pkgs.vimUtils.buildVimPlugin {
    name = "nerd-commenter";
    src = pkgs.fetchFromGitHub {
      owner = "preservim";
      repo = "nerdcommenter";
      rev = "6d30ebcd428eb5a244229a125420a1e044b42b52";
      sha256="0k24jvTVFfPzl9S4kmUHmRmnGmEMfphWzclym0MVPvQ=";
    };
  };

  nerd-tree = pkgs.vimUtils.buildVimPlugin {
    name = "nerd-tree";
    src = pkgs.fetchFromGitHub {
      owner = "preservim";
      repo = "nerdtree";
      rev = "eed488b1cd1867bd25f19f90e10440c5cc7d6424";
      sha256="U2VcQMfxgXBAHaEOBMovIdISmomh8Ki+SFbem6iwnkI=";
    };
  };

  vim-nix = pkgs.vimUtils.buildVimPlugin {
    name = "vim-nix";
    src = pkgs.fetchFromGitHub {
      owner = "LnL7";
      repo = "vim-nix";
      rev = "7d23e97d13c40fcc6d603b291fe9b6e5f92516ee";
      sha256="W6ExP+iDNo5T8XazxHRpUiECGv+AU5PPoM4CmU7NV+0=";
    };
  };

in {
  packageOverrides = pkgs: with pkgs; {
    hnvim = neovim.override {
      configure = {
        customRC = ''

          set number 
          set tabstop=8
	  set softtabstop=0 
	  set expandtab 
	  set shiftwidth=2
          set smarttab
          set colorcolumn=80

          nnoremap <C-j> <C-w>j
          nnoremap <C-k> <C-w>k
          nnoremap <C-l> <C-w>l
          nnoremap <C-h> <C-w>h

          let mapleader = " " " map leader to Space

          " Nerd Tree
          nnoremap <leader>n :NERDTreeFocus<CR>
          nnoremap <C-n> :NERDTree<CR>
          nnoremap <C-t> :NERDTreeToggle<CR>
          nnoremap <C-f> :NERDTreeFind<CR>

          " Nerd Commenter
          " Create default mappings
          let g:NERDCreateDefaultMappings = 1

          " Add spaces after comment delimiters by default
          let g:NERDSpaceDelims = 1

          " Use compact syntax for prettified multi-line comments
          let g:NERDCompactSexyComs = 1

          " Align line-wise comment delimiters flush left instead of following code indentation
          let g:NERDDefaultAlign = 'left'

          " Set a language to use its alternate delimiters by default
          let g:NERDAltDelims_java = 1

          " Add your own custom formats or override the defaults
          let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

          " Allow commenting and inverting empty lines (useful when commenting a region)
          let g:NERDCommentEmptyLines = 1

          " Enable trimming of trailing whitespace when uncommenting
          let g:NERDTrimTrailingWhitespace = 1

          " Enable NERDCommenterToggle to check all selected lines is commented or not 
          let g:NERDToggleCheckAllLines = 1


          let g:LanguageClient_serverCommands = { 
            \ 'haskell': ['haskell-language-server-wrapper', '--lsp'], 
            \ }

          nnoremap <F5> :call LanguageClient_contextMenu()<CR>
          map <Leader>lk :call LanguageClient#textDocument_hover()<CR>
          map <Leader>lg :call LanguageClient#textDocument_definition()<CR>
          map <Leader>lr :call LanguageClient#textDocument_rename()<CR>
          map <Leader>lf :call LanguageClient#textDocument_formatting()<CR>
          map <Leader>lb :call LanguageClient#textDocument_references()<CR>
          map <Leader>la :call LanguageClient#textDocument_codeAction()<CR>
          map <Leader>ls :call LanguageClient#textDocument_documentSymbol()<CR>
        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ LanguageClient-neovim 
	            coc 
                    nerd-commenter
                    nerd-tree
                    vim-nix
	          ];

          opt = [ ];
        };
      };
    };
  };
}
