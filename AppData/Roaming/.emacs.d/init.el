;; TODO speed up load times
;; TODO consider moving off ivy, counsel, swiper
;; TODO better projectile support
;; TODO flyspell on all text files
;; TODO lsp for C#
;; TODO format this file
;; TODO show current window more clearly (update mode line)

(setq inhibit-startup-message t)

(tool-bar-mode -1)         ; Disable the toolbar
(set-fringe-mode -1)       ; Give some breathing room
(menu-bar-mode -1)         ; Disable the menu bar

(setq mouse-wheel-tilt-scroll t)
;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(set-face-attribute 'default nil :font "SauceCodePro NF" :height 100) ; height is in 1/10th of a pt

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

;; Note need to run package-refresh-contents before downloading new packages
(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package all-the-icons)
;; tango is a good builtin theme

(use-package doom-themes
  :custom
  (custom-safe-themes t)
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics univerally disabled
  (load-theme 'doom-acario-light)

  (doom-themes-visual-bell-config)
  ;; (setq doom-themes-treemacs-theme "doom-atom")
  ;; TODO: re-enable when you figure out why no icons
  ;; (doom-themes-treemacs-config)
  (doom-themes-org-config))

;; Ivy - https://github.com/abo-abo/swiper
(use-package ivy
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-case-fold-search 'always))

;; Configure swiper (see Ivy above)
(use-package swiper
  :ensure t
  :after ivy ; Ensure swiper is loaded after ivy
  :bind (("C-s" . swiper) ; Bind swiper to Ctrl-s
         ("C-r" . swiper-backward))) ; Bind swiper-backward to Ctrl-r

;; Better UI for Ivy
(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

;; See https://github.com/Alexander-Miller/treemacs?tab=readme-ov-file#installation
;; (use-package treemacs
;;   :config
;;   (setq treemacs-wrap-around nil)
;;   (setq treemacs-space-between-root-notes nil))

;; (use-package treemacs-projectile
;;   :after (treemacs projectile))

;; (use-package treemacs-icons-dired
;;   :hook (dired-mode . treemacs-icons-dired-enable-once))

;; Install and configure powershell-mode
(use-package powershell
  :mode ("\\.ps[1m]\\'" . powershell-mode))

;; yaml
(use-package yaml-mode
  :mode ("\\.yml\\'" "\\.yaml\\'")
  :config
  (add-hook 'yaml-mode-hook
            (lambda ()
              (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package nerd-icons) ; (required for doom-modeline)
(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(column-number-mode)
(global-display-line-numbers-mode t)
(global-display-fill-column-indicator-mode t)

(dolist (mode '(org-mode-hook
		term-mode-hook
		eshell-mode-hook))
		;; treemacs-mode-hook)
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; (dolist (mode '(treemacs-mode-hook))
;;   (add-hook mode (lambda () (scroll-bar-mode -1))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Show what keys I can press next
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 0.5))

;; Maybe add this later
;; (use-package ivy-rich
;;   :init
;;   (ivy-rich-mode 1))

;; Code
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (powershell-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)))

;; Better help files
(use-package helpful
   :custom
   (counsel-describe-function-function #'helpful-callable)
   (counsel-describe-variable-function #'helpful-variable)
   :bind (("C-h f" . counsel-describe-function)
	  ("C-h x" . #'helpful-command)
	  ("C-h v" . counsel-describe-variable)
	  ("C-h k" . #'helpful-key)))

;; Huge pain on Windows.
;; 1. First download hunspell
;; 2. Figure out where hunspell stores dictionaries `hunspell -D`
;; 2. Then download dictionaries to those locations:
;;   Invoke-WebRequest -Uri https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.dic -OutFile "path/where/hunspell/looks/en_US.dic"
;;   Invoke-WebRequest -Uri https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.aff -OutFile "path/where/hunspell/looks/en_US.aff"
(use-package ispell
  :config
  (setenv "DICTIONARY" "en_US")
  (setq ispell-dictionary "en_US")
  (setq ispell-program-name "hunspell")
  ;; (setq ispell-local-dictionary "en_US")
  (setq hunspell-default-dict "en_US")
  (setq ispell-hunspell-dictionary-alist '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

;; (use-package projectile
;;   :diminish projectile-mode
;;   :config (projectile-mode)
;;   :bind-keymap
;;   ("C-c p" . projectile-command-map)
;;   :init
;;   (when (file-directory-p "C:/Users/bradwest/src")
;;     (setq projectile-project-search-path '("C:/Users/bradwest/src")))
;;   (setq projectile-switch-project-action #'projectile-dired))

;; Need to install ripgrep: winget install --id BurntSushi.ripgrep.MSVC
(use-package rg)

(defun bgw/org-mode-setup ()
  (setq fill-column 120)
  (org-indent-mode)
  (auto-fill-mode 1)
  (display-fill-column-indicator-mode 1))

(use-package org
  :hook (org-mode . bgw/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; TODO put this in org section
(require 'ox-md)

(use-package plantuml-mode
  :mode ("\\.plantuml\\'" "\\.puml\\'")
  :config
  (add-hook 'plantuml-mode-hook (lambda ()
				  (electric-indent-local-mode -1)
				  (tab-width 4)
				  (indent-tabs-mode nil)))
  :custom
  (plantuml-jar-path "C:/Users/bradwest/AppData/Roaming/PlantUML/plantuml-1.2024.5.jar")
  (plantuml-default-exec-mode 'jar))
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("4e2e42e9306813763e2e62f115da71b485458a36e8b4c24e17a2168c45c9cf9d" default))
 '(package-selected-packages
   '(plantuml-mode org-bullets key-chord evil yaml-mode rg counsel-projectile projectile all-the-icons doom-themes helpful counsel ivy-rich which-key rainbow-delimiters nerd-icons doom-modeline swiper ivy)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
