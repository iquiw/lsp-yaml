;;; lsp-yaml.el --- Yaml support for lsp-mode -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(require 'lsp-mode)

(defgroup lsp-yaml nil
  "Yaml support for lsp-mode."
  :group 'lsp-mode)

(defcustom lsp-yaml-language-server-dir
  (ignore-errors
    (expand-file-name "node_modules/yaml-language-server"
                      (with-output-to-string
                        (with-current-buffer standard-output
                          (process-file "npm" nil t nil "config" "get" "prefix")
                          (goto-char (point-min))
                          (replace-regexp "\n" "")))))
  "Directory where \"yaml-language-server\" is installed.")

(defcustom lsp-yaml-schemas '(:kubernetes "/*-k8s.yaml")
  "Schemas alist that associates schema with glob patterns.")

(defun lsp-yaml--request-custom-schema (workspace &rest resource)
  nil)

(defun lsp-yaml--request-custom-schema-content (workspace &rest resource)
  nil)

(defun lsp-yaml--set-configuration ()
  (lsp--set-configuration
   `((:yaml
      (:schemas
       ,lsp-yaml-schemas)))))

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
