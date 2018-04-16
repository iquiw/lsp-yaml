(require 'ert)

(require 'lsp-yaml)

(ert-deftest lsp-yaml-test-json-encoded-default-schemas ()
  "Check if JSON encoded default `lsp-yaml-schemas' is correct."
  (should
   (equal (json-encode lsp-yaml-schemas)
          "{\"kubernetes\":\"/*-k8s.yaml\"}")))

(ert-deftest lsp-yaml-test-find-language-server-dir ()
  "Check if default directory of \"yaml-language-server\" is correct."
  (let ((exec-path (cons "test/bin" exec-path)))
    (should
     (equal (lsp-yaml--find-language-server-dir)
            "/opt/npm/node_modules/yaml-language-server"))))
