(require 'ert)

(when (require 'undercover nil t)
  (undercover "lsp-yaml.el"))

(require 'lsp-yaml)

(ert-deftest lsp-yaml-test-json-encoded-default-settings ()
  "Check if JSON encoded default settings are correct."
  (should
   (equal (json-encode (lsp-yaml--settings))
          "{\"yaml\":{\"format\":{\"enable\":false},\"schemas\":{},\"validate\":true}}")))

(ert-deftest lsp-yaml-test-json-encoded-multple-schemas ()
  "Check if JSON encoded settings with multiple schemas are correct."
  (let ((lsp-yaml-schemas
         '(:kubernetes "/kube.yaml" :kedge "/kedge.yaml")))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"format\":{\"enable\":false},\"schemas\":{\"kubernetes\":\"/kube.yaml\",\"kedge\":\"/kedge.yaml\"},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-multple-schemas-as-alist ()
  "Check if JSON encoded settings with multiple schemas alist is correct."
  (let ((lsp-yaml-schemas
         '(("kubernetes" . "/kube.yaml") ("kedge" . "/kedge.yaml"))))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"format\":{\"enable\":false},\"schemas\":{\"kubernetes\":\"/kube.yaml\",\"kedge\":\"/kedge.yaml\"},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-hash-table-schemas ()
  "Check if JSON encoded settings from hash table are correct."
  (let ((lsp-yaml-schemas (make-hash-table)))
    (puthash "http://example.com/schema.json" "/test.yaml" lsp-yaml-schemas)
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"format\":{\"enable\":false},\"schemas\":{\"http://example.com/schema.json\":\"/test.yaml\"},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-empty-schemas ()
  "Check if JSON encoded settings with empty schemas are correct."
  (let ((lsp-yaml-schemas nil))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"format\":{\"enable\":false},\"schemas\":{},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-validate-false ()
  "Check if JSON encoded settings are correct with validate false."
  (should
   (let ((lsp-yaml-validate nil))
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"format\":{\"enable\":false},\"schemas\":{},\"validate\":false}}"))))

(ert-deftest lsp-yaml-test-json-encoded-format-enable-true ()
  "Check if JSON encoded settings are correct with format.enable true."
  (should
   (let ((lsp-yaml-format-enable t))
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"format\":{\"enable\":true},\"schemas\":{},\"validate\":true}}"))))

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
