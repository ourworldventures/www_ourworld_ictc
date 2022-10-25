name=$(basename "$PWD")
if [ -z $(tmux list-sessions | grep $name | awk '{ print $1 }') ]; then tmux new-session -d -s $name 'bash run.sh' ; else tmux kill-session -t $name ; tmux new-session -d -s $name 'bash run.sh' ; fi
