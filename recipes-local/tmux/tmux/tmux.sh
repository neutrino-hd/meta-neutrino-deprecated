#!/bin/sh 
tmux new-session -d 
tmux split-window -h
tmux new-window 
tmux new-window 'mc'
tmux split-window -v
tmux split-window -h 
tmux -2 attach-session -d 
