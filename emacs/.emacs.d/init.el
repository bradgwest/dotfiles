(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disable visible scrollbar
(tool-bar-mode -1) ; Disable the toolbar
(set-fringe-mode -1) ; Give some breathing room
(menu-bar-mode -1) ; Disable the menu bar

(fido-mode t) ; better minibuffer completion
(setq icomplete-vertical-mode t)

(set-face-attribute 'default nil :font "Source Code Pro" :height 135) ; height is in 1/10th of a pt
