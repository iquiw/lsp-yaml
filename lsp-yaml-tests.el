(require 'ert)

(require 'lsp-yaml)

(ert-deftest lsp-yaml-test-json-encoded-default-schemas ()
  "Check if JSON encoded default `lsp-yaml-schemas' is correct."
  (should
   (equal (json-encode lsp-yaml-schemas)
          "{\"kubernetes\":\"/*-k8s.yaml\"}")))

(ert-deftest lsp-yaml-test-find-language-server-dir-on-windows ()
  "Check if default directory of \"yaml-language-server\" is correct on Windows."
  (let ((exec-path (cons "test/bin" exec-path))
        (system-type 'windows-nt))
    (should
     (equal (lsp-yaml--find-language-server-dir)
            "/opt/npm/node_modules/yaml-language-server"))))

(ert-deftest lsp-yaml-test-find-language-server-dir-on-non-windows ()
  "Check if default directory of \"yaml-language-server\" is correct on non-Windows."
  (let ((exec-path (cons "test/bin" exec-path))
        (system-type 'gnu/linux))
    (should
     (equal (lsp-yaml--find-language-server-dir)
            "/opt/npm/lib/node_modules/yaml-language-server"))))
