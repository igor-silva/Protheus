#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � PA0127 � Autor �   Fabiano da Silva      � Data � 02.04.07 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ocorrencia                                                 ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � SIGAEST                                                    ���
�������������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


User Function PA0127()

SetPrvt("ARADIO,NRADIO")

aRadio := {"Relatorio ","Grafico"}
nRadio := 1

@ 0,0   TO 110,180 DIALOG oDlg1 TITLE "Ocorrencias"
@ 03,03 TO 50,50 TITLE ""
@ 20,10 RADIO aRadio VAR nRadio

@ 10,55 BMPBUTTON TYPE 6 ACTION VerProg()
@ 30,55 BMPBUTTON TYPE 2 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER

Return


Static Function VerProg()

If nRadio == 1
	Close(oDlg1)
	U_PA0122()
ElseIf nRadio == 2
	Close(oDlg1)
//	U_PA0123()
	U_PA0123A()
Endif

Return