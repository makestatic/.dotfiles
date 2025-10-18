;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; emacs 28->29->30 at least ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'load-path "~/.emacs.local/")
(setq inhibit-startup-screen t
      make-backup-files nil
      auto-save-default nil
      indent-tabs-mode t
      tab-width 4
      fill-column 80
      select-enable-clipboard t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(global-display-line-numbers-mode 1)
(xterm-mouse-mode 1)
(add-to-list 'default-frame-alist '(font . "Roboto Mono Nerd Font-11:weight=medium"))

(use-package gruber-darker-theme
  :ensure t
  :config (load-theme 'gruber-darker t))

(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package) (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t use-package-verbose t)

(use-package magit
  :bind (("C-x g" . magit-status)))

(use-package evil
  :init (setq evil-want-integration t
              evil-want-keybinding nil)
  :config (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package undo-tree
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist `(("." . ,(concat user-emacs-directory "undo"))))
  :bind (("C-c z" . undo-tree-undo)
         ("C-c C-z" . undo-tree-redo)))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (smartparens-global-mode 1))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  (corfu-auto-delay 0.0)
  (corfu-auto-prefix 1)
  (corfu-quit-at-boundary t)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-d" . corfu-show-documentation)))

(use-package cape
  :after corfu
  :init
  (dolist (f '(cape-dabbrev cape-file cape-keyword cape-path cape-yasnippet))
    (add-to-list 'completion-at-point-functions f)))

(use-package eglot
  :hook ((python-mode simpc-mode zig-mode) . eglot-ensure)
  :config
  ;; disable inlay hints
  (setq eglot-inlay-hints-mode nil)

  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (when (bound-and-true-p eglot-inlay-hints-mode)
                (eglot-inlay-hints-mode -1))
              (setq-local completion-at-point-functions
                          (append completion-at-point-functions
                                  (list #'eglot-completion-at-point))))))

  ;; server programs
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright-langserver" "--stdio")))
  (add-to-list 'eglot-server-programs '(simpc-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(zig-mode . ("zls")))

  :bind (:map eglot-mode-map
              ("C-c l d" . xref-find-definitions)
              ("C-c l r" . xref-find-references)
              ("C-c l h" . eldoc)
              ("C-c l R" . eglot-rename)
              ("C-c l a" . eglot-code-actions)
              ("C-c f m" . eglot-format-buffer)))

(use-package yasnippet
  :config (yas-global-mode 1))
(use-package yasnippet-snippets :after yasnippet)

(use-package vertico
  :init (vertico-mode 1))
(use-package orderless
  :custom (completion-styles '(orderless basic))
          (completion-category-overrides '((file (styles partial-completion))))
          (completion-category-defaults nil)
          (completion-pcm-leading-wildcard t))


; stolen from Mr. zozin dotfiles <https://github.com/rexim/dotfiles>
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\|\\.\\(cc\\|hh\\|C\\)" . simpc-mode))

(global-set-key (kbd "C-c e") 'dired-jump)
(global-set-key (kbd "C-c v") 'split-window-right)
(global-set-key (kbd "C-c s") 'split-window-below)
(global-set-key (kbd "C-c cc") 'compile)
(global-set-key (kbd "C-c cn") 'compile-goto-error)
(global-set-key (kbd "C-c ]") 'next-buffer)
(global-set-key (kbd "C-c [") 'previous-buffer)
(global-set-key (kbd "C-c r") (lambda () (interactive) (load-file "~/.emacs")))
(global-set-key (kbd "C-=") (lambda () (interactive)
                              (set-face-attribute 'default nil
                                                  :height (+ 10 (face-attribute 'default :height)))))
(global-set-key (kbd "C--") (lambda () (interactive)
                              (set-face-attribute 'default nil
                                                  :height (- (face-attribute 'default :height) 10))))

(require 'ansi-color)
(defun rc/compilation-filter-hook ()
  (ansi-color-apply-on-region compilation-filter-start (point)))
(add-hook 'compilation-filter-hook 'rc/compilation-filter-hook)

(setq display-buffer-alist
      '(("\\*\\(Man\\|WoMan\\).*\\*" (display-buffer-reuse-window display-buffer-below-selected)
         (window-height . 0.4))))
