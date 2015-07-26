twitch(){
    local o_stream=$1
    local o_original_resolution=$2
    local o_resize_resolution=$3
    local o_pan=$4

    local screenshot_folder="--screenshot-format=png --screenshot-template=\"${HOME}/${o_stream} - %tY-%tm-%td at %tH.%tM.%tS\""

    local scale=""
    if [ -n "${o_resize_resolution}" ]; then
        scale="-vf scale=-3:${o_resize_resolution}"
    fi

    local channels=""
    if [ "${o_pan}" = "left" ]; then
        channels="--af channels=2:2:0:0:1:0"
    elif [ "${o_pan}" = "right" ]; then
        channels="--af channels=2:2:0:1:1:1"
    fi

    player="mpv --title=${o_stream} ${scale} ${channels} ${screenshot_folder}"

    livestreamer -v --player "$player" "twitch.tv/${o_stream}" $o_original_resolution
}
