#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � PA0232   � Autor � Fabiano da Silva      � Data � 07/11/12 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Fechamento livro fiscal                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/  

User Function PA0232()

SetPrvt("CSAY1,CGET1,")

cSay1 := GETMV("MV_DATAFIS")
cGet1 := CTOD("  /  /  ")
                        
_nOpc := 0
@ 96,42 TO 300,500 DIALOG oDlg1 TITLE "Atualizacao data do fechamento"   
@ 8,10  TO 60,217
@ 80,139 BUTTON "_Ok" SIZE 35,15 ACTION (_nOpc:=1,oDlg1:END())

@ 23,14 Say "Periodo Fechado Ate  : "
@ 43,14 Say "Nova Data Fechamento : "
@ 23,84 GET cSay1 SIZE 50,20 WHEN .F.
@ 43,84 Get cGet1 SIZE 50,20

ACTIVATE DIALOG oDlg1 CENTERED
                     
If _nOpc == 1
	ATUALIZA()
Endif

Return


Static Function Atualiza()

If !Empty(cGet1)
	PUTMV("MV_DATAFIS",DTOC(cGet1))
ELSE
   MSGSTOP("Data n�o pode estar em branco !!!")   
Endif

Return 