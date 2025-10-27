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
(add-to-list 'default-frame-alist '(font . "RobotoMono Nerd Font-11:weight=medium"))

(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(defun mk/ensure-package-installed (&rest packages)
  (mapcar (lambda (pkg)
            (unless (package-installed-p pkg)
              (package-install pkg)))
          packages))

(mk/ensure-package-installed
 'magit
 'evil
 'evil-collection
 'undo-tree
 'multiple-cursors
 'smartparens
 'vertico
 'orderless
 'corfu
 'cape
 'consult
 'eglot
 'yasnippet
 'yasnippet-snippets
 'flyspell
 'flyspell-correct
 'gruber-darker-theme
 'gotham-theme
 'solarized-theme
 'zig-mode
 'lua-mode
 'cmake-mode
 'rust-mode
 'savehist
 ;
 )

(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-auto-revert-mode nil)

(setq evil-want-integration t
      evil-want-keybinding nil
      evil-default-cursor t)

(require 'evil)
(evil-mode 1)

(require 'evil-collection)
(evil-collection-init)
(setq cursor-type 'box)
(setq evil-normal-state-cursor '(box)) 
(setq evil-insert-state-cursor '((box . 5))) 
(setq evil-visual-state-cursor '(box)) 
(setq evil-motion-state-cursor '(box))
(setq evil-replace-state-cursor '(box))
(setq evil-operator-state-cursor '(box))

(require 'undo-tree)
(setq undo-tree-auto-save-history t
      undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))
(global-undo-tree-mode 1)

(global-set-key (kbd "C-S-c C-S-c") 'mc/mark-all-dwim)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-\"") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:") 'mc/skip-to-previous-like-this)

(require 'smartparens)
(add-hook 'prog-mode-hook #'smartparens-mode)
(smartparens-global-mode 1)

(require 'vertico)
(vertico-mode 1)

(require 'orderless)
(setq completion-styles '(orderless basic)
      completion-category-defaults nil
      completion-category-overrides '((file (styles partial-completion))))

(require 'corfu)
(global-corfu-mode 1)
(setq corfu-auto t
      corfu-auto-delay 0.25
      corfu-auto-prefix 1
      global-corfu-minibuffer nil)
(define-key corfu-map (kbd "C-n") 'corfu-next)
(define-key corfu-map (kbd "C-p") 'corfu-previous)
(define-key corfu-map (kbd "C-d") 'corfu-show-documentation)

(require 'cape)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)
(add-to-list 'completion-at-point-functions #'cape-keyword)

(require 'consult)
(setq completion-in-region-function 'consult-completion-in-region)

(require 'eglot)
(dolist (mode '(c-mode c++-mode python-mode zig-mode))
  (add-hook (intern (concat (symbol-name mode) "-hook")) #'eglot-ensure))
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
(setq eglot-server-programs
      '((python-mode . ("pyright" "--stdio"))
        (c-mode . ("clangd"))
        (c++-mode . ("clangd"))
        (zig-mode . ("zls"))))
(define-key eglot-mode-map (kbd "C-c l d") 'xref-find-definitions)
(define-key eglot-mode-map (kbd "C-c l r") 'xref-find-references)
(define-key eglot-mode-map (kbd "C-c l h") 'eldoc)
(define-key eglot-mode-map (kbd "C-c l R") 'eglot-rename)
(define-key eglot-mode-map (kbd "C-c l a") 'eglot-code-actions)
(define-key eglot-mode-map (kbd "C-c f m") 'eglot-format-buffer)

(require 'yasnippet)
(yas-global-mode 1)
(require 'yasnippet-snippets)
(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)
(setq ispell-program-name "hunspell")

(with-eval-after-load 'flyspell
  (define-key flyspell-mode-map (kbd "C-;") 'flyspell-correct-wrapper))

(global-set-key (kbd "C-c e") 'dired-jump)
(global-set-key (kbd "C-c v") 'split-window-right)
(global-set-key (kbd "C-c s") 'split-window-below)
(global-set-key (kbd "C-c cc") 'compile)
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

(require 'savehist)
(setq savehist-file "~/.emacs.d/savehist")
(setq savehist-additional-variables
      '(compile-history))
(savehist-mode 1)
(require 'compile)
(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(defun mk/focus-new-window (_buffer &optional _action)
  (let ((win (get-buffer-window _buffer)))
    (when (and win (not (window-minibuffer-p win)))
      (select-window win))))
(advice-add 'display-buffer :after #'mk/focus-new-window)

;; (with-eval-after-load 'evil
;;   (with-eval-after-load 'evil-collection
;;     (load-theme 'solarized-dark t)))

(setq lsp-zig-zls-executable "/opt/zls")
(setq lsp-zig-zig-exe-path "/opt/zig/zig")
(setq lsp-zig-zig-lib-path "/opt/zig/")
