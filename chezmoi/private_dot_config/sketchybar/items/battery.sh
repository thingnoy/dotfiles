BATTERY_CLICK_SCRIPT="open 'x-apple.systempreferences:com.apple.preference.battery'"

# $SKETCHBAR_BIN --add item battery right                                       \
#                --set battery update_freq=10                                   \
#                        icon.padding_left=16                                   \
#                        icon.padding_right=4                                   \
#                        icon.color=0xff9ac868                                  \
#                        icon.y_offset=-1                                       \
#                        label.padding_right=16                                 \
#                        background.color=$BACKGROUND_COLOR                     \
#                        background.height=$BACKGROUND_HEIGHT                   \
#                        background.corner_radius=$BACKGROUND_CORNER_RADIUS     \
#                        background.padding_right=3                             \
#                        script="$PLUGIN_DIR/battery.sh"                        \
#                        click_script="$BATTERY_CLICK_SCRIPT"                   \

sketchybar --add item battery right \
	--set battery update_freq=3 \
	icon.color=$BLACK \
	icon.padding_left=10 \
	label.color=$BLACK \
	label.padding_right=10 \
	background.color=$CYAN \
	background.height=26 \
	background.corner_radius=$CORNER_RADIUS \
	background.padding_right=5 \
	script="$PLUGIN_DIR/battery.sh" \
  click_script="$BATTERY_CLICK_SCRIPT"
