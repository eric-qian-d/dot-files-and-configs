--:PackerSync after adding packages or if you want to update them

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
    use ('wbthomason/packer.nvim')

    -- My plugins here

    -- Directory / searching plugins
    use("tpope/vim-vinegar")

    use {
      'nvim-telescope/telescope.nvim', tag = '0.1.1',
      requires = { {'nvim-lua/plenary.nvim'} },
      config = function()
          local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>z', builtin.find_files, {})
            vim.keymap.set('n', '<leader>a', builtin.live_grep, {})
            vim.keymap.set('n', ';', builtin.buffers, {})
            -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
            local telescope = require('telescope')
            local actions = require('telescope.actions')
          telescope.setup({
              defaults = {
                mappings = {
                    i = {
                        [ '<C-s>' ] = actions.select_horizontal
                    }
                }
              }
          })
      end
    }


    -- LSP plugins
    use ('neovim/nvim-lspconfig') -- Configurations for Nvim LSP
    use ( 'hrsh7th/nvim-cmp' ) -- Autocompletion plugin
    use({
      'weilbith/nvim-code-action-menu',
      cmd = 'CodeActionMenu',
    })
    use ( 'hrsh7th/cmp-nvim-lsp' ) -- LSP source for nvim-cmp
    use ( 'saadparwaiz1/cmp_luasnip' ) -- Snippets source for nvim-cmp
    use ( 'L3MON4D3/LuaSnip' ) -- Snippets plugin


    use({
        "glepnir/lspsaga.nvim",
        opt = true,
        branch = "main",
        event = "LspAttach",
        config = function()
            require("lspsaga").setup({
                finder = {
                    keys = {
                        vsplit = 'v',
                        split = 's',
                        quit = { "<ESC>", "q" },
                        expand_or_jump = '<cr>',
                    }
                },
                -- For peeking only
                definition = {
                    vsplit = '<C-c>v',
                    split = '<C-c>s',
                    quit = { "<ESC>", "q" },
                    edit = '<cr>',
                },
                code_action = {
                    keys = {
                        quit = "<ESC>",
                    }
                },
                rename = {
                    quit = "<ESC>"
                }
            })
        end,
        requires = {
            {"nvim-tree/nvim-web-devicons"},
            --Please make sure you install markdown and markdown_inline parser
            {"nvim-treesitter/nvim-treesitter"}
        }
    })


    -- Editing plugins
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {

        } end
    }

    use({
        'ggandor/leap.nvim',
        requires = { 'tpope/vim-repeat', opt = true },
        keys = { "s", "S" },
        config = function() 
            local leap = require "leap"
            leap.set_default_keymaps()
            leap.init_highlight(true)
        end,
    })

    -- Initialize  this after hop so that "<leader>s" in visual mode does surround
    use({
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    visual = "<leader>s",
                }
            })
            local surround = require("nvim-surround") 
               --'local' VisualSurround = require('nv'im-surround')'.visual
               --vim.keymap.set("x", "s", function()
                   --surround.visual_surround({ line_mode = false}) 
                --end, { buffer = true})
        end,
    })
    -- For generating docs; sometimes it doesn't work if the lsp isn't up and running
    use {
        "danymat/neogen",
        config = function()
            require('neogen').setup {}
            local neogen = require('neogen');
            local opts = { noremap = true, silent = true }
            vim.keymap.set("n", "<leader>gd", function()
                neogen.generate()
            end , opts)
        end,
        requires = "nvim-treesitter/nvim-treesitter",
        -- tag = "*"
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {
                mappings = {
                 basic = true,
                 extra = false,
                },
                toggler = {
                    line = '<leader>gl',
                    block = '<leader>gb',
                },
                opleader = {
                    line = '<leader>gl',
                    block = '<leader>gb',
                },
            }
        end
    }


    -- Git plugins
    use("tpope/vim-fugitive")
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                current_line_blame = true,
            }
        end
    }
    
    -- Visual plugins
    -- Editor 'theme'
    use {'navarasu/onedark.nvim'}
    -- Editor status line
    use {'nvim-lualine/lualine.nvim', 
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    use {
      "folke/todo-comments.nvim",
      requires = "nvim-lua/plenary.nvim",
      config = function()
        require("todo-comments").setup {
        }
      end
    }

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate all'}



  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  -- On update, need to run :PackerSync
  if packer_bootstrap then
    require('packer').sync()
  end
end)


require('onedark').setup {
    style = 'darker'
}
vim.cmd("highlight Comment ctermfg=gray")
require('onedark').load()

-- Initializing lualine has to come after onedark in order for proper UI to take effect
require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'dracula',
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
    },
}

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "javascript",   "typescript", "python", "rust", "lua", "vim", "help", "markdown", "markdown_inline" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  --ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    --disable = { "c", "rust" },
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}


vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Setup language servers.
local capabilities = require("cmp_nvim_lsp").default_capabilities()

local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'clangd', 'rust_analyzer', 'pyright', 'tsserver' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end

vim.diagnostic.get(0, {update_in_insert = true});
vim.diagnostic.get(0, {virtual_text = false});

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
    ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
    -- C-b (back) C-f (forward) for snippet placeholder navigation.
    --['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}



local keymap = vim.keymap.set

-- LSP finder - Find the symbol's definition
-- If there is no definition, it will instead be hidden
-- When you use an action in finder like "open vsplit",
-- you can use <C-t> to jump back
keymap("n", "gr", "<cmd>Lspsaga lsp_finder<CR>")

-- Code action
keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

-- Rename all occurrences of the hovered word for the entire file
keymap("n", "rn", "<cmd>Lspsaga rename<CR>")

-- Rename all occurrences of the hovered word for the selected files
keymap("n", "rN", "<cmd>Lspsaga rename ++project<CR>")

-- Peek definition
-- You can edit the file containing the definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gp", "<cmd>Lspsaga peek_definition<CR>")

-- Go to definition
keymap("n","gd", "<cmd>Lspsaga goto_definition<CR>")

-- Peek type definition
-- You can edit the file containing the type definition in the floating window
-- It also supports open/vsplit/etc operations, do refer to "definition_action_keys"
-- It also supports tagstack
-- Use <C-t> to jump back
keymap("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>")

-- Go to type definition
-- keymap("n","gt", "<cmd>Lspsaga goto_type_definition<CR>")


-- Show line diagnostics
-- You can pass argument ++unfocus to
-- unfocus the show_line_diagnostics floating window
keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

-- Show buffer diagnostics
keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

-- Show workspace diagnostics
keymap("n", "<leader>sw", "<cmd>Lspsaga show_workspace_diagnostics<CR>")

-- Show cursor diagnostics
keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

-- Diagnostic jump
-- You can use <C-o> to jump back to your previous location
keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

-- Diagnostic jump with filters such as only jumping to an error
keymap("n", "[g", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "]g", function()
  require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
end)
keymap("n", "[t", function()
  require("lspsaga.diagnostic"):goto_prev({ severity = { max= vim.diagnostic.severity.WARN } })
end)
keymap("n", "]t", function()
  require("lspsaga.diagnostic"):goto_next({ severity = { max= vim.diagnostic.severity.WARN } })
end)

-- Toggle outline
keymap("n","<leader>o", "<cmd>Lspsaga outline<CR>")

-- Hover Doc
-- If there is no hover doc,
-- there will be a notification stating that
-- there is no information available.
-- To disable it just use ":Lspsaga hover_doc ++quiet"
-- Pressing the key twice will enter the hover window
keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

-- If you want to keep the hover window in the top right hand corner,
-- you can pass the ++keep argument
-- Note that if you use hover with ++keep, pressing this key again will
-- close the hover window. If you want to jump to the hover window
-- you should use the wincmd command "<C-w>w"
-- keymap("n", "K", "<cmd>Lspsaga hover_doc ++keep<CR>")

-- Call hierarchy
keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

-- Floating terminal
keymap({"n", "t"}, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- local vimDiagnosticOpts = {severity_limit = vim.diagnostic.severity.ERROR}
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)

-- vim.api.nvim_set_var('vimDiagnosticJumpSeverity', 'Error')
-- vim.api.nvim_set_var('vimDiagnosticJumpSeverityOther', {'Warning', 'Information', 'Hint'})

-- vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, {severity = 'Error'})
-- vim.keymap.set('n', ']g', vim.diagnostic.goto_next, {severity = 'Error'})
-- vim.keymap.set('n', '[t', vim.diagnostic.goto_prev, {severity = vimDiagnosticJumpSeverityOther})
-- vim.keymap.set('n', ']t', vim.diagnostic.goto_next, {severity = vimDiagnosticJumpSeverityOther})

-- vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, {test = true})
-- vim.keymap.set('n', ']g', vim.diagnostic.goto_next, config)
-- vim.keymap.set('n', '[t', vim.diagnostic.goto_prev, {severity = vimDiagnosticJumpSeverityOther})
-- vim.keymap.set('n', ']t', vim.diagnostic.goto_next, {severity = vimDiagnosticJumpSeverityOther})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer







-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     -- Enable completion triggered by <c-x><c-o>
--     vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
--
--
--     -- Buffer local mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     local opts = { buffer = ev.buf }
--     vim.api.nvim_buf_set_keymap(ev.buf, 'n', 'gD', "<cmd> lua vim.lsp.buf.declaration()<CR>", {noremap = true, silent = true})
--     vim.api.nvim_buf_set_keymap(ev.buf, 'n', ']g', "<cmd> lua vim.diagnostic.goto_next({ severity = 'Error'})<CR>", {noremap = true, silent = true})
--     vim.api.nvim_buf_set_keymap(ev.buf, 'n', '[g', "<cmd> lua vim.diagnostic.goto_prev({ severity = 'Error'})<CR>", {noremap = true, silent = true})
--     vim.api.nvim_buf_set_keymap(ev.buf, 'n', ']t', "<cmd> lua vim.diagnostic.goto_next({ severity = {max= 'Warn'}})<CR>", {noremap = true, silent = true})
--     vim.api.nvim_buf_set_keymap(ev.buf, 'n', '[t', "<cmd> lua vim.diagnostic.goto_prev({ severity = {max= 'Warn'}})<CR>", {noremap = true, silent = true})
--     -- vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--     vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
--     vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
--     vim.keymap.set('n', '<space>wl', function()
--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--     end, opts)
--
--
--
--     local input_opts = {
--       prompt = "Enter something: ",
--       on_keypress = function(key)
--         -- Check if the pressed key is option+backspace
--         if key == "a" then
--           -- Return `false` to prevent the input dialog from closing
--           return false
--         end
--       end
--     }
--
--
--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
--     -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--     vim.keymap.set('n', 'gr', "<cmd> Telescope vim.lsp.buf.references()<CR>", opts)
--     vim.keymap.set('n', '<space>f', function()
--       vim.lsp.buf.format { async = true }
--     end, opts)
--
--     vim.api.nvim_create_autocmd("BufWritePre", {
--         buffer = ev.buf,
--         callback = function()
--             vim.lsp.buf.format { async = false }
--         end
--     })
--     -- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<C-n>', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
--     -- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<C-p>', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
--     -- vim.api.nvim_buf_set_keymap(ev.buf, 'n', '<CR>', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true, silent = true })
--   end,
-- })












--vim.cmd([[
    --" May need for vim (not neovim) since coc.nvim calculate byte offset by count
    --" utf-8 byte sequence.
    --set encoding=utf-8
    --" Some servers have issues with backup files, see #649.
    --set nobackup
    --set nowritebackup

    --" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    --" delays and poor user experience.
    --set updatetime=300

    --" Always show the signcolumn, otherwise it would shift the text each time
    --" diagnostics appear/become resolved.
    --set signcolumn=yes

    --" Use tab for trigger completion with characters ahead and navigate.
    --" NOTE: There's always complete item selected by default, you may want to enable
    --" no select by `"suggest.noselect": true` in your configuration file.
    --" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    --" other plugin before putting this into your config.
    --inoremap <silent><expr> <TAB>
          --\ coc#pum#visible() ? coc#pum#next(1) :
          --\ CheckBackspace() ? "\<Tab>" :
          --\ coc#refresh()
    --inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

    --" Make <CR> to accept selected completion item or notify coc.nvim to format
    --" <C-g>u breaks current undo, please make your own choice.
    --inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                  --\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

    --function! CheckBackspace() abort
      --let col = col('.') - 1
      --return !col || getline('.')[col - 1]  =~# '\s'
    --endfunction

    --" Use <c-space> to trigger completion.
    --if has('nvim')
      --inoremap <silent><expr> <c-space> coc#refresh()
    --else
      --inoremap <silent><expr> <c-@> coc#refresh()
    --endif

    --" Use `[g` and `]g` to navigate diagnostics
    --" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    --nmap <silent> [g <Plug>(coc-diagnostic-prev-error)
    --nmap <silent> ]g <Plug>(coc-diagnostic-next-error)
    --nmap <silent> [t <Plug>(coc-diagnostic-prev)
    --nmap <silent> ]t <Plug>(coc-diagnostic-next)

    --" GoTo code navigation.
    --nmap <silent> gd <Plug>(coc-definition)
    --nmap <silent> gy <Plug>(coc-type-definition)
    --nmap <silent> gi <Plug>(coc-implementation)
    --nmap <silent> gr <Plug>(coc-references)

    --" Use K to show documentation in preview window.
    --nnoremap <silent> K :call ShowDocumentation()<CR>

    --" Use <leader>wp to jump into preview
    --nnoremap <silent> <leader>wp :call coc#float#jump()<CR>
    --" Call :q in order to exit the window

    --function! ShowDocumentation()
      --if CocAction('hasProvider', 'hover')
        --call CocActionAsync('doHover')
      --else
        --call feedkeys('K', 'in')
      --endif
    --endfunction

    --" Highlight the symbol and its references when holding the cursor.
    --autocmd CursorHold * silent call CocActionAsync('highlight')

    --" Symbol renaming.
    --nmap <leader>rn <Plug>(coc-rename)

    --"" Formatting selected code.
    --"xmap <leader>f  <Plug>(coc-format-selected)
    --"nmap <leader>f  <Plug>(coc-format-selected)

    --augroup mygroup
      --autocmd!
      --" Setup formatexpr specified filetype(s).
      --autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      --" Update signature help on jump placeholder.
      --autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    --augroup end

    --"" Applying code actions to the selected code block.
    --"" Example: `<leader>aap` for current paragraph
    --"xmap <leader>p  <Plug>(coc-codeaction-selected)
    --"nmap <leader>p  <Plug>(coc-codeaction-selected)

    --" Remap keys for apply code actions at the cursor position.
    --nmap <leader>ac  <Plug>(coc-codeaction-cursor)
    --"" Remap keys for apply code actions affect whole buffer.
    --"nmap <leader>as  <Plug>(coc-codeaction-source)
    --" Apply the most preferred quickfix action to fix diagnostic on the current line.
    --nmap <leader>qf  <Plug>(coc-fix-current)

    --" Remap keys for apply refactor code actions.
    --nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
    --xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
    --nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

    --" Run the Code Lens action on the current line.
    --nmap <leader>cl  <Plug>(coc-codelens-action)

    --" Map function and class text objects
    --" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    --xmap if <Plug>(coc-funcobj-i)
    --omap if <Plug>(coc-funcobj-i)
    --xmap af <Plug>(coc-funcobj-a)
    --omap af <Plug>(coc-funcobj-a)
    --xmap ic <Plug>(coc-classobj-i)
    --omap ic <Plug>(coc-classobj-i)
    --xmap ac <Plug>(coc-classobj-a)
    --omap ac <Plug>(coc-classobj-a)

    --" Remap <C-f> and <C-b> for scroll float windows/popups.
    --if has('nvim-0.4.0') || has('patch-8.2.0750')
      --nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      --nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      --inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      --inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      --vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      --vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    --endif

    --" Use CTRL-S for selections ranges.
    --" Requires 'textDocument/selectionRange' support of language server.
    --nmap <silent> <C-s> <Plug>(coc-range-select)
    --xmap <silent> <C-s> <Plug>(coc-range-select)

    --" Add `:Format` command to format current buffer.
    --command! -nargs=0 Format :call CocActionAsync('format')

    --" Add `:Fold` command to fold current buffer.
    --command! -nargs=? Fold :call     CocAction('fold', <f-args>)

    --" Add `:OR` command for organize imports of the current buffer.
    --command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

    --" Add (Neo)Vim's native statusline support.
    --" NOTE: Please see `:h coc-status` for integrations with external plugins that
    --" provide custom statusline: lightline.vim, vim-airline.
    --set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

    --" Mappings for CoCList
    --" Show all diagnostics.
    --nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
    --" Manage extensions.
    --nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
    --" Show commands.
    --nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
    --" Find symbol of current document.
    --nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
    --" Search workspace symbols.
    --nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
    --" Do default action for next item.
    --nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
    --" Do default action for previous item.
    --nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
    --" Resume latest coc list.
    --nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
--]])
