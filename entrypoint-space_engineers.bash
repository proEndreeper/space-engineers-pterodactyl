#!/bin/bash
cd /home/container/SpaceEngineersDedicated/DedicatedServer64/
env WINEARCH=win64 WINEDEBUG=-all WINEPREFIX=/wineprefix wine /home/container/SpaceEngineersDedicated/DedicatedServer64/SpaceEngineersDedicated.exe -noconsole -path Z:\\home\\container\\SpaceEngineersDedicated -ignorelastsession