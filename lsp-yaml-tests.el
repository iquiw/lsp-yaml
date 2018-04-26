(require 'ert)

(require 'lsp-yaml)

(ert-deftest lsp-yaml-test-json-encoded-default-settings ()
  "Check if JSON encoded default settings are correct."
  (should
   (equal (json-encode (lsp-yaml--settings))
          "{\"yaml\":{\"schemas\":{\"kubernetes\":\"/*-k8s.yaml\"}}}")))

(ert-deftest lsp-yaml-test-json-encoded-multple-schemas ()
  "Check if JSON encoded settings with multiple schemas are correct."
  (let ((lsp-yaml-schemas
         '(:kubernetes "/kube.yaml" :kedge "/kedge.yaml")))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"schemas\":{\"kubernetes\":\"/kube.yaml\",\"kedge\":\"/kedge.yaml\"}}}"))))

(ert-deftest lsp-yaml-test-json-encoded-multple-schemas-as-alist ()
  "Check if JSON encoded settings with multiple schemas alist is correct."
  (let ((lsp-yaml-schemas
         '(("kubernetes" . "/kube.yaml") ("kedge" . "/kedge.yaml"))))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"schemas\":{\"kubernetes\":\"/kube.yaml\",\"kedge\":\"/kedge.yaml\"}}}"))))

(ert-deftest lsp-yaml-test-json-encoded-hash-table-schemas ()
  "Check if JSON encoded settings from hash table are correct."
  (let ((lsp-yaml-schemas (make-hash-table)))
    (puthash "http://example.com/schema.json" "/test.yaml" lsp-yaml-schemas)
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"schemas\":{\"http://example.com/schema.json\":\"/test.yaml\"}}}"))))

(ert-deftest lsp-yaml-test-json-encoded-empty-schemas ()
  "Check if JSON encoded settings with empty schemas are correct."
  (let ((lsp-yaml-schemas nil))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"schemas\":{}}}"))))

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
