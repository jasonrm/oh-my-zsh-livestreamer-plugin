twitch(){
    local o_player=$1
    local o_stream=$2
    local o_original_resolution=$3
    local o_resize_resolution=$4
    local o_pan=$5

    local screenshot_folder="--screenshot-format=png --screenshot-template=\"${HOME}/${o_stream} - %tY-%tm-%td at %tH.%tM.%tS\""

    local scale=""
    if [ "${o_original_resolution}" != "${o_resize_resolution}p" ]; then
        mplayer_scale="-sws 9 -vf scale=-3:${o_resize_resolution}"
        mpv_scale=""
    else
        scale=""
    fi

    local channels=""
    if [ "${o_pan}" = "left" ]; then
        mplayer_channels="-af channels=2:2:0:0:1:0"
        mpv_channels="-${mplayer_channels}"
    elif [ "${o_pan}" = "right" ]; then
        mplayer_channels="-af channels=2:2:0:1:1:1"
        mpv_channels="-${mplayer_channels}"
    else
        mplayer_channels=""
        mpv_channels=""
    fi

    local player=""
    if [ "${o_player}" = "mplayer" ]; then
        player="/usr/local/bin/mplayer -framedrop -af comp -cache 2048 -cache-min 50 -title ${o_stream} ${mplayer_scale} ${mplayer_channels}"
    elif [ "${o_player}" = "mpv" ]; then
        player="/usr/local/bin/mpv --vo=corevideo --framedrop=yes --hwdec=vda --cache=2048 --cache-min=50 --title=${o_stream} ${mpv_scale} ${mpv_channels} ${screenshot_folder}"
    fi

    /usr/local/bin/livestreamer -v --player "$player" "twitch.tv/${o_stream}" $o_original_resolution
}
