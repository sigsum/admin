;; -*- Emacs-Lisp -*-

;; drop into the debugger if something is wrong with this file
(setq debug-on-error t)

;; w3m buggy and won't let you quit emacs?
;;   (setq kill-emacs-hook (remove 'w3m-arrived-shutdown kill-emacs-hook))

;(add-to-list 'load-path "~/usr/share/emacs/site-lisp")

;; gnus / nnimap debugging.
;; gnus installs itself in /usr/share/emacs/site-lisp/gnus.  We
;; need this dir to appear before /usr/local/share/emacs/VERSION/lisp
;; and /usr/local/share/emacs/VERSION/site-lisp/semi in order to get
;; PGP working correctly.
;(setq load-path (cons "/usr/share/emacs/site-lisp/gnus" load-path))

(add-to-list 'load-path "~/lisp")
;(add-to-list 'load-path "/usr/share/emacs23/site-lisp/golang-mode")
;(require 'gnus-load)

;; Do this early -- other requirements might depend on it.
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(require 'tls)
;(require 'jabber)
(require 'appt)                         ;calendar needs this

;; On my fbsd-8.2, SMIME in gnus doesn't work, presumably because
;; another smime.el (from site-lisp/semi/?) is loaded.
;; 2012-09-19: upgrading emacs to 24.2 and gnus doesn't seem to carry smime.el
;(setq load-path (cons "/usr/local/share/emacs/23.4/lisp/gnus" load-path))
(require 'smime)

;(require 'magit)
(global-set-key "\C-xg" 'magit-status)

;; Fun.
;(autoload 'lpmud "lpmud" "Run LP-MUD in Emacs" t)
;; Twitter stuff.
;(load-file "~/.twitter.el")

;; http://jblevins.org/projects/markdown-mode/
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.mdwn$" . markdown-mode))

;; sieve
(autoload 'sieve-mode "sieve-mode")
(setq auto-mode-alist (cons '("\\.s\\(v\\|iv\\|ieve\\)\\'" . sieve-mode)
			    auto-mode-alist))

;; rfcview
(autoload 'rfcview-mode "rfcview" nil t)
(add-to-list 'auto-mode-alist
	     '("/rfc[0-9]+\\.txt\\(\\.gz\\)?\\'" . rfcview-mode))

;; yaml
;(require 'yaml-mode)
;(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;; EasyPG for PGP
(require 'epg)

;; Mailcrypt for PGP
;(require 'mailcrypt)

;; TAGS, generate it with `etags -I --members'.  `--members' doesn't seem
;; to be default contrary to what the fine manual says (etags (GNU Emacs 22.1)).
;; M-. in C++ files normally don't include stuff before and after `::'.
(add-hook 'c++-mode-hook 
	  '(lambda ()
	     (put major-mode
		  'find-tag-default-function 
		  #'c++-find-tag-default)))

;; By bigfacew...@my-deja.com, grabbed from
;; http://groups.google.se/group/comp.emacs/msg/12e25730edd7da7e
(defun c++-find-tag-default ()
  "find-tag, but `:' is a word constituent character"
  (let ((old-syntax (char-to-string (char-syntax ?:)))
        ret)
    (modify-syntax-entry ?: "w")
    (save-excursion
      (while (looking-at "\\sw\\|\\s_")
        (forward-char 1))
      (if (or (re-search-backward "\\sw\\|\\s_"
                                  (save-excursion (beginning-of-line)
						  (point))
                                  t)
              (re-search-forward "\\(\\sw\\|\\s_\\)+"
                                 (save-excursion (end-of-line) (point))
                                 t))
          (setq ret (progn (goto-char (match-end 0))
                           (buffer-substring (point)
                                             (progn (forward-sexp -1)
                                                    (while (looking-at
							    "\\s'")
                                                      (forward-char 1))
                                                    (point)))))
        nil))
    (modify-syntax-entry ?: old-syntax)
    ret))

;; org-mode
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(add-hook 'org-mode-hook 'turn-on-font-lock)
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; nxml
;(load-library "nxml/rng-auto.el")
;(setq auto-mode-alist
;      (cons '("\\.\\(xml\\|xsl\\|rng\\|xhtml\\)\\'" . nxml-mode)
;	    auto-mode-alist))

;; Gambit-C
;(add-to-list 'load-path "/usr/local/Gambit-C/current/share/emacs/site-lisp" t)
;(setq gambit-highlight-color "gray")
;(setq gambit-repl-command-prefix "\e")	; M-c, M-s, etc
;(require 'gambit)

;; Erlang
;(add-to-list 'load-path "/usr/local/lib/erlang/lib/tools-2.6.1/emacs" t)
;(setq erlang-root-dir "/usr/local/lib/erlang")
;(add-to-list 'exec-path "/usr/local/lib/erlang/bin" t)
;(require 'erlang-start)

;; BBDB
;(require 'bbdb)
;(bbdb-initialize)

;; Moved to customize:
;(when (fboundp 'ido-mode)
;  (ido-mode 'buffers)
;  (setq ido-create-new-buffer 'always))

;; Python mode (fbsd: lang/python-mode.el, debian: python-mode)
;(autoload 'python-mode "python-mode" "Mode for editing Python source files")
;(add-to-list 'auto-mode-alist '("\\.py" . python-mode))

;; ses -- simple emacs spreadsheet
;(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/ses")
;(add-to-list 'auto-mode-alist '("\\.ses$" . ses-mode))

;; Delete <--> Backspace
;; (Not too nice.  C-h should give info.)
;(setq keyboard-translate-table (make-string 128 0))
;(let ((i 0))
;  (while (< i 128)
;    (aset keyboard-translate-table i i)
;    (setq i (1+ i))))
;(aset keyboard-translate-table ?\b ?\^?)
;(aset keyboard-translate-table ?\^? ?\b)

(autoload 'mpg123 "mpg123" "A Front-end to mpg123" t)
;(load "id3.el")

;; EMMS -- http://www.gnu.org/software/emms/quickstart.html
;(add-to-list 'load-path "/u/src/emms/lisp/")
;(require 'emms-setup)
;(emms-standard)
;(emms-default-players)
;(global-set-key (kbd "M-C-p") 'emms-pause)

;; misc settings
(setq dired-listing-switches "-alB")
(setq case-fold-search nil)
(setq case-replace t)
;; Don't recurse in vc-dired.
(setq vc-dired-recurse nil)
;; Make sure VC knows when a remote repo is changed.
(setq vc-cvs-stay-local nil)
;; Git
;(require 'vc-git "" nil)
;(require 'git "" nil)
(when (featurep 'vc-git)
  (add-to-list 'vc-handled-backends 'git))
(autoload 'git-blame-mode
  "git-blame"
  "Minor mode for incremental blame for Git."
  t)
;;
(put 'narrow-to-region 'disabled nil)
(setq visible-bell t)
;(setq compile-command "gmake -k")
(setq diff-switches "-up")		; Keep in sync with ~/.cvsrc
;; This isn't a variable that's used, is it?
;; (setq default-c-style 'GNU)
;; There's a c-default-style though.
(setq add-log-mailing-address nil)
(setq default-major-mode 'text-mode)
(setq require-final-newline t)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

;; backup files
(setq delete-old-versions t)		; don't whine when deleting old backups
(setq kept-old-versions 0)
(setq kept-new-versions 5)
(setq version-control t)
(setq backup-directory-alist '(("." . ".~")))

;; Coding style
(add-hook 'java-mode-hook (lambda () (c-set-style "gnu")))

;; C hacking.
(defun my-c-mode-common-hook ()
  (setq show-trailing-whitespace t)
  ;(flyspell-prog-mode)
  ;(auto-fill-mode t)
  ;(c-toggle-auto-hungry-state t)
  )
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; load extra stuff
(autoload 'python-mode "python-mode" "Mode for editing Python source files")
(autoload 'ses-mode "ses.el" "Spreadsheet mode" t)
;(require 'planner)

;; more ses stuff
(defun my-delete-blanks (list)
  "Return LIST reversed, with the blank elements (nil and *skip*) removed."
  (let (result)
    (dolist (cur list)
      (and cur (not (eq cur '*skip*))
	   (push cur result)))
    result))

;; Update Nov 2011: Moved to EasyPG (epg), see also "Mime Security" (config)
;; mailcrypt for PGP/GnuPG.  (See .gnus too.)
;; -----------------------
;(load-library "mailcrypt")
;(mc-setversion "gpg")
;;(mc-setversion "5.0")
;(setq mc-gpg-user-id "0xCE2CDF1E")
;(setq mc-passwd-timeout 600)
;(autoload 'mc-install-write-mode "mailcrypt" nil t)
;(autoload 'mc-install-read-mode "mailcrypt" nil t)
;(add-hook 'mail-mode-hook 'mc-install-write-mode)
;(setq mc-pgp-fetch-methods
;      '(mc-pgp-fetch-from-keyrings
;	mc-pgp-fetch-from-http))

(defun gnus-l1 nil
  (gnus 1 -1))
(defun gnus-slave-l1 nil
  (gnus 1 -1 t))

;;  this seems ok for both emacs-19 and -20 but isn't needed for -21
;(set-input-mode (car (current-input-mode))
;		(nth 1 (current-input-mode))
;	t)

;; "enable European character display" (also selects Latin-1 as the
;; language environment)
;(standard-display-european t)
;(set-language-environment "Latin-1")

;; This font is nice, at least on 1920x1200.
(set-default-font "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1")

;; a sentence can end with a single space or double space -- match
;; both, but don't strip extra space when doing M-q.
; this strips extra space on M-q: (setq sentence-end-double-space nil)
(setq sentence-end "[.?!][]\"')}]*\\($\\| $\\|	\\|  \\| \\)[ 	\n]*")

;; make ESC-ESC to do eval-expression
(aset (car (cdr esc-map)) 27 'eval-expression)
(put 'eval-expression 'disabled nil)

;; make man-pages appear in current window
;;(setq Man-notify-method 'pushy)

;; mode line fiddle
;(setq display-time-day-and-date t)
(display-time)
(setq column-number-mode t)
(setq inhibit-startup-message t)

;; need user-mail-address for change-log entries:
(setq user-mail-address "linus@nordberg.se")

;; this is for viewing dvi-files (good for TeX)
;; it's C-c C-v in LaTeX mode.
(setq tex-dvi-view-command
      (if (eq window-system 'x) "xdvi" "dvi2tty * | cat -s"))

;;(autoload 'latin1-mode "latin1-mode" nil t)

;(diary 1)

;; erc
;(load-file "~/.emacs.erc.el")
(setq erc-email-userid "linus"
      erc-nick '("ln5")
      erc-quit-reason-various-alist '(("zippy" erc-quit-reason-zippy)
				      ("version" erc-quit-reason-normal)
				      ("z" "zzz")
				      ("^$" ""))
      erc-user-full-name "Linus N")

;;;;;;;;;;;;;;;;;;;;;;;;
;; Customizations
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Info-additional-directory-list (quote ("~/usr/share/info")))
 '(add-log-keep-changes-together t)
 '(browse-url-browser-function (quote w3m))
 '(calendar-today-visible-hook (quote (calendar-mark-today)))
 '(calendar-view-diary-initially-flag t)
 '(calendar-week-start-day 1)
 '(canlock-password "2cad718e25ff668bce0fd9106b574bc51618bb05")
 '(current-language-environment "UTF-8")
 '(dabbrev-upcase-means-case-search t)
 '(diary-abbreviated-year-flag nil)
 '(diary-date-forms (quote ((year "-" month "-" day "[^0-9]") (month "/" day "[^/0-9]") (month "/" day "/" year "[^0-9]") (monthname " *" day "[^,0-9]") (monthname " *" day ", *" year "[^0-9]") (dayname "\\W"))))
 '(diary-hook (quote (appt-make-list)))
 '(diary-mail-addr "linus@nordberg.se")
 '(dired-dwim-target t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-format "%Y-%m-%d %H:%M")
 '(erc-autojoin-channels-alist (quote (("luth.se" "#isp" "#sunet" "#sthix") ("#tor-status" "#epfsug" "#dfri-admin" "#tor-internal" "#tpo-admin" "#torservers" "#tor-dev" "#tor-ipv6" "#hackjunta" "#cryptodotis" "#nottor" "#tor" "#tor-bots" "#dfri_se" "#tor-se" "#libevent") ("freenode.net" "#sparvnastet" "#edri" "#krbdev") ("telecomix.org" "#telecomix"))))
 '(erc-autojoin-mode t)
 '(erc-hide-list nil)
 '(erc-join-buffer (quote window-noselect))
 '(erc-keywords (quote ("dfri")))
 '(erc-netsplit-mode t)
 '(erc-notify-list nil t)
 '(erc-pals (quote ("arma" "nickm")))
 '(erc-prompt-for-channel-key nil)
 '(erc-server-reconnect-timeout 10)
 '(erc-show-channel-key-p nil)
 '(erc-track-exclude nil)
 '(erc-track-exclude-types (quote ("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE" "333" "353")))
 '(erc-track-shorten-aggressively t)
 '(global-font-lock-mode t nil (font-lock))
 '(gnus-agent-go-online t)
 '(gnus-agent-handle-level 2)
 '(gnus-agent-plugged-hook (quote (gnus-group-send-queue)))
 '(gnus-agent-synchronize-flags t)
 '(gnus-agent-unplugged-hook nil)
 '(gnus-auto-expirable-newsgroups "adbc:INBOX\\.\\(lists\\.\\|sys\\|spam\\)")
 '(gnus-buttonized-mime-types (quote ("multipart/encrypted" "multipart/signed")))
 '(gnus-gcc-externalize-attachments (quote all))
 '(gnus-group-posting-charset-alist (quote ((message-this-is-mail nil nil) (message-this-is-news nil t))))
 '(gnus-group-use-permanent-levels 2)
 '(gnus-keep-same-level (quote best))
 '(gnus-play-startup-jingle t)
 '(gnus-select-article-hook (quote (gnus-agent-fetch-selected-article)))
 '(gnus-simplify-ignored-prefixes "^(SV|VB):")
 '(gnus-simplify-subject-functions (quote (gnus-simplify-subject-re gnus-simplify-subject-fuzzy)))
 '(gnus-summary-resend-default-address nil)
 '(gnus-suppress-duplicates t)
 '(gnus-treat-body-boundary (quote head))
 '(gnus-treat-unsplit-urls t)
 '(gnus-treat-x-pgp-sig (quote head))
 '(gnus-use-full-window nil)
 '(gnus-user-agent (quote (gnus)))
 '(gnutls-trustfiles (quote ("/etc/ssl/certs/ca-certificates.crt" "/etc/pki/tls/certs/ca-bundle.crt" "/etc/ssl/ca-bundle.pem" "/usr/ssl/certs/ca-bundle.crt" "/home/amnesia/Persistent/linus/nordber-ca.crt")))
 '(grep-command "grep -nH -Ed skip -e ")
 '(ido-case-fold t)
 '(ido-create-new-buffer (quote always))
 '(ido-enable-regexp t)
 '(ido-mode (quote buffer) nil (ido))
 '(imap-ssl-program (quote ("openssl s_client -quiet -tls1 -connect %s:%p" "openssl s_client -quiet -ssl3 -connect %s:%p")))
 '(indent-tabs-mode nil)
 '(ispell-program-name "aspell")
 '(jabber-account-list (quote (("linus@nordu.net/around" (:password . "vo0aquei3uSoe5th") (:network-server . "jabber.nordu.net") (:connection-type . starttls)))))
 '(jabber-activity-banned (quote ("twitter")))
 '(jabber-activity-make-strings (quote jabber-activity-make-strings-shorten))
 '(jabber-alert-message-hooks (quote (jabber-message-scroll)))
 '(jabber-alert-muc-hooks (quote (jabber-muc-scroll)))
 '(jabber-backlog-number 100)
 '(jabber-chatstates-confirm nil)
 '(jabber-info-message-alist (quote ((browse . "Browse request completed"))))
 '(jabber-invalid-certificate-servers (quote ("nordu.net")))
 '(jabber-mode-line-mode t)
 '(jabber-roster-line-format " %c %-25n %u %-8s  %S")
 '(jabber-show-offline-contacts nil)
 '(jabber-show-resources nil)
 '(menu-bar-mode nil)
 '(message-beginning-of-line nil)
 '(message-citation-line-format "On %a, %b %d %Y, %N wrote:
")
 '(message-citation-line-function (quote message-insert-formatted-citation-line))
 '(message-cite-function (quote message-cite-original))
 '(message-default-charset (quote utf-8))
 '(message-hidden-headers (quote ("^Gcc:\\|^Xref:\\|^X-Draft-From:\\|^References:")))
 '(message-kill-buffer-on-exit t)
 '(message-send-mail-function (quote smtpmail-send-it))
 '(message-setup-hook nil)
 '(message-subject-re-regexp "^[ 	]*\\(\\([Rr][Ee]\\|[Ss][Vv]\\)\\(\\[[0-9]*\\]\\)*:[ 	]*\\)*[ 	]*")
 '(mm-coding-system-priorities (quote (utf-8)))
 '(mm-decrypt-option nil)
 '(mm-default-directory "/tmp")
 '(mm-encrypt-option nil)
 '(mm-sign-option nil)
 '(mm-url-use-external t)
 '(mm-verify-option (quote known))
 '(mml-secure-cache-passphrase nil)
 '(mml-secure-passphrase-cache-expiry 0)
 '(mml2015-always-trust nil)
 '(mml2015-cache-passphrase t)
 '(mml2015-encrypt-to-self t)
 '(mml2015-passphrase-cache-expiry 60)
 '(mml2015-signers (quote ("0x46AE8F0E")))
 '(nnimap-dont-close nil)
 '(nnimap-split-download-body nil)
 '(nnmail-extra-headers (quote (Keywords To Newsgroups Cc)))
 '(ns-alternate-modifier (quote meta))
 '(ns-command-modifier (quote meta))
 '(ps-n-up-margin 18)
 '(ps-n-up-printing 1)
 '(ps-paper-type (quote a4))
 '(ps-print-header nil)
 '(ps-printer-name "")
 '(ps-printer-name-option nil)
 '(scheme-program-name "gsi")
 '(scroll-bar-mode nil)
 '(smime-CA-directory "~/ssl/CAs")
 '(smime-certificate-directory "/home/linus/ssl/certs/")
 '(smime-keys nil)
 '(smtpmail-debug-info nil)
 '(smtpmail-debug-verb nil)
 '(smtpmail-local-domain "nordberg.se")
 '(smtpmail-stream-type (quote starttls))
 '(starttls-extra-arguments nil)
 '(starttls-gnutls-program "gnutls-cli")
 '(starttls-use-gnutls t)
 '(tags-revert-without-query t)
 '(tls-checktrust (quote ask))
 '(tool-bar-mode nil)
 '(twit-minor-mode t)
 '(twit-show-user-images t)
 '(twit-user-image-dir "~/usr/share/images/twitter")
 '(twitter-username "ln4711")
 '(user-full-name "Linus Nordberg")
 '(w3m-command-arguments (quote ("-o" "use_proxy=1" "-o" "http_proxy=http://127.0.0.1:9050/" "-o" "https_proxy=http://127.0.0.1:9050/" "-o" "ftp_proxy=http://127.0.0.1:9050/")))
 '(w3m-default-save-directory "~/")
 '(w3m-file-coding-system (quote w3m-iso-latin-1))
 '(w3m-file-name-coding-system (quote w3m-iso-latin-1))
 '(w3m-home-page "about:blank")
 '(w3m-keep-arrived-urls 1500)
 '(w3m-keep-cache-size 900)
 '(w3m-no-proxy-domains (quote ("localhost")))
 '(w3m-search-default-engine "google")
 '(w3m-use-cookies t)
 '(w3m-user-agent "Emacs-w3m"))

;; Not used:
; '(erc-default-coding-system (quote (iso-8859-1 . undecided)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(calendar-today ((t (:box (:line-width 1 :color "grey75") :underline t))))
 '(diary ((((class color) (background light)) (:foreground "red"))))
 '(erc-keyword-face ((t (:foreground "dark green" :weight bold))))
 '(erc-pal-face ((t (:foreground "blue" :weight bold))))
 '(twit-message-face ((default (:height 0.9 :family "helv")) (nil nil))))

;;;;;;;;;;;;;;;;;;;;;;;
;; Some keybindings
;; M-C-g 
(global-set-key "\e\007" 'goto-line)

;; `C-c C-d' inserts current time and date at point
;(global-set-key "\003\004" (calendar-date-string (calendar-current-date) t))

;; `C-c C-v' does `view-mode'
(global-set-key "\003\026" 'view-mode)

;; `C-c C-c' does compile in C and C++ mode.
(add-hook 'c-mode-hook
          '(lambda ()
             (define-key c-mode-map
               "\C-c\C-c"
               'compile)
             ))
(add-hook 'c++-mode-hook
          '(lambda ()
             (define-key c++-mode-map
               "\C-c\C-c"
               'compile)
             ))

;; make apropos do everything possible
(setq apropos-do-all t)

;; set up grep to use egrep
;(setq grep-command "egrep -n ")

;; for buffers visitng files of the same name, make the
;; buffer name have something to do with the path to the file
;; instead of just tacking a number to the end
(require 'uniquify)
(toggle-uniquify-buffer-names)
(setq uniquify-buffer-name-style 'post-forward)
;(setq uniquify-buffer-name-style 'post-forward-angle-brackets)


;; Have Swedish characters as Meta-[ ] \
(define-key esc-map "]" 'iso-Aring-insert)
(define-key esc-map "[" 'iso-Adieresis-insert)
(define-key esc-map "\\" 'iso-Odieresis-insert)
(define-key esc-map "}" 'iso-aring-insert)
(define-key esc-map "{" 'iso-adieresis-insert)
(define-key esc-map "|" 'iso-odieresis-insert)
;(define-key esc-map "e" 'iso-eacute-insert)
(define-key esc-map "o" 'iso-danish-odieresis-insert)
(define-key esc-map "O" 'iso-danish-ae-insert)

;;---------------------------------------------------------------------------
;;
;; The character-inserting functions
;;
;;---------------------------------------------------------------------------
(defun iso-Aring-insert nil
  "Insert AA."
  (interactive)
  (insert #xc5))

(defun iso-aring-insert nil
  "Insert aa."
  (interactive)
  (insert #xe5))

(defun iso-Adieresis-insert nil
  "Insert AE."
  (interactive)
  (insert #xc4))

(defun iso-adieresis-insert nil
  "insert ae."
  (interactive)
  (insert #xe4))

(defun iso-Odieresis-insert nil
  "Insert OE."
  (interactive)
  (insert #xd6))

(defun iso-odieresis-insert nil
  "insert oe."
  (interactive)
  (insert #xf6))

(defun iso-eacute-insert nil
  "insert eacute."
  (interactive)
  (insert #xe9))

(defun iso-danish-odieresis-insert nil
  "insert eacute."
  (interactive)
  (insert #xf8))

(defun iso-danish-ae-insert nil
  "insert eacute."
  (interactive)
  (insert #xe6))

;; ø - "\370"; Ø - "\330"
;; æ - "\346"; Æ - "\306"
;; ü - "\374"
;;---------------------------------------------------------------------------

;;; Emacs/W3 Configuration
;(condition-case () (require 'w3-auto "w3-auto") (error nil))
;(setq w3-default-homepage "http://swox.com/")
;; set up use of proxy
;(setq url-proxy-services '(("http"    . "http-proxy:3128")
;			   ("ftp"     . "ftp-proxy:3128")
;			   ("no_proxy" . "^.*swox.se")))
;; misc w3 settings
;(setq w3-do-incremental-display t)
;(setq url-be-asynchronous t)
;(setq w3-notify 'friendly)
;; verify 4 levels of ssl certificates
;(setq ssl-certificate-verification-policy 4)

;; w3m
; (add-to-list 'load-path "~/usr/share/emacs/site-lisp/w3m")

;(require 'octet)
;(octet-mime-setup)
;(setq w3m-command-arguments
;              (nconc w3m-command-arguments
;                     '("-o" "http_proxy=http://proxy.hogege.com:8000/")))
;(setq w3m-no-proxy-domains '("local.com" "neighbor.com"))

;; Common Lisp hacking with Slime!
(setq load-path (cons "/usr/local/share/emacs/site-lisp/slime" load-path))
(setq load-path (cons "/usr/local/share/emacs/site-lisp/slime/contrib" load-path))
;(require 'slime-autoloads)
(setq slime-lisp-implementations
     `((sbcl ("/usr/bin/sbcl"))
       (clisp ("/usr/bin/clisp"))))
(add-hook 'lisp-mode-hook
           (lambda ()
             (cond ((not (featurep 'slime))
                    (require 'slime)
                    (normal-mode)))
	     (require 'slime-fancy)
	     (require 'slime-typeout-frame)
	     (require 'slime-asdf)
	     (require 'slime-tramp)))
(eval-after-load "slime"
  '(slime-setup '(slime-fancy slime-banner)))
(when nil	      ;TRAMP disabled due to trouble with local files.
  (push (slime-create-filename-translator
	 :machine-instance "lntest.nordberg.se"
	 :remote-host "banksy.nordberg.se#60226"
	 :username "linus")
	slime-filename-translations))
(global-set-key "\C-cs" 'slime-selector)
;; Local copy of the CLHS, supplied by the devel/clisp-hyperspec port
;; or hyperspec debian/ubuntu package
;; Invoke in SLIME with `C-c C-d h', HTML version in web browser.
(setq common-lisp-hyperspec-root "file:/usr/share/doc/hyperspec/")
;; Or, C-M-h for the Info version (configure common-lisp-hyperspec-root above).
(global-set-key [(control meta h)]
		'(lambda ()
		   (interactive)
		   (ignore-errors
		     (info (concatenate 'string "(gcl) "
					(thing-at-point 'symbol))))))

; clojure
;(add-to-list 'load-path "/u/src/clojure-mode")
;(require 'clojure-mode)
;(add-to-list 'load-path "/u/src/swank-clojure")
;; Chicken and egg: Want to do (swank-clojure-config (setq FOO BAR))
;; but we need to load swank-clojure for this.  That won't work unless
;; swank-clojure-jar-path is set though.  For now, just setq
;; swank-clojure-jar-path.
;(setq swank-clojure-jar-path "/opt/local/var/macports/software/clojure/1.0.0_1/opt/local/share/java/clojure/lib/clojure.jar")
; (setq swank-clojure-extra-classpaths (list "~/.clojure/clojure-contrib.jar")))
;(require 'swank-clojure-autoload)

;; haskell
(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))
(autoload 'haskell-mode "haskell-mode"
   "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
   "Major mode for editing literate Haskell scripts." t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-font-lock)
;;
;(require 'haskell-mode)
;(define-key haskell-mode-map [?\C-c ?h] 'hoogle-lookup)

;(require 'hoogle)			; ~linus/lisp/hoogle.el

(autoload 'apache-mode "apache-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
(add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
(add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
(add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
(add-to-list 'auto-mode-alist 
	     '("sites-\\(available\\|enabled\\)/" . apache-mode))

(defconst krb5-c-style
  '("bsd" 
    (c-cleanup-list
     brace-elseif-brace brace-else-brace defun-close-semi)
    (c-comment-continuation-stars . "* ")
    (c-electric-pound-behavior alignleft)
    (c-hanging-braces-alist
     (brace-list-open)
     (class-open after)
     (substatement-open after)
     (block-close . c-snug-do-while)
     (extern-lang-open after))
    (c-hanging-colons-alist
     (case-label after)
     (label after))
    (c-hanging-comment-starter-p)
    (c-hanging-comment-ender-p)
    (c-indent-comments-syntactically-p . t)
    (c-label-minimum-indentation . 0)
    (c-special-indent-hook)))
(defun krb5-c-hook ()
  (c-add-style "krb5" krb5-c-style t))
;;(add-hook 'c-mode-common-hook 'krb5-c-hook)

;; AUC TeX
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)

(put 'narrow-to-page 'disabled nil)

;; Set calendar-date-style outside custom-set-variables -- it gets
;; overwritten with 'european _somewhere_, I wish I knew where.
;; FIXME: This can probably move up again, now that we've removed the
;; stupid european-calendar-style entry. Update: Maybe. Still have trouble.
(calendar-set-date-style 'iso)

;; don't activate the debugger automagically when errors are
;; encountered
(setq debug-on-error nil)

;; leave the scratch buffer ready for hacking lisp
(lisp-interaction-mode)
