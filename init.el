(require 'package)
(require 'cl)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("486759384769d44b22bb46072726c2cfb3ccc3d49342e5af1854784d505ffc01" "0e219d63550634bc5b0c214aced55eb9528640377daf486e13fb18a32bf39856" default)))
 '(package-selected-packages
   (quote
    (projectile jabber elixir-mode deft company-go go-company nasm-mode dockerfile-mode ledger-mode go-mode evil-anzu anzu evil-org which-key rust-mode aggressive-indent clj-refactor yaml-mode cider flycheck-haskell haskell-mode js2-mode rainbow-delimiters olivetti magit helm company evil-smartparens evil-surround evil smartparens zenburn-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3F3F3F" :foreground "#DCDCCC" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Source Code Pro")))))

(require 'package)

(menu-bar-mode -1)

(when window-system
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (set-fringe-style 0))

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5)

(column-number-mode 1)

(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/backup/" t)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(setq package-user-dir (expand-file-name "~/.emacs.d/elpa"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


(use-package zenburn-theme
  :init (load-theme 'zenburn))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (add-hook 'prog-mode-hook #'smartparens-mode)
  (sp-use-paredit-bindings))

(use-package evil
  :config
  (evil-mode 1)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (evil-ex-define-cmd "slurp" 'sp-forward-slurp-sexp)
  (evil-ex-define-cmd "barf" 'sp-forward-barf-sexp)
  (evil-ex-define-cmd "splice" 'sp-splice-sexp-killing-backward)
  (lexical-let ((default-color (cons (face-background 'mode-line)
                                     (face-foreground 'mode-line))))
    (add-hook 'post-command-hook
              (lambda ()
                (let ((color (cond ((minibufferp) default-color)
                                   ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                                   ((evil-emacs-state-p) '("#444488" . "#ffffff"))
                                   ((buffer-modified-p) '("#006fa0" . "#ffffff"))
                                   (t default-color))))
                  (set-face-background 'mode-line (car color))
                  (set-face-foreground 'mode-line (cdr color)))))))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

(use-package evil-smartparens
  :config (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode))

(use-package company
  :config (add-hook 'after-init-hook 'global-company-mode))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("M-y" . helm-show-kill-ring))
  :config (helm-mode 1))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :config
  (add-hook 'org-mode-hook
            #'olivetti-mode))

(use-package olivetti
  :mode ("\\.txt\\'" . olivetti-mode))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby")

(use-package whitespace
  :config (add-hook 'before-save-hook 'whitespace-cleanup))

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package js2-mode
  :init (setq js2-basic-offset 2)
  :mode "\\.js\\'")

(use-package haskell-mode
  :mode "\\.hs")

(use-package flycheck-haskell
  :config (add-hook 'flycheck-mode-hook #'flycheck-haskell-setup))

(use-package cider
  :config (setq cider-cljs-lein-repl
                "(do (require 'figwheel-sidecar.repl-api)
                     (figwheel-sidecar.repl-api/start-figwheel!)
                     (figwheel-sidecar.repl-api/cljs-repl))"))

(use-package clojure-mode
  :mode "\\.clj\\'|\\.boot\\'"
  :config
  (mapc (lambda (s) (put-clojure-indent s 1))
        '(describe describe-server it wcar query
                   init-state render render-state will-mount did-mount should-update
                   will-receive-props will-update did-update display-name will-unmount
                   describe-with-db describe-with-server swaggered context around
                   with facts fact match describe-with-mock-etl-state describe-with-es))
  (mapc (lambda (s) (put-clojure-indent s 2))
        '(GET* POST* PUT* DELETE* PATCH* context*
               GET POST PUT DELETE PATCH context)))

(use-package yaml-mode
  :mode "\\.yml\\'")

(use-package clj-refactor
  :init (setq cljr-favor-prefix-notation nil)
  :config (add-hook 'clojure-mode-hook (lambda ()
                                         (clj-refactor-mode 1)
                                         (cljr-add-keybindings-with-prefix "C-c C-r"))))

(use-package aggressive-indent
  :config (add-hook 'clojure-mode-hook 'aggressive-indent-mode))

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package flycheck
  :config (global-flycheck-mode))

(use-package which-key
  :config (which-key-mode))

(use-package evil-org
  :config (add-hook 'org-mode-hook 'evil-org-mode))

(use-package anzu
  :config
  (global-anzu-mode 1)
  (use-package evil-anzu))

(use-package web-mode
  :mode "\\.html\\'")

(use-package ledger-mode)

(use-package hcl-mode
  :mode "\\.tf\\'")

(use-package company-go)
(use-package go-mode
  :config (add-hook 'go-mode-hook
                    (lambda ()
                      (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)
                      (local-set-key (kbd "C-c C-f") 'gofmt)
                      (set (make-local-variable 'company-backends) '(company-go)))))

(defun my-elixir-do-end-close-action (id action context)
    (when (eq action 'insert)
      (newline-and-indent)
      (forward-line -1)
      (indent-according-to-mode)))

(use-package elixir-mode
  :mode "\\.exs?\\'"
  :config
  (sp-with-modes '(elixir-mode)
    (sp-local-pair "->" "end"
                   :when '(("RET"))
                   :post-handlers '(:add my-elixir-do-end-close-action)
                   :actions '(insert)))
  (sp-with-modes '(elixir-mode)
    (sp-local-pair "do" "end"
                   :when '(("SPC" "RET"))
                   :post-handlers '(:add my-elixir-do-end-close-action)
                                    :actions '(insert))))

(use-package deft
  :init
  (setq deft-extensions '("org"))
  (setq deft-auto-save-interval 10.0)
  :config
  (global-set-key (kbd "C-c d") 'deft)
  (evil-set-initial-state 'deft-mode 'insert))

(use-package jabber
  :config (setq jabber-account-list
                '(("logan.buckley@gmail.com"
                   (:network-server . "talk.google.com")
                   (:connection-type . ssl)
                   (:password . (getenv "GMAIL_PASS"))))))

(use-package projectile
  :config (projectile-mode t))

(defun open-dot-emacs ()
  "Open this file interactively."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(provide 'init)
;;;init.el ends here
