(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#2e3436" "#a40000" "#4e9a06" "#c4a000" "#204a87" "#5c3566" "#729fcf" "#eeeeec"])
 '(fringe-mode 1 nil (fringe))
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
	(crystal-mode async wallpaper exwm engine-mode emojify vterm lua-mode centaur-tabs cargo rust-mode auto-package-update use-package speed-type)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(tooltip-mode nil))
(setq-default mode-line-format
 (list
  ;; modified, read-only, or neither
  "[%*]"
  ;; file name
  "[%f]"
  ;; mode name
  "[%m]"
  ;; current column:line
  "[%c:%l]"))
(force-mode-line-update t)

;;;; settings -- general
;; start server
(server-start)

;; line numbers
(global-display-line-numbers-mode)

;; no startup stuff
(setq-default inhibit-splash-screen t)

;; enable clipboard
(setq x-select-enable-clipboard t)

;; 4 space tabs
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode nil)
(setq backward-delete-char-untabify-method 'nil)

;; yes/no -> y/n
(defalias 'yes-or-no-p 'y-or-n-p)

;; (global-hl-line-mode t) ;; highlights line with cursor

(setq use-package-always-defer t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Write backup files to own directory ("$HOME/.emacs.d/backups")
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))
;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Set font and size
(add-to-list 'default-frame-alist '(font . "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1" ))
(set-face-attribute 'default t :font "-misc-fixed-medium-r-normal--13-120-75-75-c-70-iso8859-1" )

;; Load Gentoo stuff
(require 'site-gentoo)

;; Kill vterm buffer on exit
(setq vterm-kill-buffer-on-exit t)

;; Ask for sudo password if needed
(defadvice find-file (after find-file-sudo activate)
  "Find file as root if necessary."
  (unless (and buffer-file-name
               (file-writable-p buffer-file-name))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;; Packages
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; Automatically update packages
(use-package auto-package-update
  :defer nil
  :ensure t
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; Customizable tabs
(use-package centaur-tabs
  :demand
  :config
  (setq centaur-tabs-height 16)
  (centaur-tabs-mode t)
  :bind
  ("C-<next>" . centaur-tabs-backward)
  ("C-<prior>" . centaur-tabs-forward))

;; Terminal
(use-package vterm
    :ensure t)

;; Show emojis
(use-package emojify
    :ensure t)

;; Asynchronous bytecode compilation and various other actions makes Emacs look SIGNIFICANTLY less often which is a good thing.
(use-package async
    :ensure t
    :defer t
    :init
    (dired-async-mode 1)
    (async-bytecomp-package-mode 1)
    :custom (async-bytecomp-allowed-packages '(all)))

;;;;; EXWM
;(require 'exwm)
;(require 'exwm-config)
;;; Set the initial number of workspaces (they can also be created later).
;(setq exwm-workspace-number 10)
;;; All buffers created in EXWM mode are named "*EXWM*". You may want to
;;; change it in `exwm-update-class-hook' and `exwm-update-title-hook', which
;;; are run when a new X window class name or title is available.  Here's
;;; some advice on this topic:
;;; + Always use `exwm-workspace-rename-buffer` to avoid naming conflict.
;;; + For applications with multiple windows (e.g. GIMP), the class names of
;;    all windows are probably the same.  Using window titles for them makes
;;;   more sense.
;;; In the following example, we use class names for all windows except for
;;; Java applications and GIMP.
;(add-hook 'exwm-update-class-hook
;          (lambda ()
;            (unless (or (string-prefix-p "sun-awt-X11-" exwm-instance-name)
;                        (string= "gimp" exwm-instance-name))
;              (exwm-workspace-rename-buffer exwm-class-name))))
;(add-hook 'exwm-update-title-hook
;          (lambda ()
;            (when (or (not exwm-instance-name)
;                      (string-prefix-p "sun-awt-X11-" exwm-instance-name)
;                      (string= "gimp" exwm-instance-name))
;              (exwm-workspace-rename-buffer exwm-title))))
;(add-hook 'exwm-manage-finish-hook
;          (lambda ()
;            (when (and exwm-class-name
;                       (string= exwm-class-name "UXTerm"))
;              (exwm-input-set-local-simulation-keys '(([?\C-c ?\C-c] . ?\C-c))))))
;;; Global keybindings can be defined with `exwm-input-global-keys'.
;;; Here are a few examples:
;(setq exwm-input-global-keys
;      `(
;		;; Bind "s-z" to exit char-mode and fullscreen mode.
;        ([?\s-z] . exwm-layout-toggle-mode-line)
;        ;; Bind "s-r" to exit char-mode and fullscreen mode.
;        ([?\s-r] . exwm-restart)
;        ;; Bind "s-`" to switch workspace interactively.
;        ([?\s-`] . exwm-workspace-switch)
;        ;; Bind "s-0" to "s-9" to switch to a workspace by its index.
;        ,@(mapcar (lambda (i)
;                    `(,(kbd (format "s-%d" i)) .
;                      (lambda ()
;                        (interactive)
;                        (exwm-workspace-switch-create ,i))))
;                  (number-sequence 0 9))
;        ;; Bind "s-&" to launch applications ('M-&' also works if the output
;        ;; buffer does not bother you).
;        ([?\s-&] . (lambda (command)
;       (interactive (list (read-shell-command "$ ")))
;       (start-process-shell-command command nil command)))
;        ;; xscreensaver
;        ([?\s-x] . (lambda ()
;      (interactive)
;      (start-process "" nil "xscreensaver-command" "-lock")))
;		;; ripcord
;		([?\s-d] . (lambda ()
;      (interactive)
;      (start-process "" nil "/home/valley/downloads/Ripcord-0.4.24-x86_64.AppImage")))
;        ;; palemoon
;		([?\s-w] . (lambda ()
;      (interactive)
;      (start-process "" nil "palemoon")))
;		;; tor browswer bundle
;		([?\s-W] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "tbb")))
;		;; uxterm
;		([?\s-t] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "term")))
;        ;; music notification
;		([?\s-m] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "mus")))
;		;; time/date notification
;		([?\s-n] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "date")))
;		;; ip address notification
;		([?\s-i] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "ip")))
;		;; fetch notification
;		([?\s-o] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "fetch")))
;		;; audio stats
;		([?\s-A] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "stat")))
;		;; audio devices
;		([?\s-a] . (lambda ()
;      (interactive)
;      (start-process "" nil "general" "dev")))
;		;; blender
;		([?\s-b] . (lambda ()
;      (interactive)
;      (start-process "" nil "/home/valley/downloads/blender-2.83-04e318de3a40-linux-glibc217-x86_64/blender")))
;		;; gzdoom
;		([?\s-g] . (lambda ()
;      (interactive)
;      (start-process "" nil "gzdoom" "-file" "/home/valley/.config/gzdoom/*.pk3" "+sv_cheats" "1" "+vid_fps" "true" "+cl_capfps" "false" "+vid_maxfps" "60")))))
;
;;; The following example demonstrates how to use simulation keys to mimic
;;; the behavior of Emacs.  The value of `exwm-input-simulation-keys` is a
;;; list of cons cells (SRC . DEST), where SRC is the key sequence you press
;;; and DEST is what EXWM actually sends to application.  Note that both SRC
;;; and DEST should be key sequences (vector or string).
;(setq exwm-input-simulation-keys
;      '(
;        ;; movement
;        ;; ([?\C-b] . [left])
;        ([?\M-b] . [C-left])
;        ;; ([?\C-f] . [right])
;        ([?\M-f] . [C-right])
;        ([?\C-p] . [up])
;        ([?\C-n] . [down])
;        ;; ([?\C-a] . [home])
;        ;; ([?\C-e] . [end])
;        ([?\M-v] . [prior])
;        ([?\C-v] . [next])
;        ([?\C-d] . [delete])
;        ([?\C-k] . [S-end delete])
;        ;; cut/paste.
;        ([?\C-w] . [?\C-x])
;        ([?\M-w] . [?\C-c])
;        ([?\C-y] . [?\C-v])
;        ;; search
;        ;; ([?\C-s] . [?\C-f])
;		))
;
;;; Do not forget to enable EXWM. It will start by itself when things are
;;; ready.  You can put it _anywhere_ in your configuration.
;(exwm-enable)

;;;; Functions
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

 (defun toggle-transparency ()
   (interactive)
   (let ((alpha (frame-parameter nil 'alpha)))
     (set-frame-parameter
      nil 'alpha
      (if (eql (cond ((numberp alpha) alpha)
                     ((numberp (cdr alpha)) (cdr alpha))
                     ;; Also handle undocumented (<active> <inactive>) form.
                     ((numberp (cadr alpha)) (cadr alpha)))
               100)
          '(85 . 50) '(100 . 100)))))

;;;; Keybindings and Macros
(global-set-key (kbd "<home>") 'beginning-of-buffer) ;; move to beginning of buffer
(global-set-key (kbd "<end>") 'end-of-buffer) ;; move to end of buffer
(fset 'insert-ls
   "\C-u\C-[!ls\C-m")
(global-set-key (kbd "C-c l") 'insert-ls) ;; insert ls output at cursor in buffer
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file) ;; rename current file

;;;; Required stuff
(require 'rust-mode) ;; Rust Mode

;;; transparent frame and wallpaper
;(set-frame-parameter (selected-frame) 'alpha '(80 50))
;(add-to-list 'default-frame-alist '(alpha . (80 . 50)))
;(use-package wallpaper
;  :ensure t
;  :custom ((wallpaper-cycle-single t)
;           (wallpaper-scaling 'max)
;           (wallpaper-cycle-interval 15)
;           (wallpaper-cycle-directory "/mnt/ehdd/Pictures/wallpapers/single"))) ;; Use "single" dir for one wallpaper. I couldn't figure out how to set one wallpaper on it's own...

;; Mouse / Cursor
(set-mouse-color "white") ;; Set mouse color
(blink-cursor-mode 0) ;; Disable cursor blinking

;; set wallpaper
;(wallpaper-set-wallpaper)
;(setq wallpaper-cycle-mode nil)

;;;; Hooks
;(add-hook 'emacs-startup-hook (lambda ()
;    (start-process-shell-command "" nil "xrdb -merge ~/.Xresources")
;))
(add-hook 'after-init-hook #'global-emojify-mode)
(add-hook 'rust-mode-hook 'cargo-minor-mode)
