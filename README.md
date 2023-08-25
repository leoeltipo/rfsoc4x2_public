# rfsoc4x2_public
Example projects for RFSoC 4x2 board

### Installing Pynq 3.0
Donwload the Pynq 3.0.1 image from:

http://www.pynq.io/board.html

Follow RFSoC 4x2, v3.0.1 link. You can use any SD Card tool like balenaEtcher or similar to burn this image into the SD Card.

### Copying the files and running the demos.
Copy the folder firmware/pynq into the jupyter_notebooks folder of your board. You can ssh into it. I use WinSCP to copy files from/to the board. Once the files are there, open a web browser and type the board IP: 192.168.2.99. Open the recently copied pynq folder and then click the demo notebook you want. Follow the instructions to run the examples.

### Vivado project.
If you want to modify/add/remove stuff from the FPGA firmware, you can start with the actual Vivado project. Go into firmware/project folder and open Vivado. Make sure Vivado is in that folder before executing the next step. I'm using Vivado 2022.1 so make sure versions match to avoid errors. With the Vivado window open, click Tools->Run Tcl Script... and select proj.tcl. This should build the Vivado project. If you want to implement it, click Generate Bitstream and this will run the entire flow.

