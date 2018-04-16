(require 'ert)

(require 'lsp-yaml)

(ert-deftest lsp-yaml-test-json-encoded-default-schemas ()
  "Check if JSON encoded default `lsp-yaml-schemas' is correct."
  (should
   (equal (json-encode lsp-yaml-schemas)
          "{\"kubernetes\":\"/*-k8s.yaml\"}")))
