# Compilation flags
set -gx ARCHFLAGS '-arch x86_64'

# Always use en_US and UTF-8 for everything.
set -gx LC_ALL en_US.UTF-8
set -gx LC_CTYPE en_US.UTF-8
set -gx LANG en_US.UTF-8
set -gx LANGUAGE en_US.UTF-8

# Prefer Neovim as the default editor.
set -gx EDITOR vim
set -gx VISUAL vim
# set -gx FILTER fzf

set -gx cabal_helper_libexecdir "$HOME/bin"

# Path for pkgconfig
set -gx PKG_CONFIG_PATH "/opt/homebrew/lib/pkgconfig:/usr/local/opt/openssl/lib/pkgconfig:/usr/local/opt/libffi/lib/pkgconfig:/usr/local/opt/libusb/lib/pkgconfig:/usr/local/opt/openssl@1.1/lib/pkgconfig"

# Set XCode build configuration (Rust, PyEnv and many build tools depend on this!)
# set -gx SDKROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX11.1.sdk"
set -gx SDKROOT "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"

# Add GNU manuals to the MANPATH
set -gx MANPATH \
	/usr/local/opt/coreutils/libexec/gnuman/ \
	/usr/share/man \
	/usr/local/share/man \
	/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/share/man \
	$MANPATH

# Configure the environment variables.
set -gx PATH \
  $HOME/bin \
  $HOME/.local/bin \
  /bin \
  /sbin \
  /opt/X11/bin \
  /opt/homebrew/bin \
  /opt/homebrew/sbin \
  /usr/bin \
  /usr/sbin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/local/opt/coreutils/libexec/gnubin \
  /usr/libexec \
  /Library/Apple/usr/bin

# fix git sign commit
set -gx GPG_TTY (tty)
