(require 'package)
(require 'cl)

(defvar bootstrap-version)
(setq straight-use-package-by-default t)

(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("246a9596178bb806c5f41e5b571546bb6e0f4bd41a9da0df5dfbca7ec6e2250c" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3" "f5b6be56c9de9fd8bdd42e0c05fecb002dedb8f48a5f00e769370e4517dde0e8" "5fce29142d617d53dbc0f9a98e3be80fa1256f16e860aec70ef68e699f37c6aa" "e3b2bad7b781a968692759ad12cb6552bc39d7057762eefaf168dbe604ce3a4b" "583148e87f779040b5349db48b6fcad6fe9a873c6ada20487e9a1ec40d845505" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "801a567c87755fe65d0484cb2bded31a4c5bb24fd1fe0ed11e6c02254017acb2" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" "24fc794a16809a86a63ec2e6f8801e99141aca73fc238ea30d35f87c88847329" "e11569fd7e31321a33358ee4b232c2d3cf05caccd90f896e1df6cab228191109" "4bfced46dcfc40c45b076a1758ca106a947b1b6a6ff79a3281f3accacfb3243c" "0e0c37ee89f0213ce31205e9ae8bce1f93c9bcd81b1bcda0233061bb02c357a8" "086970da368bb95e42fd4ddac3149e84ce5f165e90dfc6ce6baceae30cf581ef" "444238426b59b360fb74f46b521933f126778777c68c67841c31e0a68b0cc920" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" "764384e88999768f00524dd3af6e873c62753649aa20ca530848fb6eb00f885b" "065a4fef514889dfd955ec5bf19a4916bcb223b608b20893c526749708bc5b97" "182d47cd9c220b3c9139ebeba0c3bd649947921af86587d9e57838686a6505ee"))
 '(evil-undo-system 'undo-fu)
 '(fringe-mode 16 nil (fringe))
 '(js-indent-level 2)
 '(js2-bounce-indent-p t)
 '(js2-strict-trailing-comma-warning nil)
 '(org-agenda-files '("/Users/logan/gtd/gtd.org" "/Users/logan/gtd/inbox.org"))
 '(safe-local-variable-values
   '((clojure-indent-style quote always-align)
     (eval when
           (featurep 'rama-mode)
           (rama-mode)))))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

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

(straight-use-package 'use-package)

(require 'use-package)

(defadvice load-theme
    (before theme-dont-propagate activate)
  "Make testing out themes easier."
  (mapc #'disable-theme custom-enabled-themes))

(use-package zenburn-theme
  :config
  (setq zenburn-use-variable-pitch 1)
  (setq zenburn-scale-org-headlines nil)
  )

(load-theme 'zenburn t)



(use-package doom-themes)

;;(load-theme 'doom-plain t)

;;(load-theme 'doom-zenburn t)

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
  (setq evil-undo-system 'undo-fu))

(use-package evil-surround
  :config (global-evil-surround-mode 1))

(use-package evil-smartparens
  :config (add-hook 'smartparens-enabled-hook #'evil-smartparens-mode))

(use-package company
  :config (add-hook 'after-init-hook 'global-company-mode)
  :ensure t)

(use-package ivy
  :config
  (ivy-mode 1))

(use-package counsel
  :config
  (counsel-mode 1)
  (global-set-key (kbd "C-x b") 'counsel-switch-buffer)
  (define-key counsel-find-file-map (kbd "<left>") 'counsel-up-directory)
  (define-key counsel-find-file-map (kbd "<right>") 'ivy-alt-done))

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :hook ((org-capture-mode . (lambda () (evil-local-mode -1))))
  :bind (("C-c c" . org-capture)
         ("C-c a" . org-agenda))
  :config
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((python . t)
     (clojure . t)))

  (setq
   org-default-notes-file "~/notes.org"
   org-agenda-files '("~/notes.org" "~/journal.org")
   org-capture-templates
   '(("t" "Inbox todo" entry (file+headline "~/gtd/inbox.org" "Tasks")
      "* TODO %?\n  %i\n  %a"))
   org-refile-targets '(("~/gtd.org" :maxlevel . 2))
   org-hide-emphasis-markers t
   org-refile-allow-creating-parent-nodes 'confirm))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))

(use-package olivetti
  :hook (text-mode . olivetti-mode)
  :config (setq olivetti-style 'fancy))

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
  :config (setq cider-default-cljs-repl
                "(do (require 'figwheel-sidecar.repl-api)
                     (figwheel-sidecar.repl-api/start-figwheel!)
                     (figwheel-sidecar.repl-api/cljs-repl))")
  (setq nrepl-log-messages nil)
  (setq cider-font-lock-dynamically nil))

(use-package clojure-mode
  :mode "\\.clj\\'|\\.boot\\'"
  :config
  (mapc (lambda (s) (put-clojure-indent s 1))
        '(describe describe-server it wcar query
                   init-state render render-state will-mount did-mount should-update
                   will-receive-props will-update did-update display-name will-unmount
                   describe-with-db describe-with-server swaggered context around
                   with facts fact match describe-with-mock-etl-state describe-with-es prop/for-all
                   form/form-to))
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

(use-package projectile
  :config (projectile-mode t)
  (setq projectile-use-git-grep t)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package counsel-projectile
  :init (counsel-projectile-mode))

(use-package groovy-mode)

(use-package racer
  :init (setq racer-rust-src-path "/home/logan/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library")
  :config
  (progn
    (add-hook 'rust-mode-hook #'racer-mode)
    (add-hook 'racer-mode-hook #'eldoc-mode)
    (add-hook 'racer-mode-hook #'company-mode)))

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

(setq tramp-default-method "ssh")

;;(load (expand-file-name "~/quicklisp/slime-helper.el"))
;;(setq inferior-lisp-program "sbcl")
;;(use-package slime)

;;(require 'org-mu4e)

;;(load "~/.emacs.d/fennel-mode")
;;(add-to-list 'auto-mode-alist '("\\.fnl'" . fennel-mode) t)

(defun lmb/evil-quit ()
  "Don't kill the frame if we're the last open window."
  (interactive)
  (if (> (count-windows) 1)
    (evil-quit)
    (kill-this-buffer)))

(evil-ex-define-cmd "q"  'lmb/evil-quit)

(evil-ex-define-cmd "quit" 'evil-quit)

(set-frame-font "Fira Code 14" nil t)


(use-package undo-fu)

;; required by doom-modeline
(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package neotree
  :config
  (global-set-key (kbd "C-c t") 'neotree-toggle))

(defun load-dot-emacs ()
  "Eval this file."
  (interactive)
  (load-file "/Users/logan/.emacs.d/init.el"))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq ns-use-native-fullscreen t)

(setq header-line-format " ")

(provide 'init)
;;;init.el ends here
