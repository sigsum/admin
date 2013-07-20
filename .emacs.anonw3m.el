(setq w3m-command-arguments
      (nconc w3m-command-arguments
	     '("-o" "use_proxy=1"
	       "-o" "http_proxy=http://127.0.0.1:8118/"
	       "-o" "https_proxy=http://127.0.0.1:8118/"
	       "-o" "ftp_proxy=http://127.0.0.1:8118/")))

