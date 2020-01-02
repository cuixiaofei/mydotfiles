#------------Makefile Autowork------------
#以下这些就是利用Makefile的make命令做的命令集，自定义后方便使用

SHELL := /bin/bash

#快速推送命令,其中update部分可以修改作为提交说明
deploy:
	git add .
	git commit -m "update"
	git push origin master
	git log

#显示分支
br:
	git branch -a
show:
	git remote show

#显示origin分支源地址
showurl:
	git remote show origin


#拷贝现有的库
cloneweb:
	git clone https://github.com/cuixiaofei/mydotfiles.git

