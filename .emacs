;; -*- Emacs-Lisp -*-

;; drop into the debugger if something is wrong with this file
(setq debug-on-error t)

;; w3m buggy and won't let you quit emacs?
;;   (setq kill-emacs-hook (remove 'w3m-arrived-shutdown kill-emacs-hook))

;; gnus / nnimap debugging.
;; gnus installs itself in /usr/share/emacs/site-lisp/gnus.  We
;; need this dir to appear before /usr/local/share/emacs/VERSION/lisp
;; and /usr/local/share/emacs/VERSION/site-lisp/semi in order to get
;; PGP working correctly.
;(setq load-path (cons "/usr/share/emacs/site-lisp/gnus" load-path))

(add-to-list 'load-path "~/lisp")
;(require 'gnus-load)

(add-to-list 'load-path "~/usr/share/emacs/site-lisp")

(add-to-list 'load-path "~/.emacs.d/site-lisp") ; for markdown-mode, ox-reveal
;(require 'notmuch)
(add-to-list 'load-path "~/usr/local/share/emacs/site-lisp/magit")
(require 'magit)
(global-set-key "\C-xg" 'magit-status)

;(setq load-path (cons "/usr/share/emacs/site-lisp/erlang" load-path))

(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

;; On my fbsd-8.2, SMIME in gnus doesn't work, presumably because
;; another smime.el (from site-lisp/semi/?) is loaded.
;; 2012-09-19: upgrading emacs to 24.2 and gnus doesn't seem to carry smime.el
;(setq load-path (cons "/usr/local/share/emacs/23.4/lisp/gnus" load-path))
(require 'smime)

(require 'ox-reveal)
(require 'tls)
;(require 'jabber)
(require 'appt)                         ;calendar needs this

;; Fun.
;(autoload 'lpmud "lpmud" "Run LP-MUD in Emacs" t)
;; Twitter stuff.
;(load-file "~/.twitter.el")

(autoload 'markdown-mode "markdown-mode.el" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.mdwn\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mkd\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.creole\\'" . markdown-mode))
(autoload 'gfm-mode "markdown-mode" "Major mode for editing GitHub Flavored Markdown files" t)
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
(add-to-list 'auto-mode-alist '("\\.pp\\'" . ruby-mode))

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

;; lfe-mode
;(add-to-list 'load-path "~/usr/src/lfe/emacs")
;(require 'lfe-start)
;(add-to-list 'auto-mode-alist '("\\.lfe\\'" . lfe-mode))

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
;;(org-clock-persistence-insinuate)

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
(add-to-list 'load-path "/usr/lib/erlang/lib/tools-2.9/emacs" t)
(setq erlang-root-dir "/usr/lib/erlang")
;(add-to-list 'exec-path "/usr/lib/erlang/bin" t)
(require 'erlang-start)

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

;;(autoload 'mpg123 "mpg123" "A Front-end to mpg123" t)
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
(defun maybe-linux-style ()
  (when (and buffer-file-name
             (string-match "wg-dynamic" buffer-file-name))
    (c-set-style "linux")))
(add-hook 'c-mode-hook 'maybe-linux-style)
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
;(autoload 'python-mode "python-mode" "Mode for editing Python source files")
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

;(set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-90-iso8859-15")
(set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-80-iso8859-15")
;(set-frame-font "-misc-fixed-medium-r-normal--15-*-75-75-c-70-iso8859-15")
;(set-frame-font "-misc-fixed-medium-r-normal--14-*-75-75-c-70-iso8859-15")
;(set-frame-font "-misc-fixed-medium-r-normal--13-*-75-75-c-80-iso8859-15")
;(set-frame-font "-misc-fixed-medium-r-normal--13-*-75-75-c-70-iso8859-15")

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
 '(Info-additional-directory-list (quote ("~/usr/share/info" "~/usr/local/share/info")))
 '(add-log-keep-changes-together t)
 '(browse-url-browser-function (quote w3m))
 '(calendar-today-visible-hook (quote (calendar-mark-today)))
 '(calendar-view-diary-initially-flag t)
 '(calendar-week-start-day 1)
 '(canlock-password "2cad718e25ff668bce0fd9106b574bc51618bb05")
 '(current-language-environment "UTF-8")
 '(dabbrev-upcase-means-case-search t)
 '(diary-abbreviated-year-flag nil)
 '(diary-date-forms
   (quote
    ((year "-" month "-" day "[^0-9]")
     (month "/" day "[^/0-9]")
     (month "/" day "/" year "[^0-9]")
     (monthname " *" day "[^,0-9]")
     (monthname " *" day ", *" year "[^0-9]")
     (dayname "\\W"))))
 '(diary-hook (quote (appt-make-list)))
 '(diary-mail-addr "linus@nordberg.se")
 '(dired-dwim-target t)
 '(display-time-24hr-format t)
 '(display-time-day-and-date t)
 '(display-time-format "%Y-%m-%d %H:%M")
 '(display-time-world-list
   (quote
    (("America/Los_Angeles" "Seattle")
     ("America/New_York" "New York")
     ("Europe/London" "London")
     ("Europe/Stockholm" "Stockholm")
     ("Asia/Calcutta" "Bangalore")
     ("Asia/Tokyo" "Tokyo")
     ("Australia/Melbourne" "Melbourne"))))
 '(erc-autojoin-channels-alist
   (quote
    (("luth.se" "#isp" "#sunet" "#sthix")
     ("#tor-status" "#epfsug" "#dfri-admin" "#tor-internal" "#tpo-admin" "#torservers" "#tor-dev" "#tor-ipv6" "#hackjunta" "#cryptodotis" "#nottor" "#tor" "#tor-bots" "#dfri_se" "#tor-se" "#libevent")
     ("freenode.net" "#sparvnastet" "#edri" "#krbdev")
     ("telecomix.org" "#telecomix"))))
 '(erc-autojoin-mode t)
 '(erc-disable-ctcp-replies t)
 '(erc-hide-list nil)
 '(erc-join-buffer (quote window-noselect))
 '(erc-keywords (quote ("dfri")))
 '(erc-netsplit-mode t)
 '(erc-notify-list nil)
 '(erc-pals (quote ("arma" "nickm")))
 '(erc-paranoid t)
 '(erc-prompt-for-channel-key nil)
 '(erc-server-reconnect-timeout 10)
 '(erc-show-channel-key-p nil)
 '(erc-track-exclude nil)
 '(erc-track-exclude-types
   (quote
    ("JOIN" "KICK" "NICK" "PART" "QUIT" "MODE" "333" "353")))
 '(erc-track-shorten-aggressively t)
 '(erc-truncate-mode t)
 '(global-font-lock-mode t nil (font-lock))
 '(gnus-agent-go-online t)
 '(gnus-agent-handle-level 2)
 '(gnus-agent-plugged-hook (quote (gnus-group-send-queue)))
 '(gnus-agent-synchronize-flags t)
 '(gnus-agent-unplugged-hook nil)
 '(gnus-auto-expirable-newsgroups "adbc:\\(lists\\.\\|sys\\|spam\\)\\|sunet:tickets")
 '(gnus-blocked-images ".*")
 '(gnus-buttonized-mime-types
   (quote
    ("multipart/encrypted" "multipart/signed" "multipart/alternative")))
 '(gnus-gcc-externalize-attachments (quote all))
 '(gnus-group-posting-charset-alist
   (quote
    ((message-this-is-mail nil nil)
     (message-this-is-news nil t))))
 '(gnus-group-use-permanent-levels 2)
 '(gnus-inhibit-images t)
 '(gnus-keep-same-level (quote best))
 '(gnus-play-startup-jingle t)
 '(gnus-posting-styles
   (quote
    ((".*"
      (organization nil)
      ("From" "Linus Nordberg <linus@nordberg.se>")
      (eval
       (setq smtpmail-smtp-server "smtp.adb-centralen.se" smtpmail-smtp-service 587 smtpmail-smtp-user "linus")
       (set
	(make-local-variable
	 (quote message-sendmail-envelope-from))
	"linus@nordberg.se")))
     ("lists.\\(edri\\|infrastructure\\)"
      ("From" "Linus Nordberg <linus@dfri.se>"))
     ("lists.tor.project"
      ("Reply-To" "tor-project@lists.torproject.org"))
     ("lists.tor..*"
      ("From" "Linus Nordberg <linus@torproject.org>"))
     ("lists.tor.\\(board\\|relays\\|talk\\)"
      ("From" "Linus Nordberg <linus@nordberg.se>"))
     ("lists.pmacct"
      ("From" "Linus Nordberg <linus+pmacct@nordberg.se>")
      (organization "Sunet"))
     ("sunet:\\|ndn:\\|lists\\.\\(ct\\|ietf\\.trans\\|radsecproxy\\)"
      (organization "Sunet")
      ("From" "Linus Nordberg <linus@sunet.se>")
      (eval
       (setq smtpmail-smtp-server "smtp.sunet.se" smtpmail-smtp-service 587 smtpmail-smtp-user "linus")
       (set
	(make-local-variable
	 (quote message-sendmail-envelope-from))
	"linus@sunet.se")))
     ("dfri.abuse"
      ("From" "DFRI Abuse Team <abuse@dfri.net>")
      (eval
       (setq smtpmail-smtp-server "mail.dfri.se" smtpmail-smtp-service 10587 smtpmail-smtp-user "linus@mail.dfri.se")
       (set
	(make-local-variable
	 (quote message-sendmail-envelope-from))
	"abuse@dfri.net"))))))
 '(gnus-select-article-hook (quote (gnus-agent-fetch-selected-article)))
 '(gnus-simplify-ignored-prefixes "^(SV|VB):")
 '(gnus-simplify-subject-functions
   (quote
    (gnus-simplify-subject-re gnus-simplify-subject-fuzzy)))
 '(gnus-summary-resend-default-address nil)
 '(gnus-suppress-duplicates t)
 '(gnus-treat-body-boundary (quote head))
 '(gnus-treat-unsplit-urls t)
 '(gnus-treat-x-pgp-sig (quote head))
 '(gnus-unbuttonized-mime-types nil)
 '(gnus-use-full-window nil)
 '(gnus-user-agent (quote (gnus)))
 '(gnutls-min-prime-bits 2048)
 '(grep-command "grep -nH -Ed skip -e ")
 '(ido-case-fold t)
 '(ido-create-new-buffer (quote always))
 '(ido-enable-regexp t)
 '(ido-mode (quote buffer) nil (ido))
 '(ispell-program-name "/usr/bin/aspell")
 '(jabber-account-list
   (quote
    (("linus@nordu.net/around"
      (:password . "85ZAVPV1yhEdOQvhEN")
      (:network-server . "jabber.nordu.net")
      (:connection-type . starttls)))))
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
 '(message-mode-hook nil)
 '(message-send-mail-function (quote smtpmail-send-it))
 '(message-setup-hook nil)
 '(message-subject-re-regexp
   "^[ 	]*\\(\\([Rr][Ee]\\|[Ss][Vv]\\)\\(\\[[0-9]*\\]\\)*:[ 	]*\\)*[ 	]*")
 '(mm-automatic-display
   (quote
    ("text/plain" "text/x-verbatim" "text/x-vcard" "message/delivery-status" "multipart/.*" "message/rfc822" "text/x-patch" "text/dns" "application/pgp-signature" "application/emacs-lisp" "application/x-emacs-lisp" "application/x-pkcs7-signature" "application/pkcs7-signature" "application/x-pkcs7-mime" "application/pkcs7-mime" "application/pgp\\'" "text/x-org")))
 '(mm-coding-system-priorities (quote (utf-8)))
 '(mm-decrypt-option nil)
 '(mm-default-directory nil)
 '(mm-discouraged-alternatives (quote ("text/html" "text/richtext" "multipart/related")))
 '(mm-enable-external (quote ask))
 '(mm-encrypt-option nil)
 '(mm-html-blocked-images ".*")
 '(mm-html-inhibit-images t)
 '(mm-sign-option nil)
 '(mm-text-html-renderer (quote html2text))
 '(mm-url-use-external t)
 '(mm-verify-option (quote known))
 '(mm-w3m-safe-url-regexp "")
 '(mml-secure-cache-passphrase nil)
 '(mml-secure-key-preferences
   (quote
    ((OpenPGP
      (sign)
      (encrypt
       ("laurent@capas.se" "9A9ECB89712A500531632B851AB2C50C742CD68F")
       ("interminable@riseup.net" "C6405588EC7F4963E340EC6314AD01883268C34C")
       ("leifj@sunet.se" "22FB87637245CAA0999A8C61F09C7C16D6CC6677")
       ("micah@riseup.net" "4777535FE5471562626077B58CBF9A322861A790")
       ("arma@mit.edu" "F65CE37F04BA5B360AE6EE17C218525819F78451")
       ("linus@nordberg.se" "8C4CD511095E982EB0EFBFA21E8BF34923291265")))
     (CMS
      (sign)
      (encrypt)))))
 '(mml-secure-openpgp-always-trust nil)
 '(mml-secure-openpgp-encrypt-to-self t)
 '(mml-secure-openpgp-signers (quote ("0x1E8BF34923291265")))
 '(mml-secure-passphrase-cache-expiry 0)
 '(mml2015-cache-passphrase t)
 '(mml2015-passphrase-cache-expiry 60)
 '(nnimap-dont-close nil)
 '(nnimap-split-download-body nil)
 '(nnmail-extra-headers (quote (Keywords To Newsgroups Cc)))
 '(ns-alternate-modifier (quote meta))
 '(ns-command-modifier (quote meta))
 '(org-agenda-default-appointment-duration 60)
 '(org-agenda-include-diary t)
 '(org-clock-persist (quote history))
 '(org-export-html-postamble nil)
 '(org-odt-preferred-output-format "pdf")
 '(org-use-sub-superscripts nil)
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
 '(smtpmail-local-domain nil)
 '(smtpmail-stream-type (quote starttls))
 '(tags-revert-without-query t)
 '(tls-checktrust (quote ask))
 '(tls-hostmismatch nil)
 '(tls-untrusted
   "- certificate is NOT trusted\\|Verify return code: \\([^0] \\|.[^ ]\\)")
 '(tool-bar-mode nil)
 '(tooltip-mode nil)
 '(twit-minor-mode t)
 '(twit-show-user-images t)
 '(twit-user-image-dir "~/usr/share/images/twitter")
 '(twitter-username "ln4711")
 '(user-full-name "Linus Nordberg")
 '(w3m-command-arguments
   (quote
    ("-o" "use_proxy=1" "-o" "http_proxy=http://127.0.0.1:9050/" "-o" "https_proxy=http://127.0.0.1:9050/" "-o" "ftp_proxy=http://127.0.0.1:9050/")))
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
  "insert oslash."
  (interactive)
  (insert #xf8))

(defun iso-danish-ae-insert nil
  "insert ae."
  (interactive)
  (insert #xe6))

(defun iso-section-insert nil           ; paragraph sign
  "insert section."
  (interactive)
  (insert #xa7))

;; ø - "\370"; Ø - "\330"
;; æ - "\346"; Æ - "\306"
;; ü - "\374"
;; § - "\247"
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

; (add-to-list 'load-path "~/usr/share/emacs/site-lisp/w3m")

;(require 'octet)
;(octet-mime-setup)
;(setq w3m-command-arguments
;              (nconc w3m-command-arguments
;                     '("-o" "http_proxy=http://proxy.hogege.com:8000/")))
;(setq w3m-no-proxy-domains '("local.com" "neighbor.com"))

;(load-file "~/.emacs.ocaml.el")
;(load-file "~/.emacs.slime.el")
;(load-file "~/.emacs.clojure.el")
;(load-file "~/.emacs.haskell.el")
;(load-file "~/.emacs.apache.el")
;(load-file "~/.emacs.krb5.el")



;; AUC TeX
;(load "auctex.el" nil t t)
;(load "preview-latex.el" nil t t)

(put 'narrow-to-page 'disabled nil)

;; Set calendar-date-style outside custom-set-variables -- it gets
;; overwritten with 'european _somewhere_, I wish I knew where.
;; FIXME: This can probably move up again, now that we've removed the
;; stupid european-calendar-style entry. Update: Maybe. Still have trouble.
(calendar-set-date-style 'iso)


;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

;; Disable richtext 'x-display' decoding, see
;; https://www.gnu.org/software/emacs/news/NEWS.25.3
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))

;; don't activate the debugger automagically when errors are
;; encountered
(setq debug-on-error nil)

;; leave the scratch buffer ready for hacking lisp
(lisp-interaction-mode)
(put 'scroll-left 'disabled nil)
