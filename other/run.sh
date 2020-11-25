#!/usr/bin/env bash

#normal
./merge ./19h.png ./191571778.mp4 ./19t.png ./19out.mp4
#first aac error
./merge ./header.png ./149526245.mp4 ./tail.png ./14out.mp4
#skip begin audio timestamp
./merge ./2/xmly_headPic1563528146.png xmly1562573337.mp4 ./2/xmly_endPic1563528146.png ./xmly15out.mp4
#video frame start time no < 0
./merge ./2/xmly_headPic1563528146.png ./2/xmly1563528144.mp4 ./2/xmly_endPic1563528146.png ./mixout.mp4
#test 25fps timestamp
./merge ./2/xmly_headPic1563528146.png 25fps.mp4 ./2/xmly_endPic1563528146.png ./25fpsout.mp4
#test 30fps timestamp
./merge ./2/xmly_headPic1563528146.png 30fps.mp4 ./2/xmly_endPic1563528146.png ./30fpsout.mp4
#test androiderr timestamp
./merge ./androiderr/header.png ./androiderr/195442678.mp4 ./androiderr/tail.png ./19544out.mp4

#valgrind --leak-check=full --show-leak-kinds=all ./merge ./header.png ./191571778.mp4 ./tail.png ./out.mp4
