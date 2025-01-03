;; TODO consider adding consult, embark
;; TODO drop any ivy, consul, and swiper references
;; TODO better whitespace highlighting
;; TODO better projectile support
;; TODO flyspell on all text files
;; TODO lsp for C#
;; TODO format this file
;; TODO show current window more clearly (update mode line)
;; TODO better search

;; Set garbage collection threshold higher during startup
(setq gc-cons-threshold (* 50 1024 1024))
;; Lower it after startup
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1024 1024))))

(setq inhibit-startup-message t)

(tool-bar-mode -1)         ; Disable the toolbar
(menu-bar-mode -1)         ; Disable the menu bar
(scroll-bar-mode -1)
(fringe-mode 0)

(setq mouse-wheel-tilt-scroll t)
;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(set-face-attribute 'default nil :font "SauceCodePro NF" :height 95) ; height is in 1/10th of a pt

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

;; (use-package all-the-icons)
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
  ;; (doom-themes-treemacs-config
  (doom-themes-org-config))

;; Set some space on windows
(defvar bgw-window-divider-color "white" "Custom color for window borders")
(defvar bgw-window-divider-width 13 "Custom width for window borders")
(setq window-divider-default-places 'all-frames)
(setq window-divider-default-right-width bgw-window-divider-width
      window-divider-default-left-width bgw-window-divider-width
      window-divider-default-bottom-width bgw-window-divider-width)
;; Set left and top border on frame
(set-frame-parameter nil 'internal-border-width bgw-window-divider-width)
(setq window-divider-default-places t)
(window-divider-mode t)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(internal-border ((t (:background "white"))))
 '(line-number ((t (:inherit default :background "#E8E8E8" :foreground "#585C6C" :slant italic :weight normal))))
 '(mode-line-active ((t (:inherit mode-line :background "aquamarine"))))
 '(mode-line-inactive ((t (:background "#D3D3D3" :foreground "#4E4E4E" :box nil))))
 '(whitespace-newline ((t (:foreground "gray60"))))
 '(whitespace-space ((t (:foreground "gray60"))))
 '(whitespace-tab ((t (:foreground "gray60"))))
 `(window-divider ((t (:inherit vertical-border :foreground ,bgw-window-divider-color))))
 `(window-divider-first-pixel ((t (:foreground "black"))))
 `(window-divider-last-pixel ((t (:foreground "black")))))
;; turn off long line indicator
(setq whitespace-style '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark newline-mark missing-newline-at-eof))

(use-package vertico
  :init
  (vertico-mode))

(use-package savehist
  :after vertico
  :init
  (savehist-mode))

(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Ivy - https://github.com/abo-abo/swiper
;(use-package ivy
;  :config
;  (ivy-mode 1)
;  (setq ivy-use-virtual-buffers t)
;  (setq ivy-count-format "(%d/%d) ")
;  (setq ivy-case-fold-search 'always))

;; Configure swiper (see Ivy above)
; (use-package swiper
;  :ensure t
;  :after ivy ; Ensure swiper is loaded after ivy
;  :bind (("C-s" . swiper) ; Bind swiper to Ctrl-s
;         ("C-r" . swiper-backward))) ; Bind swiper-backward to Ctrl-r

;; Better UI for Ivy
;(use-package counsel
;  :bind (("M-x" . counsel-M-x)
;  ("C-x b" . counsel-ibuffer)
;  ("C-x C-f" . counsel-find-file)
;  :map minibuffer-local-map
;   ("C-r" . counsel-minibuffer-history))
;  :config
;  (setq ivy-initial-inputs-alist nil)) ;; Don't start searches with ^

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
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

;; need to learn how to use this
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
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

;; Do we need this?
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config (which-key-mode)
  :config (setq which-key-idle-delay 1))

;; Maybe add this later
;; (use-package ivy-rich
;;   :init
;;   (ivy-rich-mode 1))

(use-package company
  :ensure t
  :config
  (global-company-mode 1))

;; Code
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((powershell-mode . lsp)
         ;; if you want which-key integration
          (lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))  ; or lsp-deferred

(add-hook 'python-mode-hook
          (lambda ()
            (auto-revert-mode 1)))

;; Better help files
;(use-package helpful
;   :custom
;   (counsel-describe-function-function #'helpful-callable)
;   (counsel-describe-variable-function #'helpful-variable)
;   :bind (("C-h f" . counsel-describe-function)
;	  ("C-h x" . #'helpful-command)
;	  ("C-h v" . counsel-describe-variable)
;	  ("C-h k" . #'helpful-key)))

;; Huge pain on Windows.
;; 1. First download hunspell
;; 2. Figure out where hunspell stores dictionaries `hunspell -D`
;; 2. Then download dictionaries to those locations:
;;   Invoke-WebRequest -Uri https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.dic -OutFile "path/where/hunspell/looks/en_US.dic"
;;   Invoke-WebRequest -Uri https://cgit.freedesktop.org/libreoffice/dictionaries/plain/en/en_US.aff -OutFile "path/where/hunspell/looks/en_US.aff"
(use-package ispell
  :defer t
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
(use-package rg
  :defer t)

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

;; startup timing
(defun bgw/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'bgw/display-startup-time)
 
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t nil nil "Customized with use-package doom-themes")
 '(package-selected-packages
   '(orderless marginalia company lsp-pyright plantuml-mode org-bullets key-chord evil yaml-mode rg counsel-projectile projectile all-the-icons doom-themes helpful counsel ivy-rich which-key rainbow-delimiters nerd-icons doom-modeline swiper ivy)))

