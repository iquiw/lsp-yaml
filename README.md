# lsp-yaml

[![CircleCI](https://circleci.com/gh/iquiw/lsp-yaml.svg?style=svg)](https://circleci.com/gh/iquiw/lsp-yaml)

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
