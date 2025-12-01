;; TODO consider adding embark, wgrep
;; TODO flyspell on org mode
;; TODO lsp for emacs lisp
;; TODO update setq to customize where variables can be customized

;; Set garbage collection high initially for faster startup
(setq gc-cons-threshold (* 50 1024 1024))
;; Lower it after startup
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 8 1024 1024))))

(let ((secret-file (expand-file-name "secrets.el" user-emacs-directory)))
  (when (file-exists-p secret-file)
    (load secret-file)))

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
(setq inhibit-startup-message t)

(tool-bar-mode -1)         ; No toolbar
(menu-bar-mode -1)         ; No menu bar
(scroll-bar-mode -1)       ; No scroll bar
(fringe-mode 0)            ; No fringes
;; (global-display-line-numbers-mode t) ; Turn line num
(which-key-mode t)

(setq mouse-wheel-tilt-scroll t)
;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(electric-indent-mode -1)

;; needed to work with emacsclient on windows
(setq default-frame-alist '((font . "SauceCodePro NF-9.5")))

(recentf-mode 1)            ;; remember recent files
(global-auto-revert-mode 1) ;; Automatically refresh files

(global-display-fill-column-indicator-mode t)
;; (setq global-auto-revert-non-file-buffers 0)  ;; disable, messing with buffer list

(setq custom-file (locate-user-emacs-file "custom-vars.el")) ;; Store custom vars elsewhere
(load custom-file 'noerror 'nomessage)

(setq history-length 100)

;; https://protesilaos.com/emacs/modus-themes
(load-theme 'modus-operandi)

;; https://github.com/minad/vertico
(use-package vertico
  :init
  (vertico-mode))

;; https://github.com/minad/consult
;; TODO revisit keybindings - lots of useful ones
(use-package consult
  :bind (("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-g i" . consult-imenu)))

;; https://github.com/minad/corfu
(use-package corfu
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode))

;; https://github.com/minad/marginalia
(use-package marginalia
  :after vertico
  :init
  (marginalia-mode))

;; https://github.com/oantolin/orderless
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use corfu settings
  (completion-pcm-leading-wildcard t)) ;; needed for Emacs 31

(use-package savehist
  :after vertico
  :init
  (savehist-mode))

(when (eq system-type 'windows-nt)
  (setq explicit-shell-file-name "C:/Program Files/PowerShell/7/pwsh.exe"))

;; (column-number-mode)
(global-display-line-numbers-mode t)
(global-display-fill-column-indicator-mode t)

(dolist (mode '(org-mode-hook
                term-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package rg
  :defer t)

(use-package flycheck
  :config
  (global-flycheck-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

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

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((powershell-mode . lsp)
         (csharp-mode . lsp)
         ))

;; optionally
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-pyright
  :custom (lsp-pyright-langserver-command "pyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred))))  ; or lsp-deferred

(use-package csharp-mode)

(use-package whitespace
   :config
   (global-whitespace-mode -1)
   :hook
   ((yaml-mode
     python-mode) . (lambda () (whitespace-mode t))))

(use-package gptel
  :config
  (defvar az-gpt-5-mini
    (gptel-make-azure "azure-gpt-5-mini"
                   :host bw/azure-openai-host
                   :endpoint "/openai/deployments/gpt-5-mini/chat/completions?api-version=2025-01-01-preview"
                   :stream t
                   :key #'gptel-api-key  ; This reads from authinfo
                   :models '(gpt-5-mini)))
  (defvar az-gpt-5-codex
    (gptel-make-azure "azure-gpt-5.1-codex"
                   :host bw/azure-openai-host
                   :endpoint "/openai/deployments/gpt-5.1-codex/chat/completions?api-version=2025-01-01-preview"
                   :stream t
                   :key #'gptel-api-key
                   :models '(gpt-5.1-codex)))
  (defvar az-gpt-5.1
    (gptel-make-azure "azure-gpt-5.1"
                   :host bw/azure-openai-host
                   :endpoint "/openai/deployments/gpt-5.1/chat/completions?api-version=2025-01-01-preview"
                   :stream t
                   :key #'gptel-api-key
                   :models '(gpt-5.1)))
  (defvar gh-copilot
    (gptel-make-gh-copilot "copilot"))
  (setq gptel-backend az-gpt-5.1)
  (setq gptel-model 'gpt-5.1)
  (setq gptel-default-mode 'org-mode))

;; ### DOCS ###
(defun bgw/org-mode-setup ()
  (setq fill-column 120)
  (org-indent-mode)
  (auto-fill-mode 1)
  (org-display-inline-images t)
  (display-fill-column-indicator-mode 1))

(use-package org
  :hook (org-mode . bgw/org-mode-setup)
  :config
  (setq org-ellipsis " ▼"))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

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

(defun bgw/markdown-mode-setup ()
  "Custom settings for `markdown-mode`."
  (setq fill-column 120)
  (display-fill-column-indicator-mode 1))
(add-hook 'markdown-mode-hook #'bgw/markdown-mode-setup)

(use-package markdown-toc)

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

(defun bgw/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'bgw/display-startup-time)
