# lsp-yaml

[![CircleCI](https://circleci.com/gh/iquiw/lsp-yaml.svg?style=svg)](https://circleci.com/gh/iquiw/lsp-yaml)
[![Coverage Status](https://coveralls.io/repos/github/iquiw/lsp-yaml/badge.svg?branch=master)](https://coveralls.io/github/iquiw/lsp-yaml?branch=master)

YAML support for lsp-mode using [yaml-language-server](https://github.com/redhat-developer/yaml-language-server).

## Setup

### Prerequisite

Install yaml-language-server by npm.

``` console
$ npm install -g yaml-language-server
```

### Dependency

* [lsp-mode](https://github.com/emacs-lsp/lsp-mode)

### Configuration

To enable lsp-yaml in yaml-mode buffer, with [use-package](https://github.com/jwiegley/use-package),

``` emacs-lisp
(use-package lsp-yaml
  :commands lsp-yaml-enable
  :init
  (add-hook 'yaml-mode-hook #'lsp-yaml-enable))
```

### Customization

#### `lsp-yaml-format-enable`

Specify whether to enable YAML format feature.

Default is `nil`.

#### `lsp-yaml-format-options`

Specify YAML format options as plist, alist or hash table.
Specified options are converted to JSON object under `yaml.format` and sent to the server as is.

For example,

``` emacs-lisp
(:singleQuote t :bracketSpacing :json-false :proseWrap "preserve")
```

will be sent as

``` json
{
  "yaml": {
    "format": {
      "singleQuote": true,
      "bracketSpacing": false,
      "proseWrap": "preserve"
    }
  }
}
```

Refer to [Language Server Settings](https://github.com/redhat-developer/yaml-language-server#language-server-settings) of yaml-language-server for the detail.

Default is `nil`.

#### `lsp-yaml-language-server-dir`

Directory where yaml-language-server is installed.

Default is yaml-language-server installed under global NPM prefix directory.

#### `lsp-yaml-schemas`

Schemas plist or alist that associates schema with glob patterns.
This can be also a hash table.

For example,

``` emacs-lisp
(setq lsp-yaml-schemas '(:kubernetes "/*-k8s.yaml"))
```

Default is `nil`.

#### `lsp-yaml-validate`

Specify whether to enable YAML validation feature.

Default is `t`.

#### `lsp-yaml-hover`

Specify whether to enable hover feature.

Default is `t`.

#### `lsp-yaml-completion`

Specify whether to enable YAML autocompletion feature.

Default is `t`.
