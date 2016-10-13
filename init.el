(require 'package)
(require 'cl)

(menu-bar-mode -1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("0e219d63550634bc5b0c214aced55eb9528640377daf486e13fb18a32bf39856" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t
      version-control t
      delete-old-versions t
      kept-new-versions 20
      kept-old-versions 5)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(setq package-user-dir (expand-file-name "elpa"))
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
  (add-hook 'prog-mode-hook #'smartparens-mode)
  (sp-use-paredit-bindings))

(use-package evil
  :config
  (evil-mode 1)
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
  :mode ("\\.org\\'" . org-mode))

(use-package olivetti
  :mode ("\\.txt\\'" . olivetti-mode))

(use-package python
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby")

(use-package whitespace)

(use-package rainbow-delimiters
  :config (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package js2-mode
  :init (setq js2-)
  :mode "\\.js\\'")

(use-package cider)

(use-package clojure-mode
  :mode "\\.clj\\'|\\.boot\\'")

(use-package clj-refactor
  :config (add-hook 'clojure-mode-hook (lambda ()
					 (clj-refactor-mode 1)
					 (cljr-add-keybindings-with-prefix "C-c C-r"))))

(use-package aggressive-indent
  :config (add-hook 'prog-mode-hook 'aggressive-indent-mode))

(use-package rust-mode
  :mode "\\.rs\\'")

(use-package flycheck
  :config (global-flycheck-mode))

(use-package rust-flycheck)

(global-set-key (kbd "C-c j") 'join-lines-and-remove-whitespace)

(defun open-dot-emacs ()
  "Open this file interactively."
  (interactive)
  (find-file "~/.emacs.d/init.el"))
