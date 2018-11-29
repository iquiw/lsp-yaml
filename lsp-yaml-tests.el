(require 'ert)

(when (require 'undercover nil t)
  (undercover "lsp-yaml.el"))

(require 'lsp-yaml)

(ert-deftest lsp-yaml-test-json-encoded-default-settings ()
  "Check if JSON encoded default settings are correct."
  (should
   (equal (json-encode (lsp-yaml--settings))
          "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":false},\"schemas\":{},\"validate\":true}}")))

(ert-deftest lsp-yaml-test-json-encoded-multple-schemas ()
  "Check if JSON encoded settings with multiple schemas are correct."
  (let ((lsp-yaml-schemas
         '(:kubernetes "/kube.yaml" :kedge "/kedge.yaml")))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":false},\"schemas\":{\"kubernetes\":\"/kube.yaml\",\"kedge\":\"/kedge.yaml\"},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-multple-schemas-as-alist ()
  "Check if JSON encoded settings with multiple schemas alist is correct."
  (let ((lsp-yaml-schemas
         '(("kubernetes" . "/kube.yaml") ("kedge" . "/kedge.yaml"))))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":false},\"schemas\":{\"kubernetes\":\"/kube.yaml\",\"kedge\":\"/kedge.yaml\"},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-hash-table-schemas ()
  "Check if JSON encoded settings from hash table are correct."
  (let ((lsp-yaml-schemas (make-hash-table)))
    (puthash "http://example.com/schema.json" "/test.yaml" lsp-yaml-schemas)
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":false},\"schemas\":{\"http://example.com/schema.json\":\"/test.yaml\"},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-empty-schemas ()
  "Check if JSON encoded settings with empty schemas are correct."
  (let ((lsp-yaml-schemas nil))
    (should
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":false},\"schemas\":{},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-validate-false ()
  "Check if JSON encoded settings are correct with validate false."
  (should
   (let ((lsp-yaml-validate nil))
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":false},\"schemas\":{},\"validate\":false}}"))))

(ert-deftest lsp-yaml-test-json-encoded-completion-false ()
  "Check if JSON encoded settings are correct with completion false."
  (should
   (let ((lsp-yaml-completion nil))
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":false,\"format\":{\"enable\":false},\"schemas\":{},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-format-enable-true ()
  "Check if JSON encoded settings are correct with format.enable true."
  (should
   (let ((lsp-yaml-format-enable t))
     (equal (json-encode (lsp-yaml--settings))
            "{\"yaml\":{\"completion\":true,\"format\":{\"enable\":true},\"schemas\":{},\"validate\":true}}"))))

(ert-deftest lsp-yaml-test-json-encoded-format-options-as-plist ()
  "Check if JSON encoded format options are correct from plist value."
   (let ((lsp-yaml-format-enable t)
         (lsp-yaml-format-options '(:singleQuote t :proseWrap "never")))
     (should
      (equal (json-encode (lsp-yaml--format-options))
             "{\"enable\":true,\"singleQuote\":true,\"proseWrap\":\"never\"}"))))

(ert-deftest lsp-yaml-test-json-encoded-format-options-as-alist ()
  "Check if JSON encoded format options are correct from alist value."
   (let ((lsp-yaml-format-enable nil)
         (lsp-yaml-format-options '(("bracketSpacing" . :json-false) ("proseWrap" . "always"))))
     (should
      (equal (json-encode (lsp-yaml--format-options))
             "{\"enable\":false,\"bracketSpacing\":false,\"proseWrap\":\"always\"}"))))

(ert-deftest lsp-yaml-test-json-encoded-format-options-as-hash-table ()
  "Check if JSON encoded format options are correct from hash table value."
   (let ((lsp-yaml-format-enable t)
         (lsp-yaml-format-options (make-hash-table)))
     (puthash "singleQuote" :json-false lsp-yaml-format-options)
     (puthash "bracketSpacing" t lsp-yaml-format-options)
     (puthash "proseWrap" "preserve" lsp-yaml-format-options)
     (let ((json (json-encode (lsp-yaml--format-options))))
       (should (string-match-p "\"enable\":true" json))
       (should (string-match-p "\"singleQuote\":false" json))
       (should (string-match-p "\"bracketSpacing\":true" json))
       (should (string-match-p "\"proseWrap\":\"preserve\"" json)))))

(ert-deftest lsp-yaml-test-json-encoded-format-options-error-invalid-type ()
  "Check if user-error is thrown for invalid format options."
  (let ((lsp-yaml-format-options (cons "singleQuote" t)))
    (should-error (lsp-yaml--format-options) :type 'user-error))
  (let ((lsp-yaml-format-options t))
    (should-error (lsp-yaml--format-options) :type 'user-error)))

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
