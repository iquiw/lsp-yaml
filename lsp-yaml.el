;;; lsp-yaml.el --- Yaml support for lsp-mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'lsp-mode)

(defgroup lsp-yaml nil
  "Yaml support for lsp-mode."
  :group 'lsp-mode)

(defun lsp-yaml--find-language-server-dir ()
  "Find default \"yaml-language-server\" directory using \"npm\" command."
  (let ((npm-prefix (ignore-errors
                      (with-output-to-string
                        (with-current-buffer standard-output
                          (process-file "npm" nil t nil "config" "get" "prefix")
                          (goto-char (point-min))
                          (replace-regexp "\n" "")))))
        (yaml-ls-dir (if (eq system-type 'windows-nt)
                         "node_modules/yaml-language-server"
                       "lib/node_modules/yaml-language-server")))
    (expand-file-name yaml-ls-dir npm-prefix)))

(defcustom lsp-yaml-language-server-dir (lsp-yaml--find-language-server-dir)
  "Directory where \"yaml-language-server\" is installed.")

(defcustom lsp-yaml-schemas '(:kubernetes "/*-k8s.yaml")
  "Schemas plist that associates schema with glob patterns.
This can be hash table instead of plist.")

(defun lsp-yaml--request-custom-schema (workspace &rest resource)
  nil)

(defun lsp-yaml--request-custom-schema-content (workspace &rest resource)
  nil)

(defun lsp-yaml--set-configuration ()
  "Notify lsp-yaml settings to server."
  (lsp--set-configuration (lsp-yaml--settings)))

(defun lsp-yaml--settings ()
  "Return lsp-yaml settings to be notified to server."
  `(:yaml
    (:schemas
     ,lsp-yaml-schemas)))

(defun lsp-yaml--initialize-client (client)
  (lsp-client-on-request client "custom/schema/request" #'lsp-yaml--request-custom-schema)
  (lsp-client-on-request client "custom/schema/content" #'lsp-yaml--request-custom-schema-content))

(lsp-define-stdio-client lsp-yaml "yaml"
                         (lambda () default-directory)
                         (list
                          "node"
                          (expand-file-name "out/server/src/server.js" lsp-yaml-language-server-dir)
                          "--stdio")
                         :initialize #'lsp-yaml--initialize-client)

(add-hook 'lsp-after-initialize-hook #'lsp-yaml--set-configuration)

(provide 'lsp-yaml)
;;; lsp-yaml.el ends here
