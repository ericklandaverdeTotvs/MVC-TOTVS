#INCLUDE "rwmake.ch"

User Function PADAWANES

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracion de Variables                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Local cVldAlt := ".T." // Validaci�n para permitir la modificaci�n. Se puede utilizar ExecBlock.
Local cVldExc := ".T." // Validaci�n para permitir el borrado. Se puede utilizar ExecBlock.

Private cString := "ZZ5"

dbSelectArea("ZZ5")
dbSetOrder(1)

AxCadastro(cString,"PADAWANES",cVldExc,cVldAlt)

Return