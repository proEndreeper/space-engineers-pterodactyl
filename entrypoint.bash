#!/bin/bash

# #check if /home/container/config/World is a folder
if [ ! -d "/home/container/World" ]; then
  echo "World folder does not exist, exiting"
  exit 129
fi

# #check if /home/container/config/World/Sandbox.sbc exists and is a file
if [ ! -f "/home/container/World/Sandbox.sbc" ]; then
  echo "Sandbox.sbc file does not exist, exiting."
  exit 130
fi

# #check if /home/container/config/SpaceEngineers-Dedicated.cfg is a file
if [ ! -f "/home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg" ]; then
  echo "SpaceEngineers-Dedicated.cfg file does not exist, exiting."
  exit 131
fi

#set <LoadWorld> to the correct value
cat /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E '/.*LoadWorld.*/c\  <LoadWorld>Z:\\home/container\\World</LoadWorld>' > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#set game port to the correct value
#cat /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E '/.*ServerPort.*/c\  <ServerPort>27016</ServerPort>' > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#configure plugins section in SpaceEngineers-Dedicated.cfg
#get new plugins string

if [ "$(ls -1 /home/container/Plugins/*.dll | wc -l)" -gt "0" ]; then
  PLUGINS_STRING=$(ls -1 /home/container/Plugins/*.dll |\
  awk '{ print "<string>" $0 "</string>" }' |\
  tr -d '\n' |\
  awk '{ print "<Plugins>" $0 "</Plugins>" }' )
else
  PLUGINS_STRING="<Plugins />"
fi

SED_EXPRESSION_EMPTY="s/<Plugins \/>/${PLUGINS_STRING////\\/} /g"
SED_EXPRESSION_FULL="s/<Plugins>.*<\/Plugins>/${PLUGINS_STRING////\\/} /g"

#find and replace in SpaceEngineers-Dedicated.cfg for empty "<Plugins />" element
cat /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "$SED_EXPRESSION_EMPTY" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg

#find and replace in SpaceEngineers-Dedicated.cfg for filled out "<Plugins>...</Plugins>" element
# sed can't handle multiple lines easily, so everything needs to be on a single line.
cat /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg | sed -E "$SED_EXPRESSION_FULL" > /tmp/SpaceEngineers-Dedicated.cfg && cat /tmp/SpaceEngineers-Dedicated.cfg > /home/container/SpaceEngineersDedicated/SpaceEngineers-Dedicated.cfg


bash -c '/Steam/steamcmd.sh +@sSteamCmdForcePlatformType windows +force_install_dir /home/container/SpaceEngineersDedicated +login anonymous +app_update 298740 +quit'
bash -c '/entrypoint-space_engineers.bash'