@echo off

(echo sudo.vim) >.git\info\sparse-checkout

git config core.sparsecheckout true
git read-tree -m -u HEAD
