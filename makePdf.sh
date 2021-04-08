#! /bin/bash



##############################################################################################
##																							##
##							Author:			KooQix 											##
##							Date:           08.04.2021										##
##																							##
##						    Brief: Convert a bunch of pictures into							##
##						            a PDF file, compressed or not							##
##																 							##
##																							##
##############################################################################################







###### Excute the script in the directory where there are images to convert. These images will be converted and copied in the directory you're in (where you executed the script)

#no parameter is required
if [ "$#" -ne 0 ] && [ $1 != --help ]
then
	echo "ERROR: No parameter is required!"
	exit
fi

if [ "$1" == --help ]
then
	echo -e "\nExcute the script in the directory where the images you want to convert are. These images will be converted inside the directory you're in (where you executed the script).\nI advise you to copy this script into /usr/local/bin to be able to call it from wherever directory you're in. Don't forget to enable the execution of this script before trying to use it.\n\nUse: makePdf.sh in the directory of your pictures to make a pdf from them. You will be asked a few questions:\n\t- If you want to delete the original pictures\n\t- To type the name of the output PDF file\n\t- If you want to compress the PDF file and if so, the quality compression"
	exit
fi


read -p "Do you want to remove orginal images? [Y/n]	" rep

##Take spaces into account
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

name=""
while [ "$name" == "" ] 
do
	read -p "Name of the PDF:	" name
done

#Create a temporary directory where all the pictures will be moved in (in case non-pictures are in the main directory)
mkdir pictures
mv *.jpg *.png pictures
cd pictures

#Convert images into a pdf
echo "Converting pictures into PDF..."
convert * ${name}.pdf
echo "Converting process is done"

read -p "Compress PDF? [Y/n]	" compress

#Compression
if [ "$compress" != n ] 
then
	read -p "Type of compression: \n 1 - Highest quality, 2 - Middle quality and 3 - Low quality\nDefault: Middle quality 	" qualityResp
	if [ "$qualityResp" == 1 ]
	then
		quality="/printer"
	elif [ "$qualityResp" == 3 ]
	then
		quality="/screen"
	else
		quality="/ebook"
	fi

	#convert
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=${quality} -sOutputFile=${name}_compressed.pdf ${name}.pdf

	#replace uncompressed pdf with the compressed one
	rm ${name}.pdf
	mv ${name}_compressed.pdf ${name}.pdf
fi

#Get the pdf out of the temporary directory
mv ${name}.pdf ..

#remove original images if rep != n
if [ "$rep" != n ]
then
	echo "Removing original pictures.."
else		#Move the pictures back to the makle directory and remove the temporary directory
	mv *.png *.jpg ..
fi

#get out of the temporary directory and remove the pictures directory
cd ..				
rm -r pictures
	
IFS=$SAVEIFS

