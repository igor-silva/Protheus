#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PA0005    �Autor  �Microsiga           � Data �  24/10/01   ���
�������������������������������������������������������������������������͹��
���Desc.     � Gatilho para gerar numero autom�tico no Contas a Pagar     ���
���          � Quando o Tipo for ND ou CI                                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/               

User Function PA0005()


_cAliOri := Alias()
_nOrdORI := IndexOrd()
_nRecORI := Recno()


_cTipo    := ""
_cNum     := ""
dbSelectArea("SE2")
_cAliSE2 := Alias()
_nOrdSE2 := IndexOrd()
_nRecSE2 := Recno()
dbOrderNickname("INDSE21")
If dbSeek(xFilial("SE2")+M->E2_TIPO)

   _cTipo := SE2->E2_TIPO

   While !Eof() .And. _cTipo == SE2->E2_TIPO

      _cNum := SE2->E2_NUM

      dbSeLectArea("SE2")
      dbSkip()
   EndDo   
Endif

_cNum := strzero((Val(_cNum)+1),6)

dbSelectArea(_cAliSE2)
dbSetOrder(_nOrdSE2)
dbGoto(_nRecSE2)

dbSelectArea(_cAliORI)
dbSetOrder(_nOrdORI)
dbGoto(_nRecORI)

Return(_cNum)