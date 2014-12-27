#!/bin/sh
tmux new-session -d
tmux split-window -h
tmux new-window
tmux split-window -v
tmux -2 attach-session -d

