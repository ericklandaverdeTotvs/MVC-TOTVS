#INCLUDE "rwmake.ch"

User Function PADAWANES

//���������������������������������������������������������������������Ŀ
//� Declaracion de Variables                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validaci�n para permitir la modificaci�n. Se puede utilizar ExecBlock.
Local cVldExc := ".T." // Validaci�n para permitir el borrado. Se puede utilizar ExecBlock.

Private cString := "ZZ5"

dbSelectArea("ZZ5")
dbSetOrder(1)

AxCadastro(cString,"PADAWANES",cVldExc,cVldAlt)

Return