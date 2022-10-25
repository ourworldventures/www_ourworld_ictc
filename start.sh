tmux kill-session -t www_ourworld_ictc > /dev/null 2>&1
tmux new-session -d -s www_ourworld_ictc 'bash run.sh'
