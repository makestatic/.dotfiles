(add-to-list 'load-path "~/.emacs.local/")

(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)
(setq make-backup-files nil)
(setq-default cursor-type 'box
              indent-tabs-mode t
              tab-width 4
              fill-column 80)
(global-display-line-numbers-mode 1)
(setq select-enable-clipboard t)
(xterm-mouse-mode 1)
(add-to-list 'default-frame-alist
             '(font . "Roboto Mono Nerd Font-11:weight=medium"))

; ‘simpc-mode’ is from tsoding dotfiles
(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))
(add-to-list 'auto-mode-alist '("\\.[b]\\'" . simpc-mode))

(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

; if pkg not installed, install it
(defun ensure-package (pkg)
  (unless (package-installed-p pkg) (package-install pkg)))

; vim-like motions, cant escape it );
(ensure-package 'evil)
(require 'evil)
(evil-mode 1)
(setq evil-want-C-u-scroll t
      evil-want-C-i-jump nil)

(ensure-package 'undo-tree)
(require 'undo-tree)
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t
      undo-tree-history-directory-alist `(("." . ,(concat user-emacs-directory "undo"))))
(global-set-key (kbd "C-c z") 'undo-tree-undo)
(global-set-key (kbd "C-c C-z") 'undo-tree-redo)

(ensure-package 'multiple-cursors)
(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)

(ensure-package 'smartparens)
(require 'smartparens-config)
(smartparens-global-mode 1)

; completions
(ensure-package 'corfu)
(require 'corfu)
(global-corfu-mode)
(setq corfu-cycle t
      corfu-auto t
      corfu-separator ?\s
      corfu-quit-at-boundary t
      corfu-echo-documentation nil)
(define-key corfu-map (kbd "C-n") 'corfu-next)
(define-key corfu-map (kbd "C-p") 'corfu-previous)
(define-key corfu-map (kbd "C-d") 'corfu-show-documentation)

(ensure-package 'cape)
(require 'cape)
(add-to-list 'completion-at-point-functions 'cape-dabbrev)
(add-to-list 'completion-at-point-functions 'cape-file)
(add-to-list 'completion-at-point-functions 'cape-keyword)

(ensure-package 'lsp-mode)
(require 'lsp-mode)
(add-hook 'simpc-mode-hook 'lsp)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)
(add-hook 'zig-mode-hook 'lsp)
(add-hook 'python-mode-hook 'lsp)
(setq lsp-prefer-capf t
      lsp-enable-snippet nil
      lsp-enable-symbol-highlighting t)
(global-set-key (kbd "C-c l d") 'lsp-find-definition)
(global-set-key (kbd "C-c l r") 'lsp-find-references)
(global-set-key (kbd "C-c l h") 'lsp-hover)
(global-set-key (kbd "C-c l R") 'lsp-rename)
(global-set-key (kbd "C-c l a") 'lsp-execute-code-action)

(ensure-package 'vertico)
(vertico-mode 1)
(ensure-package 'orderless)
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) 
  (completion-pcm-leading-wildcard t))

(require 'dired)
(require 'dired-x)
; run ‘!’ asynclly in compile-mode
(defun dired-async-compile-command (command &optional arg)
  (interactive (list (read-shell-command "Shell command: " nil)
                     current-prefix-arg))
  (let ((files (mapconcat #'shell-quote-argument (dired-get-marked-files) " ")))
    (compile (concat command " " files) t)))
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "!") 'dired-async-compile-command))

(global-set-key (kbd "C-c e") 'dired-jump)
(global-set-key (kbd "C-c v") 'split-window-right)
(global-set-key (kbd "C-c s") 'split-window-below)
(global-set-key (kbd "C-c cc") 'compile)
(global-set-key (kbd "C-c cn") 'compile-goto-error)
(global-set-key (kbd "M-]") 'next-buffer)
(global-set-key (kbd "M-[") 'previous-buffer)
; reload config
(global-set-key (kbd "C-c r") (lambda () (interactive) (load-file "~/.emacs")))

; zoom in/out
(global-set-key (kbd "C-=")
                (lambda () (interactive)
                  (set-face-attribute 'default nil
                                      :height (+ 10 (face-attribute 'default :height)))))
(global-set-key (kbd "C--")
                (lambda () (interactive)
                  (set-face-attribute 'default nil
                                      :height (- (face-attribute 'default :height) 10))))

; mr. zozin theme. i like it
(load-theme 'gruber-darker t)

(require 'ansi-color)
(defun rc/compilation-filter-hook()
  (ansi-color-apply-on-region compilation-filter-start (point)))
(add-hook 'compilation-filter-hook 'rc/compilation-filter-hook)

; tweak the lsp to work w/ simpc-mode
(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
               '(simpc-mode . "c")))

; FORMMATING
(global-set-key (kbd "C-c fm") #'lsp-format-buffer)

; open Man in split window
(setq display-buffer-alist
      '(("\\*\\(Man\\|WoMan\\).*\\*"
         (display-buffer-reuse-window display-buffer-below-selected)
         (window-height . 0.4))))
