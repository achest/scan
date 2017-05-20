#!/bin/bash -e

## See scanimage --device $(DEVICE) --help
SOURCES[0]="FlatBed"
SOURCES[1]="Automatic Document Feeder(left aligned)"
SOURCES[2]="Automatic Document Feeder(left aligned,Duplex)"
SOURCES[3]="Automatic Document Feeder(centrally aligned)"
SOURCES[4]="Automatic Document Feeder(centrally aligned,Duplex)"
SOURCE=${SOURCES[3]} # Default

RESOLUTIONS=(100 150 200 300 400 600 1200 2400 4800 9600)
RESOLUTION=150	# Default

MODES[0]="Black & White"
MODES[1]="Gray[Error Diffusion]"
MODES[2]="True Gray"
MODES[3]="24bit Color"
MODES[4]="24bit Color[Fast]"
MODE=${MODES[2]}	# Default

DEVICE='brother3:bus1;dev1'


SCANIMAGE_OPTS=' -l 0 -t 0 -x 210 -y 290'


TMPDIR=$(mktemp -d /tmp/scan2pdf.XXXXXXX)
echo create TEMPDIR ${TMPDIR}

DATE=`date +%Y-%m-%d:%H:%M:%S`
OUTFILE=${DATE}$RANDOM.pdf

echo ${OUTFILE}

echo "Temporary files kept in: ${TMPDIR}"

cd ${TMPDIR}

scanimage --device ${DEVICE} ${SCANIMAGE_OPTS} --resolution ${RESOLUTION} --source="${SOURCE}" --mode="${MODE}" --progress --verbose --format=tiff --batch # --batch-prompt


ls -1 out*.tif > /dev/null




tiffcp -c lzw out*.tif scan.tiff

cd -

tiff2pdf -z ${TMPDIR}/scan.tiff > ${OUTFILE}
