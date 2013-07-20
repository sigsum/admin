;; erc
;(erc-ezb-initialize)

(require 'erc)
;; Need Emacs 21.3.50 (CVS) for *sending* file or *offering* chat.
;(require 'erc-dcc)
;(load "$HOME/usr/gnus/contrib/ssl.el" t)
;(load "$HOME/src/ssl.el" t)

;; SOCKS.
(require 'socks)
(defun use-socks-for-erc (enable-p)
  (if enable-p
      (setq socks-server '("tor" "localhost" 9050 5)
	    socks-noproxy '("localhost")
	    erc-server-connect-function 'socks-open-network-stream)
    (setq erc-server-connect-function 'open-network-stream)))

(setq erc-server "localhost" erc-port 6667)
;; (setq erc-server "irc.oftc.net" erc-port 6697)
;; OFTC through weasels tor HS: 37lnq2veifl4kar7.onion
;; quakenet wineasy.se.quakenet.org
;; ircnet: irc.swipnet.se, irc.ludd.luth.se, irc.okit.se, irc.desync.se
;; freenet: eu.freenode.net (nick: lmn)
;; undernet: stockholm.se.eu.undernet.org
;; dalnet: irc.du.se ???
;; efnet: irc.du.se :6667

;; TODO all these should really go in ~/.emacs (custom-set-variables)
(setq 
 erc-auto-discard-away t
 erc-auto-query 'window-noselect
 erc-auto-set-away nil
 erc-common-server-suffixes '(("openprojects.net$" . "OPN")
			      ("freenode.net$" . "OPN")
			      ("quakenet.org$" . "QN"))
 erc-current-nick-highlight-type (quote nick-or-keyword)
 erc-dcc-mode t
 erc-dcc-verbose t
 erc-disable-ctcp-replies t
 erc-echo-notices-in-minibuffer-flag nil
 erc-encoding-coding-alist nil
 erc-log-channels-directory "~/.priv/irc-logs"
 erc-log-insert-log-on-open nil
 erc-log-mode t
 erc-log-write-after-insert t
 erc-log-write-after-send t
 erc-manual-set-nick-on-bad-nick-p t
 erc-match-mode t
 erc-max-buffer-size 1000000
 erc-minibuffer-ignored t
 erc-minibuffer-notice nil
 erc-modules '(autojoin button completion dcc fill irccontrols keep-place list log match menu move-to-prompt netsplit networks noncommands notify readonly ring stamp track truncate)
 erc-nick-uniquifier "_"
 erc-notify-interval 30
 erc-notify-list (quote ("ioerror" "falfa"))
 erc-notify-mode t
 erc-notify-signon-hook '(erc-notify-signon)
 erc-paranoid t
 erc-pcomplete-mode t
 erc-prompt-for-password nil
 erc-query-display 'window-noselect
 erc-ring-mode t
 erc-save-buffer-on-part nil
 erc-server-coding-system '(utf-8 . undecided)
 erc-show-my-nick t
 erc-stamp-mode t
 erc-system-name "nah"
 erc-timestamp-format "[%m-%d %H:%M]"
 erc-track-exclude-server-buffer t
 erc-track-switch-direction 'newest
 erc-truncate-mode t)

(defun switch-to-irc ()
  "Switch to an IRC buffer, or run `erc-select'.
    When called repeatedly, cycle through the buffers."
  (interactive)
  (let ((buffers (and (fboundp 'erc-buffer-list)
		      (erc-buffer-list))))
    (when (eq (current-buffer) (car buffers))
      (bury-buffer)
      (setq buffers (cdr buffers)))
    (if buffers
	(switch-to-buffer (car buffers))
      (erc-select))))
(global-set-key (kbd "C-c e") 'switch-to-irc)

(defun pick-decoding-system-erc (target)
  (case target
    (t 'utf8)))
