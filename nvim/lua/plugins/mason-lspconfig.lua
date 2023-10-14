return {
  'williamboman/mason-lspconfig.nvim',

  config = function()
    local on_attach = function(_, bufnr)
      local function map_key(key, func, desc)
        return vim.keymap.set('n', key, func, {
          buffer = bufnr,
          desc = desc and 'LSP: ' .. desc
        })
      end

      map_key('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')
      map_key('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

      map_key('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
      map_key('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      map_key('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      map_key('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      map_key('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
      map_key('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      map_key('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      map_key('K', vim.lsp.buf.hover, 'Hover Documentation')
      map_key('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      local custom_formatters = {
        python = function()
          vim.cmd(':normal ma')
          vim.cmd(':silent :%!black --preview - -q 2>/dev/null')
          vim.cmd(':normal `a')
        end
      }

      local function format_buffer()
        local formatter = custom_formatters[vim.bo.filetype]
        formatter = formatter or vim.lsp.buf.format
        formatter()
      end

      map_key('<leader>cf', format_buffer, 'Format current buffer')

      -- Lesser used LSP functionality
      -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      -- nmap('<leader>wl', function()
      --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      -- end, '[W]orkspace [L]ist Folders')
    end

    local servers = {
      pyright = {},
      tsserver = {},
      html = { filetypes = { 'html' } },

      lua_ls = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    }

    require('neodev').setup()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local mason_lspconfig = require('mason-lspconfig')

    mason_lspconfig.setup({
      ensure_installed = vim.tbl_keys(servers),
    })

    mason_lspconfig.setup_handlers({
      function(server_name)
        require('lspconfig')[server_name].setup({
          capabilities = capabilities,
          on_attach = on_attach,
          settings = servers[server_name],
          filetypes = (servers[server_name] or {}).filetypes,
        })
      end
    })
  end
}
