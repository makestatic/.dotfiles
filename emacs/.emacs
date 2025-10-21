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

(add-to-list 'default-frame-alist '(font . "roboto mono nerd font-11:weight=medium"))

(require 'package)
(setq package-archives
      '(("gnu"   . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t
      use-package-verbose nil)

(use-package magit
  :bind (("C-x g" . magit-status)))
(setq magit-auto-revert-mode nil)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil)
  :config
  (evil-mode 1)
  (setq evil-normal-state-cursor  '(box "#ffdd33")
        evil-insert-state-cursor  '(box "#ffdd33")
        evil-visual-state-cursor  '(box "#ffdd33")
        evil-replace-state-cursor '(box "#ffdd33")
        evil-operator-state-cursor '(box "#ffdd33"))
  (set-default 'cursor-type 'box)
  (set-face-background 'cursor "#ffdd33"))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
  (global-undo-tree-mode 1))

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)
         ("C-S-c C-S-c" . mc/edit-lines)))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config (smartparens-global-mode 1))

(use-package vertico
  :init (vertico-mode 1))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.25)
  (corfu-auto-prefix 1)
  :bind (:map corfu-map
              ("C-n" . corfu-next)
              ("C-p" . corfu-previous)
              ("C-d" . corfu-show-documentation)))

(use-package cape
  :after corfu
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-keyword))

(setq global-corfu-minibuffer nil)
(use-package consult)
(setq completion-in-region-function 'consult-completion-in-region)

(use-package eglot
  :hook ((c-mode c++-mode python-mode zig-mode) . eglot-ensure)
  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda () (eglot-inlay-hints-mode -1)))
  (add-to-list 'eglot-server-programs '(python-mode . ("pyright" "--stdio")))
  (add-to-list 'eglot-server-programs '(c-mode . ("clangd")))
  (add-to-list 'eglot-server-programs '(c++-mode . ("clangd")))
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

(use-package yasnippet-snippets
  :after yasnippet)

(use-package flyspell
  :hook ((text-mode . flyspell-mode)
         (prog-mode . flyspell-prog-mode))
  :config
  (setq ispell-program-name "hunspell"))

(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
              ("C-;" . flyspell-correct-wrapper)))


(global-set-key (kbd "C-c e") 'dired-jump)
(global-set-key (kbd "C-c v") 'split-window-right)
(global-set-key (kbd "C-c s") 'split-window-below)
(global-set-key (kbd "C-c cc") 'compile)
(global-set-key (kbd "C-c cn") 'compile-goto-error)
(global-set-key (kbd "C-c ]") 'next-buffer)
(global-set-key (kbd "C-c [") 'previous-buffer)
(global-set-key (kbd "C-c r") (lambda () (interactive) (load-file "~/.emacs")))
(global-set-key (kbd "C-+") (lambda () (interactive)
                              (set-face-attribute 'default nil :height (+ 10 (face-attribute 'default :height)))))
(global-set-key (kbd "C--") (lambda () (interactive)
                              (set-face-attribute 'default nil :height (- (face-attribute 'default :height) 10))))
(global-set-key (kbd "C-0") (lambda () (interactive)
                              (set-face-attribute 'default nil :height 110)))

(require 'ansi-color)
(defun mk/ansi-compilation ()
  (ansi-color-apply-on-region compilation-filter-start (point)))
(add-hook 'compilation-filter-hook 'mk/ansi-compilation)

(setq display-buffer-alist
      '(("\\*.*\\*" (display-buffer-reuse-window display-buffer-below-selected)
         (window-height . 0.4))))

(use-package gruber-darker-theme
  :config (load-theme 'gruber-darker t))
