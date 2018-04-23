#! /bin/sh

cask emacs -Q -L . -l lsp-yaml-tests.el --batch -f ert-run-tests-batch-and-exit
