-- https://github.com/johnsoncodehk/volar/discussions/441
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local script_path = os.getenv("HOME") .. "/.local/src/volar/node_modules/@volar/server/out/index.js"
local tslib_path = os.getenv("HOME") .. "/.local/src/volar/node_modules/typescript/lib/tsserverlibrary.js"
local status, nvim_lsp = pcall(require, "lspconfig")

if (not status) then return end
configs.volar = {
  default_config = {
    cmd = {"node", script_path, "--stdio"},
    filetypes = {"vue"},
    root_dir = util.root_pattern("package.json", ".git/");
    init_options = {
      typescript = {
        serverPath = tslib_path
      },
      languageFeatures = {
        references =  true,
        definition = true,
        typeDefinition = true,
        callHierarchy = true,
        hover = true,
        rename = true,
        renameFileRefactoring = true,
        signatureHelp = true,
        codeAction = true,
        completion = {
          defaultTagNameCase = 'both',
          defaultAttrNameCase = 'kebabCase',
          getDocumentNameCasesRequest = false,
          getDocumentSelectionRequest = false,
        },
        schemaRequestService = true,
        documentHighlight = true,
        documentLink = true,
        codeLens = { showReferencesNotification = true },
        semanticTokens = true,
        diagnostics = true,
      },
      documentFeatures = {
        selectionRange = false,
        foldingRange = false,
        linkedEditingRange = true,
        documentSymbol = true,
        documentColor = true,
        documentFormatting = {
          defaultPrintWidth = 100,
          getDocumentPrintWidthRequest = true,
        },
      },
    },
    settings = {
      ['volar-api'] = {
        trace = {
          server = "off"
        }
      },
      ['volar-document'] = {
        trace = {
          server = "off"
        }
      },
      ['volar-html'] = {
        trace = {
          server = "off"
        }
      },
      volar = {
        codeLens = {
          references = true,
          pugTools = true,
          scriptSetupTools = true,
        },
        tagNameCase = 'both',
        attrNameCase = 'kebab',
        formatting = {
          printWidth = 100
        },
        autoCompleteRefs = true,
        preferredTagNameCase = 'auto',
        preferredAttrNameCase = 'auto-kebab',
      },
    };
  };
}

local on_attach = function(client, bufnr)
  if vim.fn.has("nvim-0.8") == 1 then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  else
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
  end
end

-- TypeScript

local lspconfig_opts = {
  on_attach = on_attach,
  filetypes = { 'vue' }
}

return {
  on_setup = function(server)
    if status then
      nvim_lsp.volar.setup(lspconfig_opts )
    else
      nvim_lsp.volar.setup({
        server = lspconfig_opts,
        -- dap = require(""),
      })
    end
  end
}


