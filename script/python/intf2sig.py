#!/bin/python3

# !/usr/bin/python

import re
import sys

def prn_out(prt_n):
 prtnn = prt_n.ljust(pnlen+1, ' ')
 if( io_dir=="input" ):
  out_str=intfn+"."+prtnn+" = "+prefx+prt_n+";"
 else:
  out_str=prefx+prtnn+" = "+intfn+"."+prt_n+";"
 print(out_str)



# ------------------------------------------------
arg_n=len(sys.argv)

if( arg_n <= 4):
 print("Progrm "+sys.argv[0]+" need argument")
 print("Usage:")
 print("    "+sys.argv[0]+" sv_intf_file  modport_name  gen_intf_name  gen_sig_prefix")
 print("\nExample0:")
 print("    "+sys.argv[0]+" axi_intf.sv   Master        c2p_axiifu     c2p_aifu_")
 print("\nExample1:")
 print("    "+sys.argv[0]+" axi_intf.sv   Slave         c2p_axidma     c2p_adma_ | sort")
 quit()
else:
#print(sys.argv[1]+" "+sys.argv[2])
 filen = sys.argv[1]
 modpt = sys.argv[2]
 intfn = sys.argv[3]
 prefx = sys.argv[4]


# read in interface file
file_in = open(filen, 'r')
line_al = file_in.readlines()

wline = ""
for line in line_al:
 wline = wline + line.strip() 

# print(wline)
# moddef = re.compile(r'modport\s*(\w+)\s*\(([.|!\)]+)\);')
# moddef = re.compile(r'modport\s*(\w+)\s*\(([\w|,]+)\);')
# moddef = re.compile(#'modport\s*(\w+)\s*\(([\w|,|\s]*)\);')
# mo = moddef.search(wline)
# patn = "modport\s+"+(\w+)+"\s+\(([\w|,|\s]+)\);"
patn = "modport\s+"+modpt+"\s+\(([\w|,|\s]+)\);"
# print(patn)
# mo = re.search("modport\s+(\w+)\s+\(([\w|,|\s]+)\);", wline)
modprt = re.search(patn, wline)

if modprt:
 # found port list definition
 portlst = modprt.group(1)
 plstary = portlst.split(",")

 # port_name length
 pnlen=0
 # find longest port name length
 for prt in plstary:
  prt = prt.replace("input","")
  prt = prt.replace("output","")
  prt=prt.strip()
# print(str(len(prt))+" "+prt+" "+str(pnlen))
  if( pnlen < len(prt) ):
   pnlen = len(prt)



 for prt in plstary:
# print(prt.strip())
  prtt = prt.strip()
  m1=re.search('(\w+)\s+(\w+)', prtt)
  if( m1 ):
#  print("=="+m1.group(1))
#  print("=="+m1.group(2))
   io_dir=m1.group(1)   
   prt_nm=m1.group(2)   

#  if( pnlen < len(prt_nm ):
#   pnlen = len(prt_nm

#  if( io_dir=="input" ):
#   out_str="AAA."+prt_nm+" = yyy_"+prt_nm+";"
#  else:
#   out_str="yyy_"+prt_nm+" = AAA."+prt_nm+";"
#  print(out_str)
   prn_out(prt_nm)

  else:
#  if( io_dir=="input" ):
#   out_str="AAA."+prtt+" = yyy_"+prtt+";"
#  else:
#   out_str="yyy_"+prtt+" = AAA."+prtt+";"
#  print(out_str)

#  if( pnlen < len(prt_nm ):
#   pnlen = len(prt_nm
   prtt=prtt.strip()
   prn_out(prtt)
 
else:
 print('modport \"'+modpt+'\" definition was not found in file: '+filen)


# def prn_out(prt_n):
#  if( io_dir=="input" ):
#   out_str="AAA."+prt_n+" = yyy_"+prt_n+";"
#  else:
#   out_str="yyy_"+prt_n+" = AAA."+prt_n+";"
#  print(out_str)


# print(mo.group(1))
# print(mo.group(2))
