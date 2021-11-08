#!/bin/bash
echo "-------------------------------------------------"
echo "Borrando archivos...!"
rm -rf lex.yy.c a.out salida.txt
echo "-------------------------------------------------"
echo "Generando archivo lex.yy.c!"
lex LAB01_Arellano_Castillo_Madrid.l
echo "-------------------------------------------------"
echo "Generando archivo a.out!"
gcc lex.yy.c
echo "-------------------------------------------------"
echo "Corriendo archivo a.out con el archivo de prueba!"
./a.out archivoDePrueba.txt
echo "-------------------------------------------------"
echo "Imprimiendo archivo de entrada"
echo " "
cat salida.txt