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

  vim-term = pkgs.vimUtils.buildVimPlugin {
    name = "vim-term";
    src = pkgs.fetchFromGitHub {
      owner = "akinsho";
      repo = "toggleterm.nvim";
      rev = "5bf839a558bf313fdbbe44824bcf3c4fe60502d0";
      sha256="JSftVs4OhmaN2tLoIPLEGCX3/tLjRa6usS6JBKUPNwU=";
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

          " Map leader to Space 
          let mapleader = " " 

          " Pmenu Setting
          hi Pmenu cterm=underline ctermfg=250 ctermbg=235 gui=underline guifg=#bcbcbc guibg=#262626
          hi PmenuSel cterm=underline ctermfg=250 ctermbg=131 gui=underline guifg=#bcbcbc guibg=#af5f5f

          " Windows 
          nnoremap <C-j> <C-w>j
          nnoremap <C-k> <C-w>k
          nnoremap <C-l> <C-w>l
          nnoremap <C-h> <C-w>h
          nnoremap <Leader>wv <C-w>v
          nnoremap <Leader>ws <C-w>s

          " Buffers
          nnoremap <Leader>bn :bn<CR>
          nnoremap <Leader>bp :bp<CR>
          nnoremap <Leader>bd :bd<CR>

          " Nerd Tree
          nnoremap <Leader>n :NERDTreeFocus<CR>
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


          " LSP Setting
          " Set internal encoding of vim, not needed on neovim, since coc.nvim using some
          " unicode characters in the file autoload/float.vim
          set encoding=utf-8

          " TextEdit might fail if hidden is not set.
          set hidden

          " Some servers have issues with backup files, see #649.
          set nobackup
          set nowritebackup

          " Give more space for displaying messages.
          set cmdheight=2

          " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
          " delays and poor user experience.
          set updatetime=300

          " Don't pass messages to |ins-completion-menu|.
          set shortmess+=c

          " Always show the signcolumn, otherwise it would shift the text each time
          " diagnostics appear/become resolved.
          if has("nvim-0.5.0") || has("patch-8.1.1564")
            " Recently vim can merge signcolumn and number column into one
            set signcolumn=number
          else
            set signcolumn=yes
          endif

          " Use tab for trigger completion with characters ahead and navigate.
          " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
          " other plugin before putting this into your config.
          inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ CheckBackspace() ? "\<TAB>" :
                \ coc#refresh()
          inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

          function! CheckBackspace() abort
            let col = col('.') - 1
            return !col || getline('.')[col - 1]  =~# '\s'
          endfunction

          " Use <c-space> to trigger completion.
          if has('nvim')
            inoremap <silent><expr> <c-space> coc#refresh()
          else
            inoremap <silent><expr> <c-@> coc#refresh()
          endif

          " Make <CR> auto-select the first completion item and notify coc.nvim to
          " format on enter, <cr> could be remapped by other vim plugin
          inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                        \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

          " Use `[g` and `]g` to navigate diagnostics
          " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
          nmap <silent> [g <Plug>(coc-diagnostic-prev)
          nmap <silent> ]g <Plug>(coc-diagnostic-next)

          " GoTo code navigation.
          nmap <silent> gd <Plug>(coc-definition)
          nmap <silent> gy <Plug>(coc-type-definition)
          nmap <silent> gi <Plug>(coc-implementation)
          nmap <silent> gr <Plug>(coc-references)

          " Use K to show documentation in preview window.
          nnoremap <silent> K :call ShowDocumentation()<CR>

          function! ShowDocumentation()
            if CocAction('hasProvider', 'hover')
              call CocActionAsync('doHover')
            else
              call feedkeys('K', 'in')
            endif
          endfunction

          " Highlight the symbol and its references when holding the cursor.
          autocmd CursorHold * silent call CocActionAsync('highlight')

          " Symbol renaming.
          nmap <leader>rn <Plug>(coc-rename)

          " Formatting selected code.
          xmap <leader>f  <Plug>(coc-format-selected)
          nmap <leader>f  <Plug>(coc-format-selected)

          augroup mygroup
            autocmd!
            " Setup formatexpr specified filetype(s).
            autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
            " Update signature help on jump placeholder.
            autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
          augroup end

          " Applying codeAction to the selected region.
          " Example: `<leader>aap` for current paragraph
          xmap <leader>a  <Plug>(coc-codeaction-selected)
          nmap <leader>a  <Plug>(coc-codeaction-selected)

          " Remap keys for applying codeAction to the current buffer.
          nmap <leader>ac  <Plug>(coc-codeaction)
          " Apply AutoFix to problem on the current line.
          nmap <leader>qf  <Plug>(coc-fix-current)

          " Run the Code Lens action on the current line.
          nmap <leader>cl  <Plug>(coc-codelens-action)

          " Map function and class text objects
          " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
          xmap if <Plug>(coc-funcobj-i)
          omap if <Plug>(coc-funcobj-i)
          xmap af <Plug>(coc-funcobj-a)
          omap af <Plug>(coc-funcobj-a)
          xmap ic <Plug>(coc-classobj-i)
          omap ic <Plug>(coc-classobj-i)
          xmap ac <Plug>(coc-classobj-a)
          omap ac <Plug>(coc-classobj-a)

          " Remap <C-f> and <C-b> for scroll float windows/popups.
          if has('nvim-0.4.0') || has('patch-8.2.0750')
            nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
            inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
            inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
            vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
            vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
          endif

          " Use CTRL-S for selections ranges.
          " Requires 'textDocument/selectionRange' support of language server.
          nmap <silent> <C-s> <Plug>(coc-range-select)
          xmap <silent> <C-s> <Plug>(coc-range-select)

          " Add `:Format` command to format current buffer.
          command! -nargs=0 Format :call CocActionAsync('format')

          " Add `:Fold` command to fold current buffer.
          command! -nargs=? Fold :call     CocAction('fold', <f-args>)

          " Add `:OR` command for organize imports of the current buffer.
          command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')


          " Mappings for CoCList
          " Show all diagnostics.
          nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
          " Manage extensions.
          nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
          " Show commands.
          nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
          " Find symbol of current document.
          nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
          " Search workspace symbols.
          nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
          " Do default action for next item.
          nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
          " Do default action for previous item.
          nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
          " Resume latest coc list.
          nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>


        '';
        packages.myVimPackage = with pkgs.vimPlugins; {
          start = [ LanguageClient-neovim 
	            coc 
                    nerd-commenter
                    nerd-tree
                    vim-nix
                    vim-term
	          ];

          opt = [ ];
        };
      };
    };
  };
}
