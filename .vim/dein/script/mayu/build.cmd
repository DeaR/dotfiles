@echo off

(echo README)    >.git\info\sparse-checkout
(echo LICENSE)  >>.git\info\sparse-checkout
(echo mayu.vim) >>.git\info\sparse-checkout

git config core.sparsecheckout true
git read-tree -m -u HEAD
