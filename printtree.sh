if [ $# -lt 1 ]
then
  echo "Usage: ./printtree.sh <inputlist> [run]"
  exit 1
fi

now="_printtree_$(date +"%Y_%m_%d__%H_%M_%S")_proddir"
mkdir $now

NAME="printtree.C"
g++ $NAME $(root-config --cflags --libs) -std=c++11 -Werror -Wall -O2 -o "${NAME/%.C/}.exe"

cat <<EOF > "runprint.sh"
if [ \$# -ne 2 ]
then
  echo "Usage: ./printtree.sh <filenum> <inputlist>"
  exit 1
fi

filename=\`head -n\$((1+\$1)) \$2 | tail -n1\`
./printtree.exe \$filename
rm printtree.exe \$2
EOF

chmod +x runprint.sh

cat <<EOF > "printtree.condor"
Universe     = vanilla
Initialdir   = $PWD/$now
Notification = Error
Executable   = $PWD/$now/runprint.sh
Arguments    = \$(Process) $1
GetEnv       = True
Output       = /net/hisrv0001/home/$USER/logs/$now-\$(Process).out
Error        = /net/hisrv0001/home/$USER/logs/$now-\$(Process).err
Log          = /net/hisrv0001/home/$USER/logs/$now-\$(Process).log
Rank         = Mips
+AccountingGroup = "group_cmshi.$USER"
should_transfer_files = YES
when_to_transfer_output = ON_EXIT
transfer_input_files = printtree.exe,$1

Queue `wc -l $1 | awk '{print $1}'`

EOF

cp printtree.exe $1 runprint.sh printtree.condor $now

if [[ "${2}" ]]
then
  echo "\$2 = ${2}"
  condor_submit $now/printtree.condor
fi
