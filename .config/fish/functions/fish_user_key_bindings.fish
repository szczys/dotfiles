function fish_user_key_bindings
  fish_vi_key_bindings

  # Use k-j as escape
  bind -M insert -m default kj backward-char force-repaint

  # timeout for key sequences (don't wait forever when 'k' was last key)
  set -g fish_sequence_key_delay_ms 200
end
