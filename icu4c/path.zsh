if uname -a | grep -q arm; then
  export PATH="/opt/homebrew/opt/icu4c@77/bin:$PATH"
fi
