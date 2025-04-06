source .exports

# ----------------------
# Kitty configuration
# ----------------------

mkdir -p "$KITTY_CONF_DIR"

cat > "$KITTY_CONF_FILE" <<EOF
# Appearance
font_family Fantasque Sans Mono
italic_font auto
bold_font auto
bold_italic_font auto
font_size 12.0
background #282a36
foreground #f8f8f2
disable_audio_bell yes
EOF

echo "kitty configuration written to $KITTY_CONF_FILE" >> $LOG_FILE

