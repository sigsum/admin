[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/usr/bin" ] && export PATH="$HOME/usr/bin:$PATH"
[ -d "$HOME/.local/bin" ] &&  PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/usr/games" ] && export PATH="$PATH:$HOME/usr/games" # For gtetrinet
[ -d "$HOME/.cache/rebar3/bin" ] && export PATH="$PATH:$HOME/.cache/rebar3/bin"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$GOPATH/bin" ] && export PATH="$GOPATH/bin:$PATH"

case $OS_ID in
    debian)
	[ -d "/usr/lib/go-1.19/bin" ] && export PATH="$PATH:/usr/lib/go-1.19/bin"
	;;
esac
