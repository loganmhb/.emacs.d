(require 'package)
(require 'cl)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4bfced46dcfc40c45b076a1758ca106a947b1b6a6ff79a3281f3accacfb3243c" "0e0c37ee89f0213ce31205e9ae8bce1f93c9bcd81b1bcda0233061bb02c357a8" "086970da368bb95e42fd4ddac3149e84ce5f165e90dfc6ce6baceae30cf581ef" "444238426b59b360fb74f46b521933f126778777c68c67841c31e0a68b0cc920" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" "764384e88999768f00524dd3af6e873c62753649aa20ca530848fb6eb00f885b" "065a4fef514889dfd955ec5bf19a4916bcb223b608b20893c526749708bc5b97" "182d47cd9c220b3c9139ebeba0c3bd649947921af86587d9e57838686a6505ee")))
 '(js-indent-level 2)
 '(js2-bounce-indent-p t)
 '(js2-strict-trailing-comma-warning nil)
 '(org-agenda-files (quote ("~/log.org")))
 '(package-selected-packages
   (quote
    (mu4e restclient eziam-theme tao-theme js2-refactor hcl-mode web-mode geiser racket racket-mode flycheck-rust bison-mode company-anaconda racer groovy-mode ensime protobuf-mode eclim emacs-eclim-mode emacs-eclim projectile jabber elixir-mode deft company-go go-company nasm-mode dockerfile-mode ledger-mode go-mode evil-anzu anzu evil-org which-key rust-mode aggressive-indent clj-refactor yaml-mode cider flycheck-haskell haskell-mode js2-mode rainbow-delimiters olivetti magit helm company evil-smartparens evil-surround evil smartparens zenburn-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "nil" :family "Source Code Pro")))))

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

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

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
  (evil-set-initial-state 'term-mode 'emacs)
  (evil-set-initial-state 'ansi-term-mode 'emacs)
  (evil-set-initial-state 'org-capture-mode 'insert)
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
  (global-set-key (kbd "C-c a") 'org-agenda)
  (add-hook 'org-mode-hook
            #'olivetti-mode)

  (setq org-plantuml-jar-path "/opt/plantuml/plantuml.jar")
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (clojure . t)
     (plantuml . t)))

  (setq org-default-notes-file "~/notes.org")
  (setq org-agenda-files '("~/notes.org"))
  (global-set-key (kbd "C-c c") #'org-capture)
  (add-hook 'org-capture-mode-hook (lambda () (evil-local-mode -1)))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/notes.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+olp+datetree "~/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")))
  (setq org-mu4e-link-query-in-headers-mode nil))

(use-package olivetti
  :mode ("\\.\\(txt|org|md|markdown\\)\\'" . olivetti-mode))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby")

(use-package whitespace
  :config (add-hook 'before-save-hook 'whitespace-cleanup))

;; (use-package rainbow-delimiters
;;   :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package js2-mode
  :mode "\\.jsx?\\'"
  :config
  (custom-set-variables
   '(js2-basic-offset 2)
   '(js2-bounce-indent-p t)))

(use-package js2-refactor
  :config
  (add-hook 'j2-mode-hook #'js2-refactor-mode)
  (setq js2-skip-preprocessor-directives t)
  (js2r-add-keybindings-with-prefix "C-c C-r"))

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
                   with facts fact match describe-with-mock-etl-state describe-with-es prop/for-all))
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
  :mode "\\.rs\\'|\\.lalrpop\\'"
  :config (add-hook 'before-save-hook (lambda ()
                                        (when (eq major-mode 'rust-mode)
                                          'rust-save-hook))))

(use-package flycheck
  :config (global-flycheck-mode))

(use-package which-key
  :config (which-key-mode))

(use-package anzu
  :config
  (global-anzu-mode 1)
  (use-package evil-anzu))

(use-package web-mode
  :mode "\\.html\\'")

(defun lmb-new-transaction ()
  "Prompts the user for the information necessary to format a basic Ledger transaction."
  (interactive)
  (let ((date (read-from-minibuffer "Date: " (format-time-string "%Y-%m-%d")))
        (title (read-from-minibuffer "Title: "))
        (cost (read-from-minibuffer "Cost: "))
        (category (read-from-minibuffer "Expense category: ")))
    (insert date " " title)
    (newline)
    (insert "    Expenses:" category "  " cost)
    (newline)
    (insert "    Assets:Checking")
    (newline)))

(use-package ledger-mode
  :mode "\\.dat\\'"
  :bind  ("C-c t" . lmb-new-transaction))

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

(use-package groovy-mode)

(use-package racer
  :init (setq racer-rust-src-dir "/home/logan/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src")
  :config (add-hook 'rust-mode-hook 'racer-mode))

(use-package geiser
  :config (local-set-key (kbd "C-c b") 'geiser-load-current-buffer))

(use-package restclient)

(use-package flycheck-rust
  :config (with-eval-after-load 'rust-mode
            (add-hook 'flycheck-mode-hook #'flycheck-rust-setup)) )

(defun open-dot-emacs ()
  "Open this file interactively."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun insert-lozenge ()
  "Insert the Pollen command character."
  (interactive)
  (insert "◊"))

(global-set-key (kbd "C-c C-z") 'insert-lozenge)
(commandp 'open-dot-emacs)

(add-to-list 'load-path "/home/logan/dev/tern/emacs/")

(autoload 'tern-mode "tern.el" t)

(autoload 'tern-auto-complete "tern-auto-complete.el" t)

(define-minor-mode morning-words-mode
  "Mode for counting morning words"
  :lighter " 750w"
  (make-variable-buffer-local
   (defvar starting-count (count-words (point-min) (point-max))
     "Word count in buffer when mode is activated"))
  (add-hook 'after-save-hook
            (lambda ()
              (let* ((latest-count (count-words (point-min) (point-max)))
                    (count-diff (- latest-count starting-count)))
                (if (> count-diff 750)
                    (message (format "Done! You have written %d words." count-diff)))))))

(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)
;; use mu4e for e-mail in emacs
(setq mail-user-agent 'mu4e-user-agent)

;; default
 (setq mu4e-maildir "~/.mail/gmail")

(setq mu4e-drafts-folder "/[Gmail]/Drafts")
(setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
(setq mu4e-trash-folder  "/[Gmail]/Trash")
(setq mu4e-refile-folder "/[Gmail]/All Mail")

;; don't save message to Sent Messages, Gmail/IMAP takes care of this
(setq mu4e-sent-messages-behavior 'delete)
(setq mu4e-change-filenames-when-moving t)

;; (See the documentation for `mu4e-sent-messages-behavior' if you have
;; additional non-Gmail addresses and want assign them different
;; behavior.)

;; setup some handy shortcuts
;; you can quickly switch to your Inbox -- press ``ji''
;; then, when you want archive some messages, move them to
;; the 'All Mail' folder by pressing ``ma''.
(setq mu4e-get-mail-command "mbsync gmail")

(setq mu4e-maildir-shortcuts
    '( ("/Inbox"               . ?i)
       ("/[Gmail]/Sent Mail"   . ?s)
       ("/[Gmail]/Trash"       . ?t)
       ("/[Gmail]/All Mail"    . ?a)))

(require 'org-mu4e)
(provide 'init)
;;;init.el ends here
