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

;; Initialize use-package on non-Linux platforms test is
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)
(setq inhibit-startup-message t)

(tool-bar-mode -1)         ; No toolbar
(menu-bar-mode -1)         ; No menu bar
(scroll-bar-mode -1)       ; No scroll bar
(fringe-mode 0)            ; No fringes
(global-display-line-numbers-mode t) ; Turn line num
(which-key-mode t)
(setq visible-bell 1)

(setq mouse-wheel-tilt-scroll t)
;; Prevent Extraneous Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(electric-indent-mode -1)

;; Set font. Need hook so that font is loaded in client when running in client/server mode
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (set-face-attribute 'default nil :font "Source Code Pro" :height 125))))

;; Also set for the initial frame
(set-face-attribute 'default nil :font "Source Code Pro" :height 125)

(recentf-mode 1)            ;; remember recent files
(global-auto-revert-mode 1) ;; Automatically refresh files

(global-display-fill-column-indicator-mode t)

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

(use-package rg)

(use-package projectile-ripgrep
  :defer t
  :after (rg projectile))

;; first brew install tree-sitter
;; sometimes required with lsp modes
(setq treesit-language-source-alist
      '((tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
        (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
        ;; (python "https://github.com/tree-sitter/tree-sitter-python" "master" "src")
        (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")))

;; Install missing grammars at startup
;; This is incorrect. Keeps reinstalling
;; (dolist (lang-config treesit-language-source-alist)
;;   (let ((lang (car lang-config)))
;;     (unless (treesit-language-available-p lang)
;;       (treesit-install-language-grammar lang))))

(use-package flycheck
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

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
  :custom
   (gptel-backend az-gpt-5.1)
   (gptel-model 'gpt-5.1)
   (gptel-default-mode 'org-mode))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         (powershell-mode . lsp)
         (python-mode . lsp)
         (typescript-ts-mode . lsp)
         (tsx-ts-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)))

;; (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))

(use-package lsp-ui
  :commands lsp-ui-mode)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . tsx-ts-mode))

;; yaml
(use-package yaml-mode
  :mode ("\\.yml\\'" "\\.yaml\\'")
  :config
  (add-hook 'yaml-mode-hook
            (lambda ()
              (define-key yaml-mode-map "\C-m" 'newline-and-indent))))

(dolist (mode '(org-mode-hook
        term-mode-hook
        eshell-mode-hook))
        ;; treemacs-mode-hook)
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package whitespace
   :config
   (global-whitespace-mode -1)
   :hook
   ((yaml-mode
     python-mode) . (lambda () (whitespace-mode t))))

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
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(require 'ox-md)  ;; required for export from org to markdown

;; need to first brew install hunspell
;; then place dictionaries in the right directory: https://formulae.brew.sh/formula/hunspell
(use-package flyspell
  :hook
  ((text-mode . flyspell-mode)
   (prog-mode . flyspell-prog-mode))
  :custom
  (ispell-program-name "aspell")
  (ispell-dictionary "en_US")
  (ispell-extra-args '("--sug-mode=ultra" "--lang=en_US"))
  (ispell-local-dictionary "en_US")
  :config
  (add-hook 'flyspell-mode-hook #'corfu-mode))

(defun bgw/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'bgw/display-startup-time)
