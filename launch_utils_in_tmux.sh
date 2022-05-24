#!/bin/sh

# 自己隨便設定一個 session 名稱
SESSION_NAME="utils"

# 檢查這個 session 本來是否存在
tmux has-session -t ${SESSION_NAME} 2>/dev/null

if [ $? != 0 ]; then
    # 先開啟新的 session
    tmux new-session -s ${SESSION_NAME} -n bash -d
    # 分割出三個 panes
    tmux send-keys -t ${SESSION_NAME} 'tmux split-window -v' C-m
    tmux send-keys -t ${SESSION_NAME} 'tmux split-window -h' C-m
    
    # 把指令先送進 session（只能送進 pane 0），再叫 pane 0 把真指令往 pane 1 & 2 送
    tmux send-keys -t ${SESSION_NAME} 'tmux send-keys -t 2 "cd /" C-m' C-m
    tmux send-keys -t ${SESSION_NAME} 'tmux send-keys -t 2 "jupyter lab --ip="0.0.0.0" --port 8888 --allow-root --no-browser" C-m' C-m
    tmux send-keys -t ${SESSION_NAME} 'tmux send-keys -t 1 "htop" C-m' C-m
    # 砍掉 pane 0，pane 1 會把 pane 0 的那塊畫面吃掉
    tmux send-keys -t ${SESSION_NAME} 'tmux kill-pane -t 0' C-m

    # 這個會開一個新 window 而不是新 pane 所以不用它
    # tmux new-window -n bash -t ${SESSION_NAME}
    # 將畫面切回一開始的 window，不需要也不用它
    # tmux select-window -t ${SESSION_NAME}:0
fi

tmux attach -t ${SESSION_NAME}