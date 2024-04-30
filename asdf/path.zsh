if uname -a | grep -q arm; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
else
  . /usr/local/opt/asdf/libexec/asdf.sh
fi
